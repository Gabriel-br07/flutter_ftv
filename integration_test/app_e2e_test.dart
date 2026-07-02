import 'package:flutter/material.dart';
import 'package:flutter_ftv/app/app.dart';
import 'package:flutter_ftv/app/providers.dart';
import 'package:flutter_ftv/app/router.dart';
import 'package:flutter_ftv/core/database/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'support/test_database.dart';

/// End-to-end tests driving the real screens, router, controllers, repositories
/// and the Drift-backed rotation engine together.
///
/// Test names and helpers are in English; UI assertions use the app's
/// Brazilian-Portuguese text. Isolation: on native platforms each test runs
/// against a fresh in-memory SQLite database (via [openInMemoryExecutor]); on
/// web (no ffi in-memory executor) the app's real database is used and
/// isolation comes from unique session names per run.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Per-run salt so session names never collide across runs (matters on web,
  // where the database persists).
  var sessionSeq = 0;
  String uniqueSessionName(String base) =>
      '$base ${DateTime.now().millisecondsSinceEpoch}-${sessionSeq++}';

  // --- Helpers ---------------------------------------------------------------

  /// Bounded settle: pumps a fixed number of frames instead of
  /// `pumpAndSettle`, so a screen's infinite loading spinner can never hang the
  /// test. Async Drift work (in-memory) completes well within this window;
  /// real waits use [pumpUntilFound].
  Future<void> settle(WidgetTester tester, {int frames = 10}) async {
    for (var i = 0; i < frames; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  /// Launches the app inside a fresh ProviderScope. When an in-memory executor
  /// is available (native), the database is overridden so every test starts
  /// from a clean, isolated store.
  Future<void> launchApp(WidgetTester tester) async {
    // Use a tall surface so long lists (players/courts) render fully instead of
    // lazily building only the on-screen rows (which would hide later players).
    await tester.binding.setSurfaceSize(const Size(1080, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final executor = openInMemoryExecutor();
    final overrides = [
      if (executor != null)
        databaseProvider.overrideWith((ref) {
          final db = AppDatabase(executor);
          ref.onDispose(db.close);
          return db;
        }),
    ];
    await tester.pumpWidget(
      ProviderScope(overrides: overrides, child: const FtvApp()),
    );
    // `appRouter` is a global singleton, so its location persists across tests.
    // Reset to the sessions list so each test starts from a known screen.
    appRouter.go('/sessions');
    await settle(tester);
  }

  /// Pumps repeatedly until [finder] matches, to let async Drift reads and
  /// StreamProvider rebuilds settle (more robust than a single pumpAndSettle).
  Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    int tries = 60,
    Duration step = const Duration(milliseconds: 100),
  }) async {
    for (var i = 0; i < tries; i++) {
      await tester.pump(step);
      if (finder.evaluate().isNotEmpty) return;
    }
    expect(finder, findsWidgets, reason: 'Timed out waiting for $finder');
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(Key(key)));
    await settle(tester);
  }

  /// Waits for any transient SnackBar to auto-dismiss so it does not cover the
  /// buttons a following step needs to tap (SnackBars overlay the bottom bar).
  Future<void> settleSnackBars(WidgetTester tester) async {
    for (
      var i = 0;
      i < 80 && find.byType(SnackBar).evaluate().isNotEmpty;
      i++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await settle(tester);
  }

  /// Creates a session through the form. [courts] uses the stepper (default 2).
  Future<String> createSession(
    WidgetTester tester, {
    required String baseName,
    required int courts,
    required int targetPoints,
  }) async {
    final name = uniqueSessionName(baseName);
    await tapKey(tester, 'sessionsCreateButton');
    await pumpUntilFound(tester, find.byKey(const Key('sessionNameField')));

    await tester.enterText(find.byKey(const Key('sessionNameField')), name);
    await settle(tester);

    // Court count stepper starts at 2.
    var delta = courts - 2;
    while (delta < 0) {
      await tapKey(tester, 'courtCountDecrementButton');
      delta++;
    }
    while (delta > 0) {
      await tapKey(tester, 'courtCountIncrementButton');
      delta--;
    }

    await tapKey(
      tester,
      targetPoints == 18 ? 'targetPoints18Option' : 'targetPoints15Option',
    );
    await tapKey(tester, 'createSessionSubmitButton');
    await pumpUntilFound(tester, find.text('Jogadores'));
    return name;
  }

  Future<void> addPlayer(WidgetTester tester, String playerName) async {
    await tester.enterText(
      find.byKey(const Key('playerNameField')),
      playerName,
    );
    await settle(tester);
    await tapKey(tester, 'addPlayerButton');
    await pumpUntilFound(tester, find.textContaining(playerName));
  }

  Future<void> addPlayers(WidgetTester tester, List<String> names) async {
    for (final name in names) {
      await addPlayer(tester, name);
    }
  }

  Future<void> formPairs(WidgetTester tester) async {
    await tapKey(tester, 'formPairsButton');
    await pumpUntilFound(tester, find.text('Duplas formadas'));
    await settleSnackBars(tester);
  }

  Future<void> startRound(WidgetTester tester) async {
    // Clear any SnackBar first so it doesn't intercept the button tap.
    await settleSnackBars(tester);
    final button = find.byKey(const Key('startRoundButton'));
    await tester.ensureVisible(button);
    await settle(tester);
    await tester.tap(button);
    await settle(tester);
    await pumpUntilFound(tester, find.byKey(const Key('courtsScreen')));
  }

  Future<void> openHistory(WidgetTester tester) async {
    await tapKey(tester, 'historyButton');
    await pumpUntilFound(tester, find.text('Histórico'));
  }

  const players8 = <String>[
    'Ana',
    'Bruno',
    'Carlos',
    'Diego',
    'Eduarda',
    'Felipe',
    'Gabriel',
    'Helena',
  ];

  // --- Tests -----------------------------------------------------------------

  testWidgets('should_create_session_and_add_players', (tester) async {
    await launchApp(tester);

    // Sessions list opens.
    expect(find.text('Peladas'), findsOneWidget);

    await createSession(
      tester,
      baseName: 'Pelada E2E',
      courts: 2,
      targetPoints: 18,
    );

    // Players screen.
    expect(find.text('Jogadores'), findsOneWidget);

    await addPlayers(tester, players8);

    // Players are listed in arrival order (index-prefixed titles).
    expect(find.text('1. Ana'), findsOneWidget);
    expect(find.text('2. Bruno'), findsOneWidget);
    expect(find.text('8. Helena'), findsOneWidget);

    // Form pairs (stays on players screen; asserts "Duplas formadas") then
    // start the round.
    await formPairs(tester);

    await startRound(tester);

    // Courts screen with two courts.
    expect(find.text('Quadras'), findsOneWidget);
    expect(find.text('Quadra A'), findsOneWidget);
    expect(find.text('Quadra B'), findsOneWidget);
    expect(find.byKey(const Key('courtACard')), findsOneWidget);
    expect(find.byKey(const Key('courtBCard')), findsOneWidget);
  });

  testWidgets('should_show_waiting_player_when_player_count_is_odd', (
    tester,
  ) async {
    await launchApp(tester);

    await createSession(
      tester,
      baseName: 'Pelada Ímpar',
      courts: 1,
      targetPoints: 15,
    );

    await addPlayers(tester, const [
      'Ana',
      'Bruno',
      'Carlos',
      'Diego',
      'Eduarda',
    ]);

    await formPairs(tester);

    // The odd (fifth) player is shown as waiting for a pair.
    await pumpUntilFound(tester, find.text('Jogador aguardando dupla'));
    expect(find.text('Jogador aguardando dupla'), findsOneWidget);

    // Eduarda arrived last and is the one waiting.
    expect(find.textContaining('Eduarda'), findsWidgets);
  });

  testWidgets('should_send_manual_pair_to_end_of_queue', (tester) async {
    await launchApp(tester);

    await createSession(
      tester,
      baseName: 'Pelada Manual',
      courts: 2,
      targetPoints: 18,
    );

    await addPlayers(tester, const [
      'Ana',
      'Bruno',
      'Carlos',
      'Diego',
      'Eduarda',
      'Felipe',
    ]);

    // Manually choose the last two players (Eduarda + Felipe) as a pair.
    await tester.tap(find.text('5. Eduarda'));
    await tester.pump();
    await tester.tap(find.text('6. Felipe'));
    await settle(tester);

    await tapKey(tester, 'manualPairButton');

    // Feedback confirms the manual pair went to the end of the queue.
    await pumpUntilFound(
      tester,
      find.text('Dupla escolhida enviada para o final da fila'),
    );
    expect(
      find.text('Dupla escolhida enviada para o final da fila'),
      findsWidgets,
    );

    // Starting the round, the manually chosen pair does not take Court A (the
    // main court): earlier automatic pairs get priority there.
    await startRound(tester);
    final courtA = find.byKey(const Key('courtACard'));
    expect(courtA, findsOneWidget);
    expect(
      find.descendant(of: courtA, matching: find.textContaining('Eduarda')),
      findsNothing,
    );
  });

  testWidgets('should_register_match_winner_and_create_history_event', (
    tester,
  ) async {
    await launchApp(tester);

    await createSession(
      tester,
      baseName: 'Pelada Resultado',
      courts: 2,
      targetPoints: 18,
    );

    await addPlayers(tester, players8);
    await formPairs(tester);
    await startRound(tester);

    // Courts screen is open.
    expect(find.byKey(const Key('courtsScreen')), findsOneWidget);

    // Record a winner on Court A.
    await tapKey(tester, 'courtAWinnerPairOneButton');
    await pumpUntilFound(tester, find.text('Resultado registrado'));
    expect(find.text('Resultado registrado'), findsWidgets);
    await settleSnackBars(tester);

    // History screen shows at least one recorded event.
    await openHistory(tester);
    expect(find.text('Histórico'), findsOneWidget);
    expect(find.byKey(const Key('historyScreen')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('historyScreen')),
        matching: find.byType(ListTile),
      ),
      findsWidgets,
    );
  });
}
