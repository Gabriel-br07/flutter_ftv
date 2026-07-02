/// Lifecycle status of a (temporary) pair.
enum PairStatus {
  /// Waiting in the pair queue to enter a court.
  queued,

  /// Currently playing a match on a court.
  playing,

  /// Reigning winner of its own court, eligible to rise to the court directly
  /// above once that upper court finishes. While in this state the pair keeps
  /// defending on its own court against challengers rising from below.
  waitingForUpperCourt,

  /// No longer active: its players have returned individually to the queue.
  dissolved,
}
