/// Generates process-unique, restart-safe string ids.
///
/// Each id combines a microsecond timestamp (unique across app restarts, since
/// wall-clock time advances) with a monotonically increasing in-process counter
/// (unique within a run, even for ids minted in the same microsecond). This is
/// injected into the pure engine's id builders by the data layer, keeping the
/// domain itself free of any clock or randomness.
class IdGenerator {
  IdGenerator({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  int _seq = 0;

  /// Returns a new id of the form `<prefix>-<microseconds>-<seq>`.
  String next(String prefix) =>
      '$prefix-${_now().microsecondsSinceEpoch}-${_seq++}';
}
