/// Lifecycle status of a futevôlei session.
enum SessionStatus {
  /// Being set up (players/courts not finalized yet).
  draft,

  /// Currently being played.
  active,

  /// Ended by the organizer.
  finished,
}
