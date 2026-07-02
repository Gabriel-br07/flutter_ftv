import 'package:flutter_ftv/features/matches/services/rotation_service.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_origin.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_status.dart';
import 'package:flutter_ftv/features/players/domain/player_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

void main() {
  final service = RotationService();

  test('should_fill_two_courts_from_four_queued_pairs_in_order', () {
    // Arrange: two courts, four queued pairs (players already playing).
    final courts = makeCourts(2);
    final players = makePlayers(8, status: PlayerStatus.playing);
    final queuedPairs = [
      for (var i = 0; i < 4; i++)
        makePair(
          'q$i',
          players[i * 2],
          players[i * 2 + 1],
          status: PairStatus.queued,
          queueOrder: i,
        ),
    ];
    final state = makeState(
      roster: players,
      courts: courts,
      pairs: queuedPairs,
      queue: const [],
    );

    // Act
    final result = service.fillCourts(state: state, timestamp: testTimestamp);

    // Assert: Court A takes the first two pairs, Court B the next two.
    final next = result.state;
    final matchA = next.activeMatchOnCourt(courts[0].id)!;
    final matchB = next.activeMatchOnCourt(courts[1].id)!;
    expect(
      {matchA.pairOneId, matchA.pairTwoId},
      {queuedPairs[0].id, queuedPairs[1].id},
    );
    expect(
      {matchB.pairOneId, matchB.pairTwoId},
      {queuedPairs[2].id, queuedPairs[3].id},
    );
  });

  test('should_place_manual_pair_last', () {
    // Arrange: three automatic pairs and one manual pair (highest queueOrder).
    final courts = makeCourts(2);
    final players = makePlayers(8, status: PlayerStatus.playing);
    final autos = [
      for (var i = 0; i < 3; i++)
        makePair(
          'a$i',
          players[i * 2],
          players[i * 2 + 1],
          status: PairStatus.queued,
          queueOrder: i,
        ),
    ];
    final manual = makePair(
      'manual',
      players[6],
      players[7],
      origin: PairOrigin.manual,
      status: PairStatus.queued,
      queueOrder: 99,
    );
    final state = makeState(
      roster: players,
      courts: courts,
      pairs: [...autos, manual],
      queue: const [],
    );

    // Act
    final result = service.fillCourts(state: state, timestamp: testTimestamp);

    // Assert: the manual pair, having the highest queueOrder, enters last —
    // as the challenger on Court B, after the three automatic pairs.
    final next = result.state;
    final slotB = next.slotForCourt(courts[1].id)!;
    expect(slotB.pairIds, contains(manual.id));
    expect(slotB.challengerPairId, manual.id);
  });

  test('should_prefer_automatic_over_manual_regardless_of_queue_order', () {
    // Arrange: a manual pair with a LOWER queueOrder than the automatic pair.
    // Ordering must still put the automatic pair first (origin beats order).
    final court = makeCourt(1);
    final players = makePlayers(4, status: PlayerStatus.playing);
    final manual = makePair(
      'manual',
      players[0],
      players[1],
      origin: PairOrigin.manual,
      status: PairStatus.queued,
      // queueOrder defaults to 0 — lower than the automatic pair's 5.
    );
    final auto = makePair(
      'auto',
      players[2],
      players[3],
      status: PairStatus.queued,
      queueOrder: 5,
    );
    final state = makeState(
      roster: players,
      courts: [court],
      pairs: [manual, auto],
      queue: const [],
    );

    // Act
    final result = service.fillCourts(state: state, timestamp: testTimestamp);

    // Assert: the automatic pair reigns on Court A; the manual pair challenges.
    final slotA = result.state.slotForCourt(court.id)!;
    expect(slotA.homePairId, auto.id);
    expect(slotA.challengerPairId, manual.id);
  });

  test('should_form_pairs_from_individual_queue_when_no_queued_pairs', () {
    // Arrange: no pre-formed pairs, four players in the individual queue.
    final court = makeCourt(1);
    final players = makePlayers(4); // queued
    final state = makeState(
      roster: players,
      courts: [court],
      queue: [for (final p in players) p.id],
    );

    // Act
    final result = service.fillCourts(state: state, timestamp: testTimestamp);

    // Assert: a match was formed on Court A and the queue is drained.
    final next = result.state;
    expect(next.activeMatchOnCourt(court.id), isNotNull);
    expect(next.queue, isEmpty);
    expect(next.pairs, hasLength(2));
  });
}
