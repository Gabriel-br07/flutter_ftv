/// Lifecycle status of a match.
enum MatchStatus {
  /// Being played; no result recorded yet.
  active,

  /// A winner/loser has been recorded.
  finished,

  /// Voided before finishing (e.g. a player on the court was removed).
  cancelled,
}
