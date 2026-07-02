import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/sessions/domain/session_status.dart';

/// A casual futevôlei session controlled by a single organizer.
///
/// Immutable value object. Hard invariants are enforced by the [Session.create]
/// factory, which throws [ArgumentError] for invalid input:
///
/// * [name] cannot be blank.
/// * [courtCount] must be at least 1.
/// * [targetPoints] must be exactly 15 or 18.
class Session {
  const Session._({
    required this.id,
    required this.name,
    required this.courtCount,
    required this.targetPoints,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// The only valid target-point values in the MVP.
  static const Set<int> allowedTargetPoints = {15, 18};

  /// Creates a validated [Session].
  ///
  /// Throws [ArgumentError] when any invariant is violated.
  factory Session.create({
    required SessionId id,
    required String name,
    required int courtCount,
    required int targetPoints,
    required DateTime createdAt,
    DateTime? updatedAt,
    SessionStatus status = SessionStatus.draft,
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError.value(name, 'name', 'Session name cannot be blank');
    }
    if (courtCount < 1) {
      throw ArgumentError.value(
        courtCount,
        'courtCount',
        'Court count must be at least 1',
      );
    }
    if (!allowedTargetPoints.contains(targetPoints)) {
      throw ArgumentError.value(
        targetPoints,
        'targetPoints',
        'Target points must be 15 or 18',
      );
    }
    return Session._(
      id: id,
      name: name,
      courtCount: courtCount,
      targetPoints: targetPoints,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? createdAt,
    );
  }

  final SessionId id;
  final String name;
  final int courtCount;
  final int targetPoints;
  final SessionStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Session copyWith({
    String? name,
    int? courtCount,
    int? targetPoints,
    SessionStatus? status,
    DateTime? updatedAt,
  }) {
    // Route through the factory so invariants stay enforced on updates.
    return Session.create(
      id: id,
      name: name ?? this.name,
      courtCount: courtCount ?? this.courtCount,
      targetPoints: targetPoints ?? this.targetPoints,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
