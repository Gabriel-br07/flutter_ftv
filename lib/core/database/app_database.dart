import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Sessions (peladas). Enum-typed columns store the enum `index`.
@DataClassName('SessionRow')
class Sessions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get courtCount => integer()();
  IntColumn get targetPoints => integer()();
  IntColumn get status => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Players of a session, tracked individually.
@DataClassName('PlayerRow')
class Players extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get name => text()();
  IntColumn get arrivalOrder => integer()();
  IntColumn get status => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Ordered individual player queue (position ascending = front to back).
@DataClassName('PlayerQueueEntryRow')
class PlayerQueueEntries extends Table {
  TextColumn get sessionId => text()();
  TextColumn get playerId => text()();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {sessionId, playerId};
}

/// Temporary pairs, including dissolved ones (kept so finished matches that
/// reference a loser pair still resolve after a reload).
@DataClassName('PairRow')
class Pairs extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get playerOneId => text()();
  TextColumn get playerTwoId => text()();
  IntColumn get origin => integer()();
  IntColumn get status => integer()();
  IntColumn get queueOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Courts of the ladder, with the current [CourtSlot] embedded as nullable
/// home/challenger/match references.
@DataClassName('CourtRow')
class Courts extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get name => text()();
  IntColumn get level => integer()();
  IntColumn get status => integer()();
  TextColumn get homePairId => text().nullable()();
  TextColumn get challengerPairId => text().nullable()();
  TextColumn get matchId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Matches (winner/loser only; no point-by-point scoring).
@DataClassName('MatchRow')
class Matches extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get courtId => text()();
  TextColumn get pairOneId => text()();
  TextColumn get pairTwoId => text()();
  TextColumn get winnerPairId => text().nullable()();
  TextColumn get loserPairId => text().nullable()();
  IntColumn get status => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Append-only history log.
@DataClassName('HistoryEventRow')
class HistoryEvents extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  IntColumn get type => integer()();
  TextColumn get description => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Sessions,
    Players,
    PlayerQueueEntries,
    Pairs,
    Courts,
    Matches,
    HistoryEvents,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens the on-device database (Android/desktop) via `drift_flutter`.
  factory AppDatabase.open() => AppDatabase(driftDatabase(name: 'flutter_ftv'));

  @override
  int get schemaVersion => 1;
}
