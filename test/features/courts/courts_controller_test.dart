import 'package:flutter_ftv/app/providers.dart';
import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/courts/presentation/courts_controller.dart';
import 'package:flutter_ftv/features/history/domain/history_event_type.dart';
import 'package:flutter_ftv/features/matches/data/session_state_repository.dart';
import 'package:flutter_ftv/features/matches/domain/rotation_state.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_status.dart';
import 'package:flutter_ftv/features/players/domain/player_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';
import '../../support/fixtures.dart';

/// A state repository that loads a seed but always fails to persist.
class _FailingSaveStateRepository implements SessionStateRepository {
  _FailingSaveStateRepository(this._seed);

  final RotationState _seed;

  @override
  Future<RotationState> loadState(SessionId sessionId) async => _seed;

  @override
  Future<void> saveState(RotationState state) async =>
      throw StateError('save failed');
}

void main() {
  late FakeSessionStateRepository stateRepo;

  RotationState seedActiveMatch() {
    final courtA = makeCourt(1);
    final players = makePlayers(4, status: PlayerStatus.playing);
    final a1 = makePair('A1', players[0], players[1]);
    final a2 = makePair('A2', players[2], players[3]);
    final match = makeMatch('m1', courtA, a1, a2);
    return makeState(
      roster: players,
      courts: [courtA],
      pairs: [a1, a2],
      slots: [activeSlot(courtA, a1, a2, match)],
      matches: [match],
      queue: const [],
    );
  }

  ProviderContainer makeContainer(RotationState seed) {
    stateRepo = FakeSessionStateRepository({seed.session.id.value: seed});
    final container = ProviderContainer(
      overrides: [
        sessionStateRepositoryProvider.overrideWithValue(stateRepo),
        sessionsRepositoryProvider.overrideWithValue(FakeSessionsRepository()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('should_delegate_result_to_engine_and_persist', () async {
    final seed = seedActiveMatch();
    final container = makeContainer(seed);
    final controller = container.read(courtsControllerProvider.notifier);

    await controller.load(testSessionId.value);
    await controller.recordResult(
      matchId: const MatchId('m1'),
      winnerPairId: const PairId('A1'),
    );

    final state = container.read(courtsControllerProvider);
    // Winner reigns on Court A; the persisted state reflects the rotation.
    expect(
      state.state!.slotForCourt(seed.courts.first.id)!.homePairId?.value,
      'A1',
    );
    expect(state.canUndo, isTrue);
    expect(
      stateRepo
          .saved(testSessionId.value)!
          .pairById(const PairId('A2'))!
          .status,
      PairStatus.dissolved,
    );
  });

  test('should_restore_previous_state_on_undo', () async {
    final seed = seedActiveMatch();
    final container = makeContainer(seed);
    final controller = container.read(courtsControllerProvider.notifier);

    await controller.load(testSessionId.value);
    await controller.recordResult(
      matchId: const MatchId('m1'),
      winnerPairId: const PairId('A1'),
    );
    await controller.undo();

    // The losing pair A2 is active again after undo.
    final restored = stateRepo.saved(testSessionId.value)!;
    expect(restored.pairById(const PairId('A2')), isNotNull);
    expect(
      container.read(courtsControllerProvider).infoMessage,
      'Ação desfeita',
    );
  });

  test('should_not_enable_undo_when_save_fails', () async {
    final seed = seedActiveMatch();
    final container = ProviderContainer(
      overrides: [
        sessionStateRepositoryProvider.overrideWithValue(
          _FailingSaveStateRepository(seed),
        ),
        sessionsRepositoryProvider.overrideWithValue(FakeSessionsRepository()),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(courtsControllerProvider.notifier);

    await controller.load(testSessionId.value);
    await controller.recordResult(
      matchId: const MatchId('m1'),
      winnerPairId: const PairId('A1'),
    );

    // The save failed, so undo must not be offered for an action that was never
    // persisted.
    final state = container.read(courtsControllerProvider);
    expect(state.errorMessage, isNotNull);
    expect(state.canUndo, isFalse);
  });

  test('should_add_player_to_end_of_queue_during_active_session', () async {
    final seed = seedActiveMatch();
    final container = makeContainer(seed);
    final controller = container.read(courtsControllerProvider.notifier);

    await controller.load(testSessionId.value);
    await controller.addPlayer('Novo Jogador');

    final saved = stateRepo.saved(testSessionId.value)!;
    // New player sits at the end of the queue; the active match is untouched.
    expect(saved.queuedPlayers.last.name, 'Novo Jogador');
    expect(saved.activeMatchOnCourt(seed.courts.first.id)!.id.value, 'm1');
    expect(saved.hasUniqueActivePlayers, isTrue);
  });

  test('should_mark_newly_added_player_for_queue_highlight', () async {
    final seed = seedActiveMatch();
    final container = makeContainer(seed);
    final controller = container.read(courtsControllerProvider.notifier);

    await controller.load(testSessionId.value);
    await controller.addPlayer('Novo Jogador');

    final saved = stateRepo.saved(testSessionId.value)!;
    final added = saved.queuedPlayers.firstWhere(
      (p) => p.name == 'Novo Jogador',
    );
    expect(
      container.read(courtsControllerProvider).recentlyAddedPlayerId,
      added.id.value,
    );
  });

  test('should_block_duplicate_name_and_warn', () async {
    final seed = seedActiveMatch(); // players are named 'Player 1'..'Player 4'
    final container = makeContainer(seed);
    final controller = container.read(courtsControllerProvider.notifier);

    await controller.load(testSessionId.value);
    await controller.addPlayer('player 1');

    final state = container.read(courtsControllerProvider);
    expect(state.errorMessage, contains('Já existe um jogador'));
    // The state was not changed / re-saved with a new player.
    expect(state.state!.roster, hasLength(4));
  });

  test('should_clear_pending_undo_after_adding_a_player', () async {
    final seed = seedActiveMatch();
    final container = makeContainer(seed);
    final controller = container.read(courtsControllerProvider.notifier);

    await controller.load(testSessionId.value);
    await controller.recordResult(
      matchId: const MatchId('m1'),
      winnerPairId: const PairId('A1'),
    );
    expect(container.read(courtsControllerProvider).canUndo, isTrue);

    await controller.addPlayer('Novo Jogador');

    // Undo is disabled so a later undo cannot silently drop the new player.
    expect(container.read(courtsControllerProvider).canUndo, isFalse);
  });

  test('should_record_session_finished_event_on_finish', () async {
    final seed = seedActiveMatch();
    final sessionsRepo = FakeSessionsRepository();
    final container = ProviderContainer(
      overrides: [
        sessionStateRepositoryProvider.overrideWithValue(
          FakeSessionStateRepository({seed.session.id.value: seed}),
        ),
        sessionsRepositoryProvider.overrideWithValue(sessionsRepo),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(courtsControllerProvider.notifier);

    await controller.load(testSessionId.value);
    final done = await controller.finishSession();

    expect(done, isTrue);
    expect(
      sessionsRepo.recordedEvents.map((e) => e.type),
      contains(HistoryEventType.sessionFinished),
    );
  });
}
