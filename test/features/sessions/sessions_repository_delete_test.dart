import 'package:drift/native.dart';
import 'package:flutter_ftv/core/database/app_database.dart';
import 'package:flutter_ftv/features/sessions/data/sessions_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Drift-backed test (in-memory SQLite) proving that deleting a session removes
/// every related row, so no participant is left orphaned.
void main() {
  late AppDatabase db;
  late DriftSessionsRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftSessionsRepository(db);
  });

  tearDown(() => db.close());

  test('deleteSession removes the session and all its child rows', () async {
    final session = await repo.createSession(
      name: 'X',
      courtCount: 2,
      targetPoints: 15,
    );
    final sid = session.id.value;
    // A participant plus its queue entry.
    await db
        .into(db.players)
        .insert(
          PlayersCompanion.insert(
            id: 'p1',
            sessionId: sid,
            name: 'Ana',
            arrivalOrder: 0,
            status: 0,
          ),
        );
    await db
        .into(db.playerQueueEntries)
        .insert(
          PlayerQueueEntriesCompanion.insert(
            sessionId: sid,
            playerId: 'p1',
            position: 0,
          ),
        );

    await repo.deleteSession(session.id);

    expect(await db.select(db.sessions).get(), isEmpty);
    expect(await db.select(db.players).get(), isEmpty);
    expect(await db.select(db.playerQueueEntries).get(), isEmpty);
    expect(await db.select(db.courts).get(), isEmpty);
    expect(await db.select(db.historyEvents).get(), isEmpty);
  });
}
