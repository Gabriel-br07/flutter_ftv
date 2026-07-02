import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/matches/domain/match_status.dart';

/// A match between two pairs on a court.
///
/// The MVP records only winner/loser — never point-by-point scoring. A match
/// starts [MatchStatus.active] with no winner; finalizing it sets
/// [winnerPairId]/[loserPairId] and status [MatchStatus.finished].
class Match {
  const Match({
    required this.id,
    required this.sessionId,
    required this.courtId,
    required this.pairOneId,
    required this.pairTwoId,
    this.winnerPairId,
    this.loserPairId,
    this.status = MatchStatus.active,
  });

  final MatchId id;
  final SessionId sessionId;
  final CourtId courtId;
  final PairId pairOneId;
  final PairId pairTwoId;
  final PairId? winnerPairId;
  final PairId? loserPairId;
  final MatchStatus status;

  /// The two pairs taking part in this match.
  List<PairId> get pairIds => [pairOneId, pairTwoId];

  /// Whether [pairId] is one of the two pairs in this match.
  bool contains(PairId pairId) => pairOneId == pairId || pairTwoId == pairId;

  /// The opponent of [pairId] in this match, or `null` if [pairId] is not part
  /// of the match.
  PairId? opponentOf(PairId pairId) {
    if (pairId == pairOneId) return pairTwoId;
    if (pairId == pairTwoId) return pairOneId;
    return null;
  }

  Match copyWith({
    PairId? winnerPairId,
    PairId? loserPairId,
    MatchStatus? status,
  }) {
    return Match(
      id: id,
      sessionId: sessionId,
      courtId: courtId,
      pairOneId: pairOneId,
      pairTwoId: pairTwoId,
      winnerPairId: winnerPairId ?? this.winnerPairId,
      loserPairId: loserPairId ?? this.loserPairId,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Match &&
      other.id == id &&
      other.sessionId == sessionId &&
      other.courtId == courtId &&
      other.pairOneId == pairOneId &&
      other.pairTwoId == pairTwoId &&
      other.winnerPairId == winnerPairId &&
      other.loserPairId == loserPairId &&
      other.status == status;

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    courtId,
    pairOneId,
    pairTwoId,
    winnerPairId,
    loserPairId,
    status,
  );

  @override
  String toString() =>
      'Match(${id.value}, court=${courtId.value}, '
      '${pairOneId.value} vs ${pairTwoId.value}, $status)';
}
