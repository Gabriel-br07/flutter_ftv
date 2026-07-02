import 'package:flutter_ftv/core/domain/ids.dart';

/// Occupancy of a single court within [RotationState].
///
/// A court holds a *home* (reigning/defending) pair and, when challenged, a
/// *challenger* pair. When both are present a match is active ([matchId] set).
///
/// * empty              -> no pairs assigned; can be filled from the queue.
/// * awaiting challenger -> a home pair holds the court, waiting for an opponent.
/// * active match        -> home vs challenger, [matchId] set.
class CourtSlot {
  const CourtSlot({
    required this.courtId,
    this.homePairId,
    this.challengerPairId,
    this.matchId,
  });

  /// An empty slot for [courtId].
  const CourtSlot.empty(this.courtId)
    : homePairId = null,
      challengerPairId = null,
      matchId = null;

  final CourtId courtId;
  final PairId? homePairId;
  final PairId? challengerPairId;
  final MatchId? matchId;

  bool get isEmpty => homePairId == null && challengerPairId == null;

  bool get awaitingChallenger => homePairId != null && challengerPairId == null;

  bool get hasActiveMatch => matchId != null;

  /// The pair ids currently assigned to this court (0, 1 or 2 entries).
  List<PairId> get pairIds => [?homePairId, ?challengerPairId];

  @override
  bool operator ==(Object other) =>
      other is CourtSlot &&
      other.courtId == courtId &&
      other.homePairId == homePairId &&
      other.challengerPairId == challengerPairId &&
      other.matchId == matchId;

  @override
  int get hashCode =>
      Object.hash(courtId, homePairId, challengerPairId, matchId);

  @override
  String toString() =>
      'CourtSlot(${courtId.value}, home=${homePairId?.value}, '
      'challenger=${challengerPairId?.value}, match=${matchId?.value})';
}
