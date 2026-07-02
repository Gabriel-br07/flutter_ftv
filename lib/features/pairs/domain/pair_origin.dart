/// How a pair was formed.
enum PairOrigin {
  /// Formed automatically by queue/arrival order (1st+2nd, 3rd+4th, ...).
  automatic,

  /// Two players chose to play together; goes to the end of the pair queue and
  /// lasts only one cycle.
  manual,
}
