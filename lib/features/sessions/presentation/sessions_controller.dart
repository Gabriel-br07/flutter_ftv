import 'package:flutter_ftv/app/providers.dart';
import 'package:flutter_ftv/features/sessions/domain/session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the create-session form.
class CreateSessionState {
  const CreateSessionState({this.isSubmitting = false, this.errorMessage});

  final bool isSubmitting;
  final String? errorMessage;
}

/// Validates input and creates a session (with its courts and initial history
/// event) through the repository. Field values are owned by the widget and
/// passed to [submit]; this controller only tracks submission/validation state.
class CreateSessionController extends Notifier<CreateSessionState> {
  @override
  CreateSessionState build() => const CreateSessionState();

  /// Creates the session, returning it on success or `null` on validation /
  /// persistence failure (with [CreateSessionState.errorMessage] set).
  Future<Session?> submit({
    required String name,
    required int courtCount,
    required int targetPoints,
  }) async {
    if (name.trim().isEmpty) {
      state = const CreateSessionState(
        errorMessage: 'Informe o nome da pelada',
      );
      return null;
    }
    if (courtCount < 1) {
      state = const CreateSessionState(
        errorMessage: 'Informe pelo menos 1 quadra',
      );
      return null;
    }
    if (!Session.allowedTargetPoints.contains(targetPoints)) {
      state = const CreateSessionState(
        errorMessage: 'Escolha uma pontuação válida',
      );
      return null;
    }

    state = const CreateSessionState(isSubmitting: true);
    try {
      final session = await ref
          .read(sessionsRepositoryProvider)
          .createSession(
            name: name,
            courtCount: courtCount,
            targetPoints: targetPoints,
          );
      state = const CreateSessionState();
      return session;
    } on Object {
      state = const CreateSessionState(
        errorMessage: 'Não foi possível criar a pelada',
      );
      return null;
    }
  }
}

final createSessionControllerProvider =
    NotifierProvider<CreateSessionController, CreateSessionState>(
      CreateSessionController.new,
    );
