import 'package:flutter_ftv/app/providers.dart';
import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/sessions/domain/session_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Transient feedback for the sessions-list actions (finish / delete). The list
/// itself refreshes reactively via `sessionsListProvider`, so this only carries
/// the message to show in a Snackbar.
class SessionsActionsState {
  const SessionsActionsState({this.infoMessage, this.errorMessage});

  final String? infoMessage;
  final String? errorMessage;
}

/// Coordinates finishing and deleting a session from the list. Keeps the
/// repository/engine calls out of the widget (the widget only confirms via a
/// dialog and shows feedback).
class SessionsActionsController extends Notifier<SessionsActionsState> {
  @override
  SessionsActionsState build() => const SessionsActionsState();

  /// Marks the session finished, recording a `sessionFinished` history event
  /// atomically with the status change (built from the loaded rotation state,
  /// same as the courts screen).
  Future<void> finish(SessionId id) async {
    try {
      final rotation = await ref
          .read(sessionStateRepositoryProvider)
          .loadState(id);
      final event = ref
          .read(sessionEngineProvider)
          .sessionFinishedEvent(rotation);
      await ref
          .read(sessionsRepositoryProvider)
          .updateStatus(id, SessionStatus.finished, event: event);
      state = const SessionsActionsState(infoMessage: 'Pelada finalizada.');
    } on Object {
      state = const SessionsActionsState(
        errorMessage: 'Não foi possível finalizar a pelada',
      );
    }
  }

  /// Permanently removes the session and its participants from local storage.
  Future<void> delete(SessionId id) async {
    try {
      await ref.read(sessionsRepositoryProvider).deleteSession(id);
      state = const SessionsActionsState(infoMessage: 'Pelada excluída.');
    } on Object {
      state = const SessionsActionsState(
        errorMessage: 'Não foi possível excluir a pelada',
      );
    }
  }

  void clearMessages() => state = const SessionsActionsState();
}

final sessionsActionsControllerProvider =
    NotifierProvider<SessionsActionsController, SessionsActionsState>(
      SessionsActionsController.new,
    );
