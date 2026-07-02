import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/history/domain/history_event_type.dart';

/// A recorded state change in a session, used for the history log and undo.
///
/// Events are created with an explicit [createdAt] so the domain stays pure and
/// deterministic (no hidden `DateTime.now()` inside services).
class HistoryEvent {
  const HistoryEvent({
    required this.id,
    required this.sessionId,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  final HistoryEventId id;
  final SessionId sessionId;
  final HistoryEventType type;

  /// Human-readable description. User-facing history text will be Portuguese;
  /// this field is intentionally free-form so the presentation layer can format
  /// it, but the engine fills it with plain, developer-facing descriptions.
  final String description;

  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      other is HistoryEvent &&
      other.id == id &&
      other.sessionId == sessionId &&
      other.type == type &&
      other.description == description &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, sessionId, type, description, createdAt);

  @override
  String toString() => 'HistoryEvent(${type.name}: $description)';
}
