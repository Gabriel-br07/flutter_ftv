import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/courts/domain/court_status.dart';

/// A court in the ladder.
///
/// Courts are named A, B, C, D... where A is the main court. [level] is the
/// ladder position: Court A is level 1, Court B is level 2, and so on. A lower
/// court's winner rises to the court immediately above (a smaller [level]).
class Court {
  const Court({
    required this.id,
    required this.sessionId,
    required this.name,
    required this.level,
    this.status = CourtStatus.empty,
  });

  /// Creates a court whose [name] is derived from its 1-based [level]
  /// (1 -> "A", 2 -> "B", ...).
  factory Court.atLevel({
    required CourtId id,
    required SessionId sessionId,
    required int level,
    CourtStatus status = CourtStatus.empty,
  }) {
    return Court(
      id: id,
      sessionId: sessionId,
      name: nameForLevel(level),
      level: level,
      status: status,
    );
  }

  final CourtId id;
  final SessionId sessionId;
  final String name;
  final int level;
  final CourtStatus status;

  /// Whether this is the main court (Court A).
  bool get isMainCourt => level == 1;

  /// The name for a 1-based ladder [level]: 1 -> "A", 2 -> "B", ... 26 -> "Z".
  static String nameForLevel(int level) {
    if (level < 1) {
      throw ArgumentError.value(level, 'level', 'Court level must be >= 1');
    }
    // Uppercase 'A' is code unit 65, so level 1 maps to 65.
    return String.fromCharCode(64 + level);
  }

  Court copyWith({CourtStatus? status}) {
    return Court(
      id: id,
      sessionId: sessionId,
      name: name,
      level: level,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Court &&
      other.id == id &&
      other.sessionId == sessionId &&
      other.name == name &&
      other.level == level &&
      other.status == status;

  @override
  int get hashCode => Object.hash(id, sessionId, name, level, status);

  @override
  String toString() => 'Court(${id.value}, $name, level=$level, $status)';
}
