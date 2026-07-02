import 'package:drift/drift.dart';
import 'package:flutter_ftv/core/database/app_database.dart';
import 'package:flutter_ftv/core/database/mappers.dart';
import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/matches/domain/court_slot.dart';
import 'package:flutter_ftv/features/matches/domain/rotation_state.dart';

/// Loads and persists the full [RotationState] of a session.
abstract interface class SessionStateRepository {
  Future<RotationState> loadState(SessionId sessionId);

  /// Persists [state] atomically (full replace of the session's rows).
  Future<void> saveState(RotationState state);
}

class DriftSessionStateRepository implements SessionStateRepository {
  DriftSessionStateRepository(this._db);

  final AppDatabase _db;

  @override
  Future<RotationState> loadState(SessionId sessionId) async {
    final id = sessionId.value;

    final sessionRow = await (_db.select(
      _db.sessions,
    )..where((t) => t.id.equals(id))).getSingle();

    final playerRows =
        await (_db.select(_db.players)
              ..where((t) => t.sessionId.equals(id))
              ..orderBy([(t) => OrderingTerm.asc(t.arrivalOrder)]))
            .get();

    final queueRows =
        await (_db.select(_db.playerQueueEntries)
              ..where((t) => t.sessionId.equals(id))
              ..orderBy([(t) => OrderingTerm.asc(t.position)]))
            .get();

    final pairRows = await (_db.select(
      _db.pairs,
    )..where((t) => t.sessionId.equals(id))).get();

    final courtRows =
        await (_db.select(_db.courts)
              ..where((t) => t.sessionId.equals(id))
              ..orderBy([(t) => OrderingTerm.asc(t.level)]))
            .get();

    final matchRows = await (_db.select(
      _db.matches,
    )..where((t) => t.sessionId.equals(id))).get();

    // Order by the implicit SQLite rowid, not createdAt: every event generated
    // within a single transition shares one timestamp, so createdAt alone leaves
    // their order undefined. `saveState` rewrites the whole history in creation
    // order on every write, so ascending rowid == creation order, deterministically.
    final historyRows =
        await (_db.select(_db.historyEvents)
              ..where((t) => t.sessionId.equals(id))
              ..orderBy([
                (t) => OrderingTerm.asc(const CustomExpression<int>('_rowid_')),
              ]))
            .get();

    return RotationState(
      session: sessionRow.toDomain(),
      roster: playerRows.map((r) => r.toDomain()).toList(),
      queue: queueRows.map((r) => PlayerId(r.playerId)).toList(),
      courts: courtRows.map((r) => r.toDomain()).toList(),
      pairs: pairRows.map((r) => r.toDomain()).toList(),
      slots: courtRows.map((r) => r.toSlot()).toList(),
      matches: matchRows.map((r) => r.toDomain()).toList(),
      history: historyRows.map((r) => r.toDomain()).toList(),
    );
  }

  @override
  Future<void> saveState(RotationState state) async {
    final id = state.session.id.value;
    await _db.transaction(() async {
      // Full replace of the session's mutable rows (history included, so undo
      // that restores a prior state also removes the undone events).
      await (_db.delete(
        _db.players,
      )..where((t) => t.sessionId.equals(id))).go();
      await (_db.delete(
        _db.playerQueueEntries,
      )..where((t) => t.sessionId.equals(id))).go();
      await (_db.delete(_db.pairs)..where((t) => t.sessionId.equals(id))).go();
      await (_db.delete(_db.courts)..where((t) => t.sessionId.equals(id))).go();
      await (_db.delete(
        _db.matches,
      )..where((t) => t.sessionId.equals(id))).go();
      await (_db.delete(
        _db.historyEvents,
      )..where((t) => t.sessionId.equals(id))).go();

      await _db
          .into(_db.sessions)
          .insertOnConflictUpdate(state.session.toCompanion());

      await _db.batch((batch) {
        batch.insertAll(
          _db.players,
          state.roster.map((p) => p.toCompanion()).toList(),
        );
        batch.insertAll(_db.playerQueueEntries, [
          for (var i = 0; i < state.queue.length; i++)
            PlayerQueueEntriesCompanion.insert(
              sessionId: id,
              playerId: state.queue[i].value,
              position: i,
            ),
        ]);
        batch.insertAll(
          _db.pairs,
          state.pairs.map((p) => p.toCompanion()).toList(),
        );
        batch.insertAll(_db.courts, [
          for (final court in state.courts)
            courtToCompanion(court, _slotFor(state, court.id)),
        ]);
        batch.insertAll(
          _db.matches,
          state.matches.map((m) => m.toCompanion()).toList(),
        );
        batch.insertAll(
          _db.historyEvents,
          state.history.map((e) => e.toCompanion()).toList(),
        );
      });
    });
  }

  CourtSlot? _slotFor(RotationState state, CourtId courtId) =>
      state.slotForCourt(courtId);
}
