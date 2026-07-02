import 'package:drift/drift.dart';
import 'package:flutter_ftv/core/database/app_database.dart';
import 'package:flutter_ftv/core/database/mappers.dart';
import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/core/utils/id_generator.dart';
import 'package:flutter_ftv/features/courts/domain/court.dart';
import 'package:flutter_ftv/features/history/domain/history_event.dart';
import 'package:flutter_ftv/features/history/domain/history_event_type.dart';
import 'package:flutter_ftv/features/sessions/domain/session.dart';
import 'package:flutter_ftv/features/sessions/domain/session_status.dart';

/// Reads and creates sessions (peladas).
abstract interface class SessionsRepository {
  Stream<List<Session>> watchSessions();
  Future<List<Session>> getSessions();
  Future<Session> getSession(SessionId id);

  /// Creates a session together with its courts (A..N) and the initial
  /// `sessionCreated` history event, atomically.
  Future<Session> createSession({
    required String name,
    required int courtCount,
    required int targetPoints,
  });

  /// Updates a session's status and, when [event] is provided, records that
  /// history event in the same transaction (so the status change is always
  /// logged atomically).
  Future<void> updateStatus(
    SessionId id,
    SessionStatus status, {
    HistoryEvent? event,
  });

  /// Permanently removes a session and every row that belongs to it (players,
  /// queue entries, pairs, courts, matches, history) in a single transaction, so
  /// no participant or related data is left orphaned. Irreversible.
  Future<void> deleteSession(SessionId id);
}

class DriftSessionsRepository implements SessionsRepository {
  DriftSessionsRepository(this._db, {IdGenerator? idGenerator})
    : _ids = idGenerator ?? IdGenerator();

  final AppDatabase _db;
  final IdGenerator _ids;

  @override
  Stream<List<Session>> watchSessions() {
    final query = _db.select(_db.sessions)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch().map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  @override
  Future<List<Session>> getSessions() async {
    final query = _db.select(_db.sessions)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    final rows = await query.get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Session> getSession(SessionId id) async {
    final row = await (_db.select(
      _db.sessions,
    )..where((t) => t.id.equals(id.value))).getSingle();
    return row.toDomain();
  }

  @override
  Future<Session> createSession({
    required String name,
    required int courtCount,
    required int targetPoints,
  }) async {
    final now = DateTime.now();
    // `Session.create` enforces the domain invariants (name, courtCount, points).
    final session = Session.create(
      id: SessionId(_ids.next('session')),
      name: name.trim(),
      courtCount: courtCount,
      targetPoints: targetPoints,
      createdAt: now,
    );
    final courts = [
      for (var level = 1; level <= courtCount; level++)
        Court.atLevel(
          id: CourtId(_ids.next('court')),
          sessionId: session.id,
          level: level,
        ),
    ];
    final createdEvent = HistoryEvent(
      id: HistoryEventId(_ids.next('ev')),
      sessionId: session.id,
      type: HistoryEventType.sessionCreated,
      description: 'Session ${session.name} created',
      createdAt: now,
    );

    await _db.transaction(() async {
      await _db.into(_db.sessions).insert(session.toCompanion());
      for (final court in courts) {
        await _db.into(_db.courts).insert(courtToCompanion(court, null));
      }
      await _db.into(_db.historyEvents).insert(createdEvent.toCompanion());
    });
    return session;
  }

  @override
  Future<void> updateStatus(
    SessionId id,
    SessionStatus status, {
    HistoryEvent? event,
  }) async {
    await _db.transaction(() async {
      await (_db.update(
        _db.sessions,
      )..where((t) => t.id.equals(id.value))).write(
        SessionsCompanion(
          status: Value(status.index),
          updatedAt: Value(DateTime.now()),
        ),
      );
      if (event != null) {
        await _db
            .into(_db.historyEvents)
            .insertOnConflictUpdate(event.toCompanion());
      }
    });
  }

  @override
  Future<void> deleteSession(SessionId id) async {
    final value = id.value;
    await _db.transaction(() async {
      // No cascade in the schema: remove every child table by sessionId, then
      // the session row, so nothing is left orphaned.
      await (_db.delete(
        _db.players,
      )..where((t) => t.sessionId.equals(value))).go();
      await (_db.delete(
        _db.playerQueueEntries,
      )..where((t) => t.sessionId.equals(value))).go();
      await (_db.delete(
        _db.pairs,
      )..where((t) => t.sessionId.equals(value))).go();
      await (_db.delete(
        _db.courts,
      )..where((t) => t.sessionId.equals(value))).go();
      await (_db.delete(
        _db.matches,
      )..where((t) => t.sessionId.equals(value))).go();
      await (_db.delete(
        _db.historyEvents,
      )..where((t) => t.sessionId.equals(value))).go();
      await (_db.delete(_db.sessions)..where((t) => t.id.equals(value))).go();
    });
  }
}
