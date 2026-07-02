/// Occupancy status of a court.
enum CourtStatus {
  /// No pairs assigned; can be filled from the available queue.
  empty,

  /// A match is currently being played.
  occupied,

  /// Holds a single reigning pair waiting for a challenger (e.g. the Court A
  /// winner with no challenger available yet).
  awaitingChallenger,
}
