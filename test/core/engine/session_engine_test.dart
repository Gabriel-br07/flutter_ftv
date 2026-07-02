import 'package:flutter_ftv/core/engine/session_engine.dart';
import 'package:flutter_ftv/core/utils/id_generator.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_origin.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_status.dart';
import 'package:flutter_ftv/features/players/domain/player_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

void main() {
  SessionEngine makeEngine() => SessionEngine(
    idGenerator: IdGenerator(now: () => testTimestamp),
    now: () => testTimestamp,
  );

  test('forming pairs again does not discard already active pairs', () {
    // Arrange: Court A has an active pair, and two more players are queued.
    final courtA = makeCourt(1);
    final playing = makePlayers(4, status: PlayerStatus.playing);
    final queued = [makePlayer(5), makePlayer(6)];
    final a1 = makePair('A1', playing[0], playing[1]);
    final a2 = makePair('A2', playing[2], playing[3]);
    final match = makeMatch('m1', courtA, a1, a2);
    final state = makeState(
      roster: [...playing, ...queued],
      courts: [courtA],
      pairs: [a1, a2],
      slots: [activeSlot(courtA, a1, a2, match)],
      matches: [match],
      queue: [for (final p in queued) p.id],
    );

    // Act: form pairs again from the queued players.
    final next = makeEngine().formAutomaticPairs(state);

    // Assert: the two active pairs are still present, plus the new pair; the
    // active match is untouched and the queued players left the queue.
    expect(next.pairById(a1.id), isNotNull);
    expect(next.pairById(a2.id), isNotNull);
    expect(next.pairs, hasLength(3));
    expect(next.activeMatchOnCourt(courtA.id)!.id, match.id);
    expect(next.queue, isEmpty);
  });

  test('adds a player to the end of the queue while the session is active', () {
    // Arrange: Court A has an active match; two players already wait in the queue.
    final courtA = makeCourt(1);
    final playing = makePlayers(4, status: PlayerStatus.playing);
    final queued = [makePlayer(5), makePlayer(6)];
    final a1 = makePair('A1', playing[0], playing[1]);
    final a2 = makePair('A2', playing[2], playing[3]);
    final match = makeMatch('m1', courtA, a1, a2);
    final state = makeState(
      roster: [...playing, ...queued],
      courts: [courtA],
      pairs: [a1, a2],
      slots: [activeSlot(courtA, a1, a2, match)],
      matches: [match],
      queue: [for (final p in queued) p.id],
    );

    // Act.
    final result = makeEngine().addPlayer(state, 'Novo Jogador');
    final next = result.valueOrNull!;

    // Assert: the new player is at the very end of the queue; the existing queue
    // order is preserved; the active match and its players are untouched.
    expect(next.queue.first, queued[0].id);
    expect(next.queue[1], queued[1].id);
    expect(next.queuedPlayers.last.name, 'Novo Jogador');
    expect(next.queue, hasLength(3));
    expect(next.activeMatchOnCourt(courtA.id)!.id, match.id);
    expect(next.pairById(a1.id)!.status, PairStatus.playing);
    expect(next.hasUniqueActivePlayers, isTrue);
  });

  test('rejects a duplicate player name (case-insensitive, trimmed)', () {
    final state = makeState(roster: [makePlayer(1)], courts: makeCourts(1));

    final result = makeEngine().addPlayer(state, '  player 1 ');

    expect(result.isFailure, isTrue);
    expect(result.errorOrNull!.code, 'duplicate_player_name');
  });

  test('allows re-adding the name freed by a removed player', () {
    final removed = makePlayer(1, status: PlayerStatus.removed);
    final state = makeState(roster: [removed], courts: makeCourts(1));

    final result = makeEngine().addPlayer(state, 'Player 1');

    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull!.roster, hasLength(2));
  });

  test('fillOpenCourts seats queued players on an empty court, bottom-first, '
      'without disturbing an occupied court', () {
    // Arrange: Court A (top) has an active match; Court B (bottom) is empty; four
    // players wait in the queue.
    final courtA = makeCourt(1);
    final courtB = makeCourt(2);
    final playing = makePlayers(4, status: PlayerStatus.playing);
    final queued = makePlayers(
      4,
    ).map((p) => makePlayer(p.arrivalOrder + 10)).toList();
    final a1 = makePair('A1', playing[0], playing[1]);
    final a2 = makePair('A2', playing[2], playing[3]);
    final match = makeMatch('m1', courtA, a1, a2);
    final state = makeState(
      roster: [...playing, ...queued],
      courts: [courtA, courtB],
      pairs: [a1, a2],
      slots: [activeSlot(courtA, a1, a2, match)],
      matches: [match],
      queue: [for (final p in queued) p.id],
    );

    // Act.
    final next = makeEngine().fillOpenCourts(state);

    // Assert: Court A's match is untouched; Court B now has an active match built
    // from the queue; the queue is drained; invariants hold.
    expect(next.activeMatchOnCourt(courtA.id)!.id, match.id);
    expect(next.activeMatchOnCourt(courtB.id), isNotNull);
    expect(next.queue, isEmpty);
    expect(next.hasUniqueActivePlayers, isTrue);
    expect(next.hasNoDissolvedPairOnCourt, isTrue);
  });

  test('addPlayers appends new names to the queue and skips duplicates', () {
    // Existing roster has "Player 1"; the batch repeats it, an internal dup, and
    // adds three genuinely new names.
    final existing = makePlayers(1); // "Player 1"
    final state = makeState(roster: existing, courts: makeCourts(1));

    final result = makeEngine().addPlayers(state, [
      'player 1', // duplicates existing (case-insensitive) → skipped
      'Ana',
      'Bruno',
      'ana', // duplicates earlier in the batch → skipped
      '   ', // blank → ignored
      'Carla',
    ]);

    expect(result.addedCount, 3);
    expect(result.skippedDuplicates, ['player 1', 'ana']);
    // The three new players are appended to the end of the queue, in order.
    expect(result.state.queuedPlayers.map((p) => p.name), [
      'Player 1',
      'Ana',
      'Bruno',
      'Carla',
    ]);
    // Existing player untouched.
    expect(result.state.playerById(existing.single.id), isNotNull);
    expect(result.state.hasUniqueActivePlayers, isTrue);
  });

  test('addPlayers reports zero added when every name is a duplicate', () {
    final existing = makePlayers(2); // "Player 1", "Player 2"
    final state = makeState(roster: existing, courts: makeCourts(1));

    final result = makeEngine().addPlayers(state, ['Player 1', 'player 2']);

    expect(result.addedCount, 0);
    expect(result.state.queue, hasLength(2));
  });

  test('manual pair leaves the other players individually in the queue', () {
    final players = makePlayers(6); // p1..p6 queued
    final state = makeState(roster: players, courts: makeCourts(1));

    final result = makeEngine().createManualPair(
      state,
      playerOneId: players[4].id,
      playerTwoId: players[5].id,
    );
    final next = result.valueOrNull!;

    // Only one pair (the chosen one); the other four stay individual.
    expect(next.pairs, hasLength(1));
    expect(next.pairs.single.origin, PairOrigin.manual);
    expect(next.queue, [
      players[0].id,
      players[1].id,
      players[2].id,
      players[3].id,
    ]);
  });

  test('creating two manual pairs in a row keeps the rest individual', () {
    final players = makePlayers(6);
    final engine = makeEngine();
    var state = makeState(roster: players, courts: makeCourts(1));

    state = engine
        .createManualPair(
          state,
          playerOneId: players[0].id,
          playerTwoId: players[1].id,
        )
        .valueOrNull!;
    // A second manual pair is possible because the queue was not drained.
    final result = engine.createManualPair(
      state,
      playerOneId: players[2].id,
      playerTwoId: players[3].id,
    );

    final next = result.valueOrNull!;
    expect(next.pairs, hasLength(2));
    expect(next.pairs.every((p) => p.origin == PairOrigin.manual), isTrue);
    // p5, p6 remain individual in the queue.
    expect(next.queue, [players[4].id, players[5].id]);
  });

  test('startRound auto-pairs remaining individuals before filling courts', () {
    // Two courts, four individual players, no pre-formed pairs.
    final players = makePlayers(4);
    final state = makeState(roster: players, courts: makeCourts(2));

    final next = makeEngine().startRound(state);

    // Court A gets an active match built from the auto-formed pairs.
    expect(next.activeMatchOnCourt(next.courts.first.id), isNotNull);
    expect(next.hasUniqueActivePlayers, isTrue);
  });

  test('automatic pairs take courts before a manual pair at start', () {
    // Six players; p1+p2 chosen manually. At start the automatic pairs must fill
    // Court A; the manual pair enters later (penalized to the end).
    final players = makePlayers(6);
    final engine = makeEngine();
    var state = makeState(roster: players, courts: makeCourts(1));
    state = engine
        .createManualPair(
          state,
          playerOneId: players[0].id,
          playerTwoId: players[1].id,
        )
        .valueOrNull!;

    final next = engine.startRound(state);

    final courtA = next.activeMatchOnCourt(next.courts.first.id)!;
    final onCourtPlayers = {
      ...next.pairById(courtA.pairOneId)!.playerIds,
      ...next.pairById(courtA.pairTwoId)!.playerIds,
    };
    // The manually chosen players are NOT on the main court at start.
    expect(onCourtPlayers.contains(players[0].id), isFalse);
    expect(onCourtPlayers.contains(players[1].id), isFalse);
  });

  test(
    'dissolveFormedPair returns both players to the queue in arrival order',
    () {
      final players = makePlayers(4);
      final engine = makeEngine();
      var state = makeState(roster: players, courts: makeCourts(1));
      // Pair p2+p3 manually, leaving p1 and p4 individual.
      state = engine
          .createManualPair(
            state,
            playerOneId: players[1].id,
            playerTwoId: players[2].id,
          )
          .valueOrNull!;
      final pairId = state.pairs.single.id;

      final next = engine.dissolveFormedPair(state, pairId);

      expect(next.pairs, isEmpty);
      // p2 and p3 are back, and the whole queue is in arrival order.
      expect(next.queue, [
        players[0].id,
        players[1].id,
        players[2].id,
        players[3].id,
      ]);
      expect(next.playerById(players[1].id)!.status, PlayerStatus.queued);
    },
  );

  test('removing an actively playing player frees the court cleanly', () {
    // Arrange: single court with an active match p1..p4.
    final courtA = makeCourt(1);
    final playing = makePlayers(4, status: PlayerStatus.playing);
    final a1 = makePair('A1', playing[0], playing[1]);
    final a2 = makePair('A2', playing[2], playing[3]);
    final match = makeMatch('m1', courtA, a1, a2);
    final state = makeState(
      roster: playing,
      courts: [courtA],
      pairs: [a1, a2],
      slots: [activeSlot(courtA, a1, a2, match)],
      matches: [match],
      queue: const [],
    );

    // Act: remove p1 (mid-match).
    final next = makeEngine().removePlayer(state, playing[0].id);

    // Assert: p1 is removed and not active anywhere; their pair is dissolved,
    // the opponent keeps the court, and the partner returns to the queue.
    expect(next.playerById(playing[0].id)!.status, PlayerStatus.removed);
    expect(next.activePlayerIds, isNot(contains(playing[0].id)));
    expect(next.pairById(a1.id)!.status, PairStatus.dissolved);
    expect(next.slotForCourt(courtA.id)!.homePairId, a2.id);
    expect(next.queue, contains(playing[1].id));
    expect(next.hasUniqueActivePlayers, isTrue);
    expect(next.hasNoDissolvedPairOnCourt, isTrue);
  });
}
