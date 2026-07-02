import 'package:flutter_ftv/features/matches/domain/match_status.dart';
import 'package:flutter_ftv/features/matches/services/rotation_service.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_origin.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_status.dart';
import 'package:flutter_ftv/features/players/domain/player_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

/// Regression tests for the ladder-reconciliation fixes: a lone reigning winner
/// must always be given a challenger (from a riser below or the queue), so no
/// court — and no single-court session — can deadlock.
void main() {
  final service = RotationService();

  test('single court: reigning winner is challenged by the next queue pair', () {
    // Arrange: one court, four players playing, two spares queued.
    final courtA = makeCourt(1);
    final playing = makePlayers(4, status: PlayerStatus.playing);
    final spares = [makePlayer(5), makePlayer(6)];
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

    // Act: A1 wins.
    final result = service.finishMatch(
      state: state,
      matchId: match.id,
      winnerPairId: a1.id,
      timestamp: testTimestamp,
    );

    // Assert: A1 stays and a new match starts on Court A against the two spares
    // (no deadlock); the losing players are at the end of the queue.
    final next = result.state;
    final newMatch = next.activeMatchOnCourt(courtA.id)!;
    expect(newMatch.pairOneId, a1.id);
    final challenger = next.pairById(newMatch.pairTwoId)!;
    expect(challenger.contains(spares[0].id), isTrue);
    expect(challenger.contains(spares[1].id), isTrue);
    expect(next.queue.toSet(), {playing[2].id, playing[3].id});
  });

  test('single court never deadlocks across several rounds', () {
    // Arrange: seed one court from a queue of six players.
    final courtA = makeCourt(1);
    final players = makePlayers(6);
    var state = makeState(
      roster: players,
      courts: [courtA],
      queue: [for (final p in players) p.id],
    );
    state = service.fillCourts(state: state, timestamp: testTimestamp).state;

    // Act + Assert: record five results in a row; a match is always available.
    for (var round = 0; round < 5; round++) {
      final match = state.activeMatchOnCourt(courtA.id);
      expect(match, isNotNull, reason: 'court A idle at round $round');
      state = service
          .finishMatch(
            state: state,
            matchId: match!.id,
            winnerPairId: match.pairOneId,
            timestamp: testTimestamp,
          )
          .state;
    }
    expect(state.activeMatchOnCourt(courtA.id), isNotNull);
  });

  test(
    'Court B winner challenges Court A even when Court A finished first',
    () {
      // Arrange: A and B both active.
      final courtA = makeCourt(1);
      final courtB = makeCourt(2);
      final players = makePlayers(8, status: PlayerStatus.playing);
      final a1 = makePair('A1', players[0], players[1]);
      final a2 = makePair('A2', players[2], players[3]);
      final b1 = makePair('B1', players[4], players[5]);
      final b2 = makePair('B2', players[6], players[7]);
      final matchA = makeMatch('mA', courtA, a1, a2);
      final matchB = makeMatch('mB', courtB, b1, b2);
      var state = makeState(
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

      // Act: Court A finishes first (A1 wins) and is left waiting, then Court B
      // finishes (B1 wins).
      state = service
          .finishMatch(
            state: state,
            matchId: matchA.id,
            winnerPairId: a1.id,
            timestamp: testTimestamp,
          )
          .state;
      // A is now a lone winner waiting (no riser yet, no queue).
      expect(state.activeMatchOnCourt(courtA.id), isNull);
      state = service
          .finishMatch(
            state: state,
            matchId: matchB.id,
            winnerPairId: b1.id,
            timestamp: testTimestamp,
          )
          .state;

      // Assert: B1 rose to challenge A1 on Court A.
      final newMatch = state.activeMatchOnCourt(courtA.id);
      expect(newMatch, isNotNull);
      expect({newMatch!.pairOneId, newMatch.pairTwoId}, {a1.id, b1.id});
      expect(state.slotForCourt(courtB.id)!.pairIds, isNot(contains(b1.id)));
    },
  );

  test('tired top-court winner promotes the lower winner, not the queue', () {
    // Arrange: A active, B holds a reigning winner; four spares queued.
    final courtA = makeCourt(1);
    final courtB = makeCourt(2);
    final playing = makePlayers(4, status: PlayerStatus.playing);
    final b1Players = [makePlayer(5), makePlayer(6)];
    final spares = [for (var i = 7; i <= 10; i++) makePlayer(i)];
    final a1 = makePair('A1', playing[0], playing[1]);
    final a2 = makePair('A2', playing[2], playing[3]);
    final b1 = makePair(
      'B1',
      b1Players[0],
      b1Players[1],
      status: PairStatus.waitingForUpperCourt,
    );
    final matchA = makeMatch('mA', courtA, a1, a2);
    final state = makeState(
      roster: [...playing, ...b1Players, ...spares],
      courts: [courtA, courtB],
      pairs: [a1, a2, b1],
      slots: [activeSlot(courtA, a1, a2, matchA), reigningSlot(courtB, b1)],
      matches: [matchA],
      queue: [for (final p in spares) p.id],
    );

    // Act: the winning pair on Court A is tired and leaves.
    final result = service.finishMatch(
      state: state,
      matchId: matchA.id,
      winnerPairId: a1.id,
      winnerGotTired: true,
      timestamp: testTimestamp,
    );

    // Assert: B1 was promoted up to the freed Court A (it does not go to the
    // queue), rather than Court A being refilled from the queue over B1's head.
    final next = result.state;
    expect(next.slotForCourt(courtA.id)!.homePairId, b1.id);
    expect(next.slotForCourt(courtB.id)!.pairIds, isNot(contains(b1.id)));
  });

  test('manual pair is dissolved after winning (does not defend again)', () {
    // Arrange: a manual pair defends Court A; two spares queued.
    final courtA = makeCourt(1);
    final playing = makePlayers(4, status: PlayerStatus.playing);
    final spares = [makePlayer(5), makePlayer(6)];
    final manual = makePair(
      'M1',
      playing[0],
      playing[1],
      origin: PairOrigin.manual,
    );
    final a2 = makePair('A2', playing[2], playing[3]);
    final match = makeMatch('m1', courtA, manual, a2);
    final state = makeState(
      roster: [...playing, ...spares],
      courts: [courtA],
      pairs: [manual, a2],
      slots: [activeSlot(courtA, manual, a2, match)],
      matches: [match],
      queue: [for (final p in spares) p.id],
    );

    // Act: the manual pair wins.
    final result = service.finishMatch(
      state: state,
      matchId: match.id,
      winnerPairId: manual.id,
      timestamp: testTimestamp,
    );

    // Assert: the manual pair is dissolved (not reigning), its players are back
    // in the queue, and the court is taken by a fresh pair.
    final next = result.state;
    expect(next.pairById(manual.id)!.status, PairStatus.dissolved);
    expect(next.slotForCourt(courtA.id)!.pairIds, isNot(contains(manual.id)));
    for (final id in [playing[0].id, playing[1].id]) {
      expect(next.queue.contains(id), isTrue);
      expect(next.playerById(id)!.status, PlayerStatus.queued);
    }
  });

  test('removing an active player voids the match and frees the court', () {
    // Arrange: single court, an active match; a spare pair queued so the court
    // can refill after the removal.
    final courtA = makeCourt(1);
    final playing = makePlayers(4, status: PlayerStatus.playing);
    final spares = [makePlayer(5), makePlayer(6)];
    final a1 = makePair('A1', playing[0], playing[1]);
    final a2 = makePair('A2', playing[2], playing[3]);
    final match = makeMatch('m1', courtA, a1, a2);
    // Pre-mark the player removed (the engine does this before detaching).
    final removed = playing[0].copyWith(status: PlayerStatus.removed);
    final state = makeState(
      roster: [removed, ...playing.skip(1), ...spares],
      courts: [courtA],
      pairs: [a1, a2],
      slots: [activeSlot(courtA, a1, a2, match)],
      matches: [match],
      queue: [for (final p in spares) p.id],
    );

    // Act
    final result = service.detachActivePlayer(
      state: state,
      playerId: removed.id,
      timestamp: testTimestamp,
    );

    // Assert: the match is voided, the removed player's pair dissolved, and no
    // dissolved pair or removed player is left active on a court.
    final next = result.state;
    expect(next.matchById(match.id)!.status, MatchStatus.cancelled);
    expect(next.pairById(a1.id)!.status, PairStatus.dissolved);
    expect(next.hasUniqueActivePlayers, isTrue);
    expect(next.hasNoDissolvedPairOnCourt, isTrue);
    expect(next.activePlayerIds, isNot(contains(removed.id)));
  });
}
