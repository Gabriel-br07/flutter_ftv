import 'package:drift/drift.dart';
import 'package:flutter_ftv/core/database/app_database.dart';
import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/courts/domain/court.dart';
import 'package:flutter_ftv/features/courts/domain/court_status.dart';
import 'package:flutter_ftv/features/history/domain/history_event.dart';
import 'package:flutter_ftv/features/history/domain/history_event_type.dart';
import 'package:flutter_ftv/features/matches/domain/court_slot.dart';
import 'package:flutter_ftv/features/matches/domain/match.dart';
import 'package:flutter_ftv/features/matches/domain/match_status.dart';
import 'package:flutter_ftv/features/pairs/domain/pair.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_origin.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_status.dart';
import 'package:flutter_ftv/features/players/domain/player.dart';
import 'package:flutter_ftv/features/players/domain/player_status.dart';
import 'package:flutter_ftv/features/sessions/domain/session.dart';
import 'package:flutter_ftv/features/sessions/domain/session_status.dart';

/// Row → domain and domain → Drift-companion conversions. Enum columns are
/// stored as their `index`. Courts embed the [CourtSlot] as nullable columns.

extension SessionRowMapper on SessionRow {
  Session toDomain() => Session.create(
    id: SessionId(id),
    name: name,
    courtCount: courtCount,
    targetPoints: targetPoints,
    status: SessionStatus.values[status],
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension SessionMapper on Session {
  SessionsCompanion toCompanion() => SessionsCompanion.insert(
    id: id.value,
    name: name,
    courtCount: courtCount,
    targetPoints: targetPoints,
    status: status.index,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension PlayerRowMapper on PlayerRow {
  Player toDomain() => Player(
    id: PlayerId(id),
    sessionId: SessionId(sessionId),
    name: name,
    arrivalOrder: arrivalOrder,
    status: PlayerStatus.values[status],
  );
}

extension PlayerMapper on Player {
  PlayersCompanion toCompanion() => PlayersCompanion.insert(
    id: id.value,
    sessionId: sessionId.value,
    name: name,
    arrivalOrder: arrivalOrder,
    status: status.index,
  );
}

extension PairRowMapper on PairRow {
  Pair toDomain() => Pair(
    id: PairId(id),
    sessionId: SessionId(sessionId),
    playerOneId: PlayerId(playerOneId),
    playerTwoId: PlayerId(playerTwoId),
    origin: PairOrigin.values[origin],
    status: PairStatus.values[status],
    queueOrder: queueOrder,
  );
}

extension PairMapper on Pair {
  PairsCompanion toCompanion() => PairsCompanion.insert(
    id: id.value,
    sessionId: sessionId.value,
    playerOneId: playerOneId.value,
    playerTwoId: playerTwoId.value,
    origin: origin.index,
    status: status.index,
    queueOrder: queueOrder,
  );
}

extension CourtRowMapper on CourtRow {
  Court toDomain() => Court(
    id: CourtId(id),
    sessionId: SessionId(sessionId),
    name: name,
    level: level,
    status: CourtStatus.values[status],
  );

  CourtSlot toSlot() => CourtSlot(
    courtId: CourtId(id),
    homePairId: homePairId == null ? null : PairId(homePairId!),
    challengerPairId: challengerPairId == null
        ? null
        : PairId(challengerPairId!),
    matchId: matchId == null ? null : MatchId(matchId!),
  );
}

/// Builds a court row companion, embedding the matching [slot] occupancy.
CourtsCompanion courtToCompanion(Court court, CourtSlot? slot) =>
    CourtsCompanion.insert(
      id: court.id.value,
      sessionId: court.sessionId.value,
      name: court.name,
      level: court.level,
      status: court.status.index,
      homePairId: Value(slot?.homePairId?.value),
      challengerPairId: Value(slot?.challengerPairId?.value),
      matchId: Value(slot?.matchId?.value),
    );

extension MatchRowMapper on MatchRow {
  Match toDomain() => Match(
    id: MatchId(id),
    sessionId: SessionId(sessionId),
    courtId: CourtId(courtId),
    pairOneId: PairId(pairOneId),
    pairTwoId: PairId(pairTwoId),
    winnerPairId: winnerPairId == null ? null : PairId(winnerPairId!),
    loserPairId: loserPairId == null ? null : PairId(loserPairId!),
    status: MatchStatus.values[status],
  );
}

extension MatchMapper on Match {
  MatchesCompanion toCompanion() => MatchesCompanion.insert(
    id: id.value,
    sessionId: sessionId.value,
    courtId: courtId.value,
    pairOneId: pairOneId.value,
    pairTwoId: pairTwoId.value,
    winnerPairId: Value(winnerPairId?.value),
    loserPairId: Value(loserPairId?.value),
    status: status.index,
  );
}

extension HistoryEventRowMapper on HistoryEventRow {
  HistoryEvent toDomain() => HistoryEvent(
    id: HistoryEventId(id),
    sessionId: SessionId(sessionId),
    type: HistoryEventType.values[type],
    description: description,
    createdAt: createdAt,
  );
}

extension HistoryEventMapper on HistoryEvent {
  HistoryEventsCompanion toCompanion() => HistoryEventsCompanion.insert(
    id: id.value,
    sessionId: sessionId.value,
    type: type.index,
    description: description,
    createdAt: createdAt,
  );
}
