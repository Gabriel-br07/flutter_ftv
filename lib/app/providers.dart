import 'package:flutter_ftv/core/database/app_database.dart';
import 'package:flutter_ftv/core/engine/session_engine.dart';
import 'package:flutter_ftv/core/utils/id_generator.dart';
import 'package:flutter_ftv/features/matches/data/session_state_repository.dart';
import 'package:flutter_ftv/features/sessions/data/sessions_repository.dart';
import 'package:flutter_ftv/features/sessions/domain/session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The Drift database. Overridden with a fake in tests.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
});

final idGeneratorProvider = Provider<IdGenerator>((ref) => IdGenerator());

final sessionsRepositoryProvider = Provider<SessionsRepository>(
  (ref) => DriftSessionsRepository(
    ref.watch(databaseProvider),
    idGenerator: ref.watch(idGeneratorProvider),
  ),
);

final sessionStateRepositoryProvider = Provider<SessionStateRepository>(
  (ref) => DriftSessionStateRepository(ref.watch(databaseProvider)),
);

final sessionEngineProvider = Provider<SessionEngine>((ref) => SessionEngine());

/// Reactive list of all sessions for the sessions-list screen.
final sessionsListProvider = StreamProvider<List<Session>>(
  (ref) => ref.watch(sessionsRepositoryProvider).watchSessions(),
);
