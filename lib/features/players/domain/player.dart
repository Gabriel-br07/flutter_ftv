import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/players/domain/player_status.dart';

/// A participant in a session, tracked individually.
///
/// The individual player queue (ordered by [arrivalOrder]) is the source of
/// truth for availability. A player leaves the session only through manual
/// removal by the organizer (status [PlayerStatus.removed]); losing a match
/// never removes a player.
class Player {
  const Player({
    required this.id,
    required this.sessionId,
    required this.name,
    required this.arrivalOrder,
    this.status = PlayerStatus.queued,
  });

  final PlayerId id;
  final SessionId sessionId;
  final String name;

  /// 0-based (or 1-based, caller's choice) position reflecting arrival order.
  final int arrivalOrder;

  final PlayerStatus status;

  Player copyWith({String? name, int? arrivalOrder, PlayerStatus? status}) {
    return Player(
      id: id,
      sessionId: sessionId,
      name: name ?? this.name,
      arrivalOrder: arrivalOrder ?? this.arrivalOrder,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Player &&
      other.id == id &&
      other.sessionId == sessionId &&
      other.name == name &&
      other.arrivalOrder == arrivalOrder &&
      other.status == status;

  @override
  int get hashCode => Object.hash(id, sessionId, name, arrivalOrder, status);

  @override
  String toString() =>
      'Player(${id.value}, $name, arrival=$arrivalOrder, $status)';
}
