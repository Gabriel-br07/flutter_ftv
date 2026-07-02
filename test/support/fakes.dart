import 'dart:async';

import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/history/domain/history_event.dart';
import 'package:flutter_ftv/features/matches/data/session_state_repository.dart';
import 'package:flutter_ftv/features/matches/domain/rotation_state.dart';
import 'package:flutter_ftv/features/sessions/data/sessions_repository.dart';
import 'package:flutter_ftv/features/sessions/domain/session.dart';
import 'package:flutter_ftv/features/sessions/domain/session_status.dart';

import 'fixtures.dart';

/// In-memory [SessionStateRepository] so controller/widget tests exercise the
/// real engine without a native database.
class FakeSessionStateRepository implements SessionStateRepository {
  FakeSessionStateRepository([Map<String, RotationState>? initial])
    : _states = initial ?? {};

  final Map<String, RotationState> _states;

  RotationState? saved(String sessionId) => _states[sessionId];

  @override
  Future<RotationState> loadState(SessionId sessionId) async {
    final state = _states[sessionId.value];
    if (state == null) {
      throw StateError('No state for ${sessionId.value}');
    }
    return state;
  }

  @override
  Future<void> saveState(RotationState state) async {
    _states[state.session.id.value] = state;
  }
}

/// In-memory [SessionsRepository].
class FakeSessionsRepository implements SessionsRepository {
  final List<Session> _sessions = [];
  final _controller = StreamController<List<Session>>.broadcast();
  int _counter = 0;

  /// History events recorded alongside status changes, for test assertions.
  final List<HistoryEvent> recordedEvents = [];

  @override
  Stream<List<Session>> watchSessions() async* {
    yield List.unmodifiable(_sessions);
    yield* _controller.stream;
  }

  @override
  Future<List<Session>> getSessions() async => List.unmodifiable(_sessions);

  @override
  Future<Session> getSession(SessionId id) async =>
      _sessions.firstWhere((s) => s.id == id);

  @override
  Future<Session> createSession({
    required String name,
    required int courtCount,
    required int targetPoints,
  }) async {
    final session = Session.create(
      id: SessionId('session-${_counter++}'),
      name: name,
      courtCount: courtCount,
      targetPoints: targetPoints,
      createdAt: testTimestamp,
    );
    _sessions.add(session);
    _controller.add(List.unmodifiable(_sessions));
    return session;
  }

  @override
  Future<void> updateStatus(
    SessionId id,
    SessionStatus status, {
    HistoryEvent? event,
  }) async {
    if (event != null) recordedEvents.add(event);
    final index = _sessions.indexWhere((s) => s.id == id);
    if (index >= 0) {
      _sessions[index] = _sessions[index].copyWith(status: status);
      _controller.add(List.unmodifiable(_sessions));
    }
  }

  @override
  Future<void> deleteSession(SessionId id) async {
    _sessions.removeWhere((s) => s.id == id);
    _controller.add(List.unmodifiable(_sessions));
  }
}
