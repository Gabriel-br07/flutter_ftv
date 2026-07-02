import 'package:flutter_ftv/app/providers.dart';
import 'package:flutter_ftv/features/history/domain/history_event_type.dart';
import 'package:flutter_ftv/features/matches/domain/rotation_state.dart';
import 'package:flutter_ftv/features/players/domain/player_status.dart';
import 'package:flutter_ftv/features/players/presentation/players_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';
import '../../support/fixtures.dart';

void main() {
  ProviderContainer makeContainer(RotationState seed) {
    final container = ProviderContainer(
      overrides: [
        sessionStateRepositoryProvider.overrideWithValue(
          FakeSessionStateRepository({seed.session.id.value: seed}),
        ),
        sessionsRepositoryProvider.overrideWithValue(FakeSessionsRepository()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('should_add_player_to_the_queue', () async {
    final seed = makeState(roster: const [], courts: makeCourts(1));
    final container = makeContainer(seed);
    final controller = container.read(playersControllerProvider.notifier);

    await controller.load(testSessionId.value);
    await controller.addPlayer('Ana');

    final rotation = container.read(playersControllerProvider).state!;
    expect(rotation.roster, hasLength(1));
    expect(rotation.roster.single.name, 'Ana');
    expect(rotation.queue, hasLength(1));
  });

  test('should_create_manual_pair_from_two_available_players', () async {
    final players = makePlayers(2);
    final seed = makeState(roster: players, courts: makeCourts(1));
    final container = makeContainer(seed);
    final controller = container.read(playersControllerProvider.notifier);

    await controller.load(testSessionId.value);
    await controller.createManualPair(players[0].id, players[1].id);

    final state = container.read(playersControllerProvider);
    expect(state.infoMessage, 'Dupla escolhida enviada para o final da fila');
    expect(state.state!.pairs, hasLength(1));
  });

  test('should_dissolve_a_formed_pair_and_return_players_to_queue', () async {
    final players = makePlayers(4);
    final seed = makeState(roster: players, courts: makeCourts(1));
    final container = makeContainer(seed);
    final controller = container.read(playersControllerProvider.notifier);

    await controller.load(testSessionId.value);
    await controller.createManualPair(players[0].id, players[1].id);
    final pairId = container
        .read(playersControllerProvider)
        .state!
        .pairs
        .single
        .id;
    await controller.dissolvePair(pairId);

    final playersState = container.read(playersControllerProvider);
    expect(playersState.state!.pairs, isEmpty);
    expect(playersState.state!.queue, hasLength(4));
    expect(playersState.infoMessage, 'Dupla desfeita');
  });

  test('should_import_names_adding_new_ones_and_reporting_the_count', () async {
    final existing = makePlayers(1); // "Player 1"
    final seed = makeState(roster: existing, courts: makeCourts(1));
    final container = makeContainer(seed);
    final controller = container.read(playersControllerProvider.notifier);

    await controller.load(testSessionId.value);
    await controller.importPlayers(['Ana', 'Bruno', 'Player 1']);

    final playersState = container.read(playersControllerProvider);
    // Two new players added; the existing one is skipped as a duplicate.
    expect(playersState.state!.queue, hasLength(3));
    expect(
      playersState.state!.queuedPlayers.map((p) => p.name),
      containsAll(['Ana', 'Bruno']),
    );
    expect(playersState.infoMessage, contains('2 participantes importados'));
  });

  test('should_report_error_when_import_has_no_new_names', () async {
    final existing = makePlayers(1);
    final seed = makeState(roster: existing, courts: makeCourts(1));
    final container = makeContainer(seed);
    final controller = container.read(playersControllerProvider.notifier);

    await controller.load(testSessionId.value);
    await controller.importPlayers(['Player 1']);

    expect(
      container.read(playersControllerProvider).errorMessage,
      'Nenhum nome novo para importar.',
    );
  });

  test('should_record_session_started_event_on_start', () async {
    final players = makePlayers(4);
    final seed = makeState(
      roster: players,
      courts: makeCourts(1),
      queue: [for (final p in players) p.id],
    );
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
    final controller = container.read(playersControllerProvider.notifier);

    await controller.load(testSessionId.value);
    final started = await controller.start();

    expect(started, isTrue);
    expect(
      sessionsRepo.recordedEvents.map((e) => e.type),
      contains(HistoryEventType.sessionStarted),
    );
  });

  test('should_reject_manual_pair_with_unavailable_player', () async {
    final players = [
      makePlayer(1),
      makePlayer(2, status: PlayerStatus.playing),
    ];
    final seed = makeState(
      roster: players,
      courts: makeCourts(1),
      queue: [players[0].id],
    );
    final container = makeContainer(seed);
    final controller = container.read(playersControllerProvider.notifier);

    await controller.load(testSessionId.value);
    await controller.createManualPair(players[0].id, players[1].id);

    expect(
      container.read(playersControllerProvider).errorMessage,
      'Selecione dois jogadores disponíveis',
    );
  });
}
