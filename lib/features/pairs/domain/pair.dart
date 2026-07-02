import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_origin.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_status.dart';

/// A temporary pairing of two players.
///
/// Pairs are transient: when a pair loses, gets tired, or leaves the court it
/// is dissolved and its players return individually to the end of the queue.
class Pair {
  const Pair({
    required this.id,
    required this.sessionId,
    required this.playerOneId,
    required this.playerTwoId,
    required this.origin,
    this.status = PairStatus.queued,
    required this.queueOrder,
  });

  final PairId id;
  final SessionId sessionId;
  final PlayerId playerOneId;
  final PlayerId playerTwoId;
  final PairOrigin origin;
  final PairStatus status;

  /// Ordering key within the pair queue. Lower comes first; manual pairs get a
  /// high value so they land at the end of the queue.
  final int queueOrder;

  /// The two player ids that make up this pair.
  List<PlayerId> get playerIds => [playerOneId, playerTwoId];

  /// Whether [playerId] belongs to this pair.
  bool contains(PlayerId playerId) =>
      playerOneId == playerId || playerTwoId == playerId;

  /// Whether this pair still occupies an active slot (queue or court).
  bool get isActive => status != PairStatus.dissolved;

  Pair copyWith({PairStatus? status, int? queueOrder}) {
    return Pair(
      id: id,
      sessionId: sessionId,
      playerOneId: playerOneId,
      playerTwoId: playerTwoId,
      origin: origin,
      status: status ?? this.status,
      queueOrder: queueOrder ?? this.queueOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Pair &&
      other.id == id &&
      other.sessionId == sessionId &&
      other.playerOneId == playerOneId &&
      other.playerTwoId == playerTwoId &&
      other.origin == origin &&
      other.status == status &&
      other.queueOrder == queueOrder;

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    playerOneId,
    playerTwoId,
    origin,
    status,
    queueOrder,
  );

  @override
  String toString() =>
      'Pair(${id.value}, ${playerOneId.value}+${playerTwoId.value}, '
      '$origin, $status, order=$queueOrder)';
}
