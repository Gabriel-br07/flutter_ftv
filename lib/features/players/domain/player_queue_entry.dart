import 'package:flutter_ftv/core/domain/ids.dart';

/// A single position in the individual player queue.
///
/// The queue is individual (the unit is the player, not the pair). [position]
/// is the ordering key: lower positions are closer to the front and are picked
/// first when forming pairs or filling empty courts.
class PlayerQueueEntry {
  const PlayerQueueEntry({required this.playerId, required this.position});

  final PlayerId playerId;
  final int position;

  PlayerQueueEntry copyWith({int? position}) {
    return PlayerQueueEntry(
      playerId: playerId,
      position: position ?? this.position,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PlayerQueueEntry &&
      other.playerId == playerId &&
      other.position == position;

  @override
  int get hashCode => Object.hash(playerId, position);

  @override
  String toString() => 'PlayerQueueEntry(${playerId.value}, pos=$position)';
}
