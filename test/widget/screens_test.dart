import 'package:flutter/material.dart';
import 'package:flutter_ftv/app/providers.dart';
import 'package:flutter_ftv/features/courts/presentation/courts_screen.dart';
import 'package:flutter_ftv/features/history/presentation/history_screen.dart';
import 'package:flutter_ftv/features/players/presentation/players_screen.dart';
import 'package:flutter_ftv/features/sessions/domain/session.dart';
import 'package:flutter_ftv/features/sessions/domain/session_status.dart';
import 'package:flutter_ftv/features/sessions/presentation/create_session_screen.dart';
import 'package:flutter_ftv/features/sessions/presentation/sessions_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes.dart';
import '../support/fixtures.dart';

void main() {
  testWidgets('sessions list shows empty state when there are no sessions', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionsListProvider.overrideWith((ref) => Stream.value(<Session>[])),
        ],
        child: const MaterialApp(home: SessionsListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nenhuma pelada criada'), findsOneWidget);
    expect(find.text('Criar pelada'), findsOneWidget);
  });

  testWidgets('create session shows validation error for a blank name', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: CreateSessionScreen())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Criar'));
    await tester.pumpAndSettle();

    expect(find.text('Informe o nome da pelada'), findsOneWidget);
  });

  testWidgets('courts screen renders one card per court', (tester) async {
    final seed = makeState(roster: const [], courts: makeCourts(2));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStateRepositoryProvider.overrideWithValue(
            FakeSessionStateRepository({seed.session.id.value: seed}),
          ),
        ],
        child: MaterialApp(home: CourtsScreen(sessionId: testSessionId.value)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Quadra A'), findsOneWidget);
    expect(find.text('Quadra B'), findsOneWidget);
  });

  testWidgets('courts screen adds a player to the queue via the app bar', (
    tester,
  ) async {
    final seed = makeState(roster: const [], courts: makeCourts(1));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStateRepositoryProvider.overrideWithValue(
            FakeSessionStateRepository({seed.session.id.value: seed}),
          ),
        ],
        child: MaterialApp(home: CourtsScreen(sessionId: testSessionId.value)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('addPlayerButton')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('courtsPlayerNameField')),
      'Zé',
    );
    await tester.tap(find.byKey(const Key('courtsConfirmAddPlayerButton')));
    await tester.pumpAndSettle();

    // The new player shows up in the always-visible queue.
    expect(find.textContaining('Zé'), findsWidgets);
  });

  testWidgets('players screen shows a chosen pair in the "Duplas formadas" '
      'section and keeps the rest individual', (tester) async {
    final players = makePlayers(4); // p1..p4 queued
    final seed = makeState(roster: players, courts: makeCourts(1));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStateRepositoryProvider.overrideWithValue(
            FakeSessionStateRepository({seed.session.id.value: seed}),
          ),
          sessionsRepositoryProvider.overrideWithValue(
            FakeSessionsRepository(),
          ),
        ],
        child: MaterialApp(home: PlayersScreen(sessionId: testSessionId.value)),
      ),
    );
    await tester.pumpAndSettle();

    // Select the first two players and choose a pair.
    await tester.tap(find.byType(Checkbox).at(0));
    await tester.tap(find.byType(Checkbox).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('manualPairButton')));
    await tester.pumpAndSettle();

    // The pair shows under "Duplas formadas" and the other two stay individual.
    expect(find.text('Ordem de chegada'), findsOneWidget);
    expect(find.text('Duplas formadas'), findsOneWidget);
    expect(find.text('Escolhida'), findsOneWidget);
  });

  testWidgets('players screen imports a pasted list of participants', (
    tester,
  ) async {
    final seed = makeState(roster: const [], courts: makeCourts(1));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStateRepositoryProvider.overrideWithValue(
            FakeSessionStateRepository({seed.session.id.value: seed}),
          ),
          sessionsRepositoryProvider.overrideWithValue(
            FakeSessionsRepository(),
          ),
        ],
        child: MaterialApp(home: PlayersScreen(sessionId: testSessionId.value)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('importParticipantsButton')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('importTextField')),
      '1. Luan\n2. Lucas\n3. Felipe',
    );
    await tester.pumpAndSettle();
    // Preview reports the recognized names.
    expect(find.text('3 participantes encontrados:'), findsOneWidget);

    await tester.tap(find.byKey(const Key('importConfirmButton')));
    await tester.pumpAndSettle();

    // The imported names show up in the queue list.
    expect(find.textContaining('Luan'), findsWidgets);
    expect(find.textContaining('Felipe'), findsWidgets);
  });

  testWidgets('deletes a finished session from the list after confirmation', (
    tester,
  ) async {
    final repo = FakeSessionsRepository();
    await repo.createSession(name: 'Alpha', courtCount: 1, targetPoints: 15);
    final id = (await repo.getSessions()).single.id;
    await repo.updateStatus(id, SessionStatus.finished);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionsRepositoryProvider.overrideWithValue(repo),
          sessionStateRepositoryProvider.overrideWithValue(
            FakeSessionStateRepository(),
          ),
        ],
        child: const MaterialApp(home: SessionsListScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsOneWidget);

    await tester.tap(find.byKey(Key('deleteSessionButton-${id.value}')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirmDeleteButton')));
    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsNothing);
  });

  testWidgets('cancelling the delete dialog keeps the session', (tester) async {
    final repo = FakeSessionsRepository();
    await repo.createSession(name: 'Alpha', courtCount: 1, targetPoints: 15);
    final id = (await repo.getSessions()).single.id;
    await repo.updateStatus(id, SessionStatus.finished);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionsRepositoryProvider.overrideWithValue(repo),
          sessionStateRepositoryProvider.overrideWithValue(
            FakeSessionStateRepository(),
          ),
        ],
        child: const MaterialApp(home: SessionsListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('deleteSessionButton-${id.value}')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsOneWidget);
  });

  testWidgets('finishes an active session from the list menu', (tester) async {
    final repo = FakeSessionsRepository();
    await repo.createSession(name: 'Beta', courtCount: 1, targetPoints: 15);
    final id = (await repo.getSessions()).single.id;
    await repo.updateStatus(id, SessionStatus.active);
    final seed = makeState(roster: makePlayers(2), courts: makeCourts(1));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionsRepositoryProvider.overrideWithValue(repo),
          sessionStateRepositoryProvider.overrideWithValue(
            FakeSessionStateRepository({id.value: seed}),
          ),
        ],
        child: const MaterialApp(home: SessionsListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('finishSessionButton-${id.value}')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirmFinishButton')));
    await tester.pumpAndSettle();

    // The status chip now reads "Finalizada".
    expect(find.text('Finalizada'), findsOneWidget);
  });

  testWidgets('history screen shows empty state when there are no events', (
    tester,
  ) async {
    final seed = makeState(roster: const []);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStateRepositoryProvider.overrideWithValue(
            FakeSessionStateRepository({seed.session.id.value: seed}),
          ),
        ],
        child: MaterialApp(home: HistoryScreen(sessionId: testSessionId.value)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nenhum evento registrado'), findsOneWidget);
  });
}
