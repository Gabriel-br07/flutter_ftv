import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/courts/domain/court.dart';
import 'package:flutter_ftv/features/history/domain/history_event.dart';
import 'package:flutter_ftv/features/matches/domain/court_slot.dart';
import 'package:flutter_ftv/features/matches/domain/match.dart';
import 'package:flutter_ftv/features/matches/domain/rotation_state.dart';
import 'package:flutter_ftv/features/pairs/domain/pair.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_origin.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_status.dart';
import 'package:flutter_ftv/features/players/domain/player.dart';
import 'package:flutter_ftv/features/players/domain/player_status.dart';
import 'package:flutter_ftv/features/sessions/domain/session.dart';

/// Shared session id used across tests.
const testSessionId = SessionId('session-1');

/// A fixed timestamp so history events are deterministic in tests.
final testTimestamp = DateTime.utc(2026, 1, 1, 12);

Session makeSession({int courtCount = 1, int targetPoints = 15}) {
  return Session.create(
    id: testSessionId,
    name: 'Pelada de teste',
    courtCount: courtCount,
    targetPoints: targetPoints,
    createdAt: testTimestamp,
  );
}

/// Creates a player. [order] doubles as the numeric part of the default id/name.
Player makePlayer(
  int order, {
  PlayerStatus status = PlayerStatus.queued,
  String? id,
}) {
  return Player(
    id: PlayerId(id ?? 'p$order'),
    sessionId: testSessionId,
    name: 'Player $order',
    arrivalOrder: order,
    status: status,
  );
}

/// Creates [count] players numbered 1..count, all with [status].
List<Player> makePlayers(
  int count, {
  PlayerStatus status = PlayerStatus.queued,
}) {
  return [for (var i = 1; i <= count; i++) makePlayer(i, status: status)];
}

Court makeCourt(int level) {
  return Court.atLevel(
    id: CourtId('court-${Court.nameForLevel(level)}'),
    sessionId: testSessionId,
    level: level,
  );
}

/// Courts A..(count), ascending by level.
List<Court> makeCourts(int count) {
  return [for (var level = 1; level <= count; level++) makeCourt(level)];
}

Pair makePair(
  String id,
  Player one,
  Player two, {
  PairOrigin origin = PairOrigin.automatic,
  PairStatus status = PairStatus.playing,
  int queueOrder = 0,
}) {
  return Pair(
    id: PairId(id),
    sessionId: testSessionId,
    playerOneId: one.id,
    playerTwoId: two.id,
    origin: origin,
    status: status,
    queueOrder: queueOrder,
  );
}

Match makeMatch(String id, Court court, Pair home, Pair challenger) {
  return Match(
    id: MatchId(id),
    sessionId: testSessionId,
    courtId: court.id,
    pairOneId: home.id,
    pairTwoId: challenger.id,
  );
}

/// A slot with an active match between [home] and [challenger].
CourtSlot activeSlot(Court court, Pair home, Pair challenger, Match match) {
  return CourtSlot(
    courtId: court.id,
    homePairId: home.id,
    challengerPairId: challenger.id,
    matchId: match.id,
  );
}

/// A slot holding a lone reigning [home] pair, awaiting a challenger.
CourtSlot reigningSlot(Court court, Pair home) {
  return CourtSlot(courtId: court.id, homePairId: home.id);
}

/// Assembles a [RotationState]. When [queue] is omitted it is derived from the
/// roster players whose status is [PlayerStatus.queued], in roster order.
RotationState makeState({
  required List<Player> roster,
  List<Court> courts = const [],
  List<Pair> pairs = const [],
  List<CourtSlot> slots = const [],
  List<Match> matches = const [],
  List<PlayerId>? queue,
  List<HistoryEvent> history = const [],
  Session? session,
}) {
  final resolvedSession =
      session ?? makeSession(courtCount: courts.isEmpty ? 1 : courts.length);
  // Ensure every court has a slot (empty by default).
  final slotByCourt = {for (final s in slots) s.courtId.value: s};
  final resolvedSlots = [
    for (final c in courts) slotByCourt[c.id.value] ?? CourtSlot.empty(c.id),
  ];
  return RotationState(
    session: resolvedSession,
    roster: roster,
    queue:
        queue ??
        [
          for (final p in roster)
            if (p.status == PlayerStatus.queued) p.id,
        ],
    courts: courts,
    pairs: pairs,
    slots: resolvedSlots,
    matches: matches,
    history: history,
  );
}
