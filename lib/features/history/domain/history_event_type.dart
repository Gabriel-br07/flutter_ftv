/// The kind of state change recorded in the session history.
enum HistoryEventType {
  sessionCreated,
  playerAdded,
  playerRemoved,
  pairsGenerated,
  matchStarted,
  matchFinished,
  winnerTired,
  bothPairsLeft,
  playerReturnedToQueue,
  pairDissolved,
  rotationApplied,
  undoPerformed,
  sessionStarted,
  sessionFinished,
}
