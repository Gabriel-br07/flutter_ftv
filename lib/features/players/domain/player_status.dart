/// Where a player currently is within the session.
enum PlayerStatus {
  /// Available in the individual player queue.
  queued,

  /// Currently on a court in an active pair.
  playing,

  /// The leftover player of an odd count, waiting for the next player to pair.
  waitingForPair,

  /// Manually removed from the session by the organizer.
  removed,
}
