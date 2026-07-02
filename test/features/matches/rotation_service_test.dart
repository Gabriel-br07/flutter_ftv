import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/history/domain/history_event_type.dart';
import 'package:flutter_ftv/features/matches/services/rotation_service.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_status.dart';
import 'package:flutter_ftv/features/players/domain/player_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

void main() {
  final service = RotationService();

  test('should_keep_court_a_winner_on_court_a', () {
    // Arrange: single court A with A1 (p1,p2) vs A2 (p3,p4).
    final courtA = makeCourt(1);
    final players = makePlayers(4, status: PlayerStatus.playing);
    final a1 = makePair('A1', players[0], players[1]);
    final a2 = makePair('A2', players[2], players[3]);
    final match = makeMatch('m1', courtA, a1, a2);
    final state = makeState(
      roster: players,
      courts: [courtA],
      pairs: [a1, a2],
      slots: [activeSlot(courtA, a1, a2, match)],
      matches: [match],
      queue: const [],
    );

    // Act: A1 wins.
    final result = service.finishMatch(
      state: state,
      matchId: match.id,
      winnerPairId: a1.id,
      timestamp: testTimestamp,
    );

    // Assert: A1 still holds Court A and is immediately re-challenged by the two
    // returning players (single court: the queue supplies the next challenger);
    // A2 is dissolved and no longer on the court.
    final next = result.state;
    expect(next.slotForCourt(courtA.id)!.homePairId, a1.id);
    expect(next.pairById(a2.id)!.status, PairStatus.dissolved);
    expect(next.activeMatchOnCourt(courtA.id), isNotNull);
    expect(next.queue, isEmpty);
  });

  test('should_dissolve_losing_pair_and_return_players_individually', () {
    // Arrange: single court plus two spare queued players, so the freed
    // challenger slot is filled from the spares and the losing players land at
    // the end of the queue (rather than being immediately reused).
    final courtA = makeCourt(1);
    final players = makePlayers(4, status: PlayerStatus.playing);
    final spares = [makePlayer(5), makePlayer(6)];
    final a1 = makePair('A1', players[0], players[1]);
    final a2 = makePair('A2', players[2], players[3]);
    final match = makeMatch('m1', courtA, a1, a2);
    final state = makeState(
      roster: [...players, ...spares],
      courts: [courtA],
      pairs: [a1, a2],
      slots: [activeSlot(courtA, a1, a2, match)],
      matches: [match],
      queue: [for (final p in spares) p.id],
    );

    // Act
    final result = service.finishMatch(
      state: state,
      matchId: match.id,
      winnerPairId: a1.id,
      timestamp: testTimestamp,
    );

    // Assert: the two losing players return individually to the queue, both
    // marked queued; the losing pair is dissolved.
    final next = result.state;
    expect(next.queue.toSet(), {players[2].id, players[3].id});
    for (final id in [players[2].id, players[3].id]) {
      expect(next.playerById(id)!.status, PlayerStatus.queued);
    }
    expect(next.pairById(a2.id)!.status, PairStatus.dissolved);
  });

  test(
    'should_make_court_b_winner_wait_for_court_a_when_court_a_is_active',
    () {
      // Arrange: A active (A1 vs A2), B active (B1 vs B2). No court C.
      final courtA = makeCourt(1);
      final courtB = makeCourt(2);
      final players = makePlayers(8, status: PlayerStatus.playing);
      final a1 = makePair('A1', players[0], players[1]);
      final a2 = makePair('A2', players[2], players[3]);
      final b1 = makePair('B1', players[4], players[5]);
      final b2 = makePair('B2', players[6], players[7]);
      final matchA = makeMatch('mA', courtA, a1, a2);
      final matchB = makeMatch('mB', courtB, b1, b2);
      final state = makeState(
        roster: players,
        courts: [courtA, courtB],
        pairs: [a1, a2, b1, b2],
        slots: [
          activeSlot(courtA, a1, a2, matchA),
          activeSlot(courtB, b1, b2, matchB),
        ],
        matches: [matchA, matchB],
        queue: const [],
      );

      // Act: Court B finishes first, B1 wins, while Court A is still active.
      final result = service.finishMatch(
        state: state,
        matchId: matchB.id,
        winnerPairId: b1.id,
        timestamp: testTimestamp,
      );

      // Assert: B1 becomes a reigning winner waiting for the upper court.
      final next = result.state;
      expect(next.pairById(b1.id)!.status, PairStatus.waitingForUpperCourt);
      expect(next.slotForCourt(courtB.id)!.homePairId, b1.id);
      // Court A is untouched and still active.
      expect(next.activeMatchOnCourt(courtA.id)!.id, matchA.id);
    },
  );

  test(
    'should_make_court_b_winner_challenge_court_a_winner_after_court_a_finishes',
    () {
      // Arrange: A active (A1 vs A2); B already won, B1 reigning (waiting).
      final courtA = makeCourt(1);
      final courtB = makeCourt(2);
      final players = makePlayers(6, status: PlayerStatus.playing);
      final a1 = makePair('A1', players[0], players[1]);
      final a2 = makePair('A2', players[2], players[3]);
      final b1 = makePair(
        'B1',
        players[4],
        players[5],
        status: PairStatus.waitingForUpperCourt,
      );
      final matchA = makeMatch('mA', courtA, a1, a2);
      final state = makeState(
        roster: players,
        courts: [courtA, courtB],
        pairs: [a1, a2, b1],
        slots: [activeSlot(courtA, a1, a2, matchA), reigningSlot(courtB, b1)],
        matches: [matchA],
        queue: const [],
      );

      // Act: Court A finishes, A1 wins.
      final result = service.finishMatch(
        state: state,
        matchId: matchA.id,
        winnerPairId: a1.id,
        timestamp: testTimestamp,
      );

      // Assert: a new match on Court A is A1 vs B1 (B1 rose to challenge).
      final next = result.state;
      final newMatch = next.activeMatchOnCourt(courtA.id);
      expect(newMatch, isNotNull);
      expect({newMatch!.pairOneId, newMatch.pairTwoId}, {a1.id, b1.id});
      // B1 rose to Court A, so it no longer occupies Court B.
      expect(next.slotForCourt(courtB.id)!.pairIds, isNot(contains(b1.id)));
    },
  );

  test('should_move_court_c_winner_up_to_court_b_after_court_b_finishes', () {
    // Arrange: A active; B active (B1 vs B2); C already won, C1 reigning.
    final courtA = makeCourt(1);
    final courtB = makeCourt(2);
    final courtC = makeCourt(3);
    final players = makePlayers(10, status: PlayerStatus.playing);
    final a1 = makePair('A1', players[0], players[1]);
    final a2 = makePair('A2', players[2], players[3]);
    final b1 = makePair('B1', players[4], players[5]);
    final b2 = makePair('B2', players[6], players[7]);
    final c1 = makePair(
      'C1',
      players[8],
      players[9],
      status: PairStatus.waitingForUpperCourt,
    );
    final matchA = makeMatch('mA', courtA, a1, a2);
    final matchB = makeMatch('mB', courtB, b1, b2);
    final state = makeState(
      roster: players,
      courts: [courtA, courtB, courtC],
      pairs: [a1, a2, b1, b2, c1],
      slots: [
        activeSlot(courtA, a1, a2, matchA),
        activeSlot(courtB, b1, b2, matchB),
        reigningSlot(courtC, c1),
      ],
      matches: [matchA, matchB],
      queue: const [],
    );

    // Act: Court B finishes, B1 wins.
    final result = service.finishMatch(
      state: state,
      matchId: matchB.id,
      winnerPairId: b1.id,
      timestamp: testTimestamp,
    );

    // Assert: a new match on Court B is B1 vs C1 (C1 moved up).
    final next = result.state;
    final newMatch = next.activeMatchOnCourt(courtB.id);
    expect(newMatch, isNotNull);
    expect({newMatch!.pairOneId, newMatch.pairTwoId}, {b1.id, c1.id});
    // C1 rose to Court B, so it no longer occupies Court C.
    expect(next.slotForCourt(courtC.id)!.pairIds, isNot(contains(c1.id)));
  });

  test('should_apply_same_ladder_rule_to_lower_courts', () {
    // Arrange: 4 courts, all upper courts busy so the C↔D interaction is
    // isolated. A active, B active, C active (C1 vs C2); D already won, D1
    // reigning.
    final courts = makeCourts(4);
    final courtC = courts[2];
    final courtD = courts[3];
    final players = makePlayers(14, status: PlayerStatus.playing);
    final a1 = makePair('A1', players[0], players[1]);
    final a2 = makePair('A2', players[2], players[3]);
    final b1 = makePair('B1', players[4], players[5]);
    final b2 = makePair('B2', players[6], players[7]);
    final c1 = makePair('C1', players[8], players[9]);
    final c2 = makePair('C2', players[10], players[11]);
    final d1 = makePair(
      'D1',
      players[12],
      players[13],
      status: PairStatus.waitingForUpperCourt,
    );
    final matchA = makeMatch('mA', courts[0], a1, a2);
    final matchB = makeMatch('mB', courts[1], b1, b2);
    final matchC = makeMatch('mC', courtC, c1, c2);
    final state = makeState(
      roster: players,
      courts: courts,
      pairs: [a1, a2, b1, b2, c1, c2, d1],
      slots: [
        activeSlot(courts[0], a1, a2, matchA),
        activeSlot(courts[1], b1, b2, matchB),
        activeSlot(courtC, c1, c2, matchC),
        reigningSlot(courtD, d1),
      ],
      matches: [matchA, matchB, matchC],
      queue: const [],
    );

    // Act: Court C finishes, C1 wins.
    final result = service.finishMatch(
      state: state,
      matchId: matchC.id,
      winnerPairId: c1.id,
      timestamp: testTimestamp,
    );

    // Assert: D1 moved up to challenge C1 on Court C.
    final next = result.state;
    final newMatch = next.activeMatchOnCourt(courtC.id);
    expect(newMatch, isNotNull);
    expect({newMatch!.pairOneId, newMatch.pairTwoId}, {c1.id, d1.id});
    // D1 rose to Court C, so it no longer occupies Court D.
    expect(next.slotForCourt(courtD.id)!.pairIds, isNot(contains(d1.id)));
  });

  test('should_return_tired_winner_players_individually_to_queue', () {
    // Arrange: single court A; four spare players queued so the emptied court
    // refills from them, leaving the tired/losing players at the queue's end.
    final courtA = makeCourt(1);
    final playing = makePlayers(4, status: PlayerStatus.playing); // p1..p4
    final spares = [
      for (var i = 5; i <= 8; i++) makePlayer(i), // p5..p8, queued
    ];
    final a1 = makePair('A1', playing[0], playing[1]);
    final a2 = makePair('A2', playing[2], playing[3]);
    final match = makeMatch('m1', courtA, a1, a2);
    final state = makeState(
      roster: [...playing, ...spares],
      courts: [courtA],
      pairs: [a1, a2],
      slots: [activeSlot(courtA, a1, a2, match)],
      matches: [match],
      queue: [for (final p in spares) p.id],
    );

    // Act: A1 wins but the winning pair is tired.
    final result = service.finishMatch(
      state: state,
      matchId: match.id,
      winnerPairId: a1.id,
      winnerGotTired: true,
      timestamp: testTimestamp,
    );

    // Assert: all four players (both pairs) are back in the queue, each marked
    // queued; both pairs are dissolved.
    final next = result.state;
    final fourPlayers = [
      playing[0].id,
      playing[1].id,
      playing[2].id,
      playing[3].id,
    ];
    for (final id in fourPlayers) {
      expect(next.queue.contains(id), isTrue, reason: '${id.value} in queue');
      expect(next.playerById(id)!.status, PlayerStatus.queued);
    }
    expect(next.pairById(a1.id)!.status, PairStatus.dissolved);
    expect(next.pairById(a2.id)!.status, PairStatus.dissolved);
  });

  test('should_return_all_players_when_both_pairs_leave', () {
    // Arrange: single court; spares queued so the emptied court refills from
    // them, leaving the four departing players at the end of the queue.
    final court = makeCourt(1);
    final playing = makePlayers(4, status: PlayerStatus.playing); // p1..p4
    final spares = [for (var i = 5; i <= 8; i++) makePlayer(i)];
    final b1 = makePair('B1', playing[0], playing[1]);
    final b2 = makePair('B2', playing[2], playing[3]);
    final match = makeMatch('mB', court, b1, b2);
    final state = makeState(
      roster: [...playing, ...spares],
      courts: [court],
      pairs: [b1, b2],
      slots: [activeSlot(court, b1, b2, match)],
      matches: [match],
      queue: [for (final p in spares) p.id],
    );

    // Act: both pairs leave.
    final result = service.finishMatch(
      state: state,
      matchId: match.id,
      winnerPairId: b1.id,
      bothPairsLeft: true,
      timestamp: testTimestamp,
    );

    // Assert: all four players return individually; both pairs dissolved.
    final next = result.state;
    for (final p in playing) {
      expect(next.queue.contains(p.id), isTrue);
      expect(next.playerById(p.id)!.status, PlayerStatus.queued);
    }
    expect(next.pairById(b1.id)!.status, PairStatus.dissolved);
    expect(next.pairById(b2.id)!.status, PairStatus.dissolved);
  });

  test('should_fill_empty_courts_from_available_queue', () {
    // Arrange: A active, B empty, and two players waiting in the queue.
    final courtA = makeCourt(1);
    final courtB = makeCourt(2);
    final playing = makePlayers(4, status: PlayerStatus.playing); // p1..p4
    final waiting = [makePlayer(5), makePlayer(6)]; // p5, p6 queued
    final a1 = makePair('A1', playing[0], playing[1]);
    final a2 = makePair('A2', playing[2], playing[3]);
    final matchA = makeMatch('mA', courtA, a1, a2);
    final state = makeState(
      roster: [...playing, ...waiting],
      courts: [courtA, courtB],
      pairs: [a1, a2],
      slots: [
        activeSlot(courtA, a1, a2, matchA),
        // Court B left empty on purpose.
      ],
      matches: [matchA],
      queue: [waiting[0].id, waiting[1].id],
    );

    // Act: finishing A triggers the rotation, which fills the empty Court B.
    final result = service.finishMatch(
      state: state,
      matchId: matchA.id,
      winnerPairId: a1.id,
      timestamp: testTimestamp,
    );

    // Assert: Court B now holds a pair formed from the queued players.
    final next = result.state;
    final slotB = next.slotForCourt(courtB.id)!;
    expect(slotB.isEmpty, isFalse);
    final homePair = next.pairById(slotB.homePairId!)!;
    expect(homePair.contains(waiting[0].id), isTrue);
    expect(homePair.contains(waiting[1].id), isTrue);
  });

  test('should_not_assign_same_player_to_two_active_places', () {
    // Arrange: the B-challenges-A scenario, which moves a pair between courts.
    final courtA = makeCourt(1);
    final courtB = makeCourt(2);
    final players = makePlayers(6, status: PlayerStatus.playing);
    final a1 = makePair('A1', players[0], players[1]);
    final a2 = makePair('A2', players[2], players[3]);
    final b1 = makePair(
      'B1',
      players[4],
      players[5],
      status: PairStatus.waitingForUpperCourt,
    );
    final matchA = makeMatch('mA', courtA, a1, a2);
    final state = makeState(
      roster: players,
      courts: [courtA, courtB],
      pairs: [a1, a2, b1],
      slots: [activeSlot(courtA, a1, a2, matchA), reigningSlot(courtB, b1)],
      matches: [matchA],
      queue: const [],
    );

    // Act
    final result = service.finishMatch(
      state: state,
      matchId: matchA.id,
      winnerPairId: a1.id,
      timestamp: testTimestamp,
    );

    // Assert: no player is active in two places, and none is both playing and
    // queued at the same time.
    expect(result.state.hasUniqueActivePlayers, isTrue);
  });

  test('should_not_keep_dissolved_pair_on_court', () {
    // Arrange
    final courtA = makeCourt(1);
    final players = makePlayers(4, status: PlayerStatus.playing);
    final a1 = makePair('A1', players[0], players[1]);
    final a2 = makePair('A2', players[2], players[3]);
    final match = makeMatch('m1', courtA, a1, a2);
    final state = makeState(
      roster: players,
      courts: [courtA],
      pairs: [a1, a2],
      slots: [activeSlot(courtA, a1, a2, match)],
      matches: [match],
      queue: const [],
    );

    // Act
    final result = service.finishMatch(
      state: state,
      matchId: match.id,
      winnerPairId: a1.id,
      timestamp: testTimestamp,
    );

    // Assert: the dissolved losing pair is not referenced by any court slot.
    final next = result.state;
    expect(next.hasNoDissolvedPairOnCourt, isTrue);
    final slotPairIds = next.slots
        .expand((s) => s.pairIds)
        .map((id) => id.value)
        .toSet();
    expect(slotPairIds.contains(a2.id.value), isFalse);
  });

  group('history events', () {
    final courtA = makeCourt(1);
    final players = makePlayers(4, status: PlayerStatus.playing);
    final a1 = makePair('A1', players[0], players[1]);
    final a2 = makePair('A2', players[2], players[3]);
    final match = makeMatch('m1', courtA, a1, a2);

    RotationResult run() {
      final state = makeState(
        roster: players,
        courts: [courtA],
        pairs: [a1, a2],
        slots: [activeSlot(courtA, a1, a2, match)],
        matches: [match],
        queue: const [],
      );
      return service.finishMatch(
        state: state,
        matchId: match.id,
        winnerPairId: a1.id,
        timestamp: testTimestamp,
      );
    }

    test('should_record_history_event_when_match_finishes', () {
      final events = run().generatedEvents.map((e) => e.type);
      expect(events, contains(HistoryEventType.matchFinished));
    });

    test('should_record_history_event_when_pair_is_dissolved', () {
      final events = run().generatedEvents.map((e) => e.type);
      expect(events, contains(HistoryEventType.pairDissolved));
    });

    test('should_record_history_event_when_rotation_is_applied', () {
      final result = run();
      final events = result.generatedEvents.map((e) => e.type);
      expect(events, contains(HistoryEventType.rotationApplied));
      // Events are also appended to the state's history log.
      expect(
        result.state.history.map((e) => e.type),
        contains(HistoryEventType.rotationApplied),
      );
    });
  });

  test('should_report_error_when_winner_is_not_part_of_match', () {
    // Arrange
    final courtA = makeCourt(1);
    final players = makePlayers(4, status: PlayerStatus.playing);
    final a1 = makePair('A1', players[0], players[1]);
    final a2 = makePair('A2', players[2], players[3]);
    final match = makeMatch('m1', courtA, a1, a2);
    final state = makeState(
      roster: players,
      courts: [courtA],
      pairs: [a1, a2],
      slots: [activeSlot(courtA, a1, a2, match)],
      matches: [match],
      queue: const [],
    );

    // Act: pass a pair id that is not in the match.
    final result = service.finishMatch(
      state: state,
      matchId: match.id,
      winnerPairId: const PairId('not-in-match'),
      timestamp: testTimestamp,
    );

    // Assert
    expect(result.hasErrors, isTrue);
    expect(result.errors.single.code, 'winner_not_in_match');
  });
}
