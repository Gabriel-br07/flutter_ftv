import 'package:flutter_ftv/app/providers.dart';
import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/core/domain/result.dart';
import 'package:flutter_ftv/features/matches/domain/rotation_state.dart';
import 'package:flutter_ftv/features/sessions/domain/session_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UI state for the (main) courts screen.
class CourtsState {
  const CourtsState({
    this.isLoading = false,
    this.errorMessage,
    this.infoMessage,
    this.state,
    this.canUndo = false,
    this.recentlyAddedPlayerId,
  });

  final bool isLoading;
  final String? errorMessage;
  final String? infoMessage;
  final RotationState? state;
  final bool canUndo;

  /// Id of the player added most recently while the session is running, so the
  /// queue can flag them as "Novo". Cleared by the next rotation action
  /// (record result / undo / reload).
  final String? recentlyAddedPlayerId;
}

/// Drives match results and rotation on the courts screen. Rotation itself is
/// delegated to [SessionEngine]/`RotationService`; the controller keeps a single
/// previous snapshot in memory to support "Desfazer última ação".
class CourtsController extends Notifier<CourtsState> {
  String? _sessionId;
  RotationState? _previous;

  @override
  CourtsState build() => const CourtsState();

  Future<void> load(String sessionId) async {
    _sessionId = sessionId;
    _previous = null;
    state = const CourtsState(isLoading: true);
    try {
      final loaded = await ref
          .read(sessionStateRepositoryProvider)
          .loadState(SessionId(sessionId));
      state = CourtsState(state: loaded);
    } on Object {
      state = const CourtsState(
        errorMessage: 'Não foi possível carregar as quadras',
      );
    }
  }

  /// Adds a player to the **end of the queue** while the session is running,
  /// without touching players already on a court or reordering the queue. If a
  /// court is currently idle, the new entrant is seated on it (bottom-first) via
  /// [SessionEngine.fillOpenCourts]. Blocks duplicate names with a warning.
  ///
  /// Adding a player clears the pending undo: the single-level undo only restores
  /// the state from before the last match result, which would silently drop a
  /// player added afterwards.
  Future<void> addPlayer(String name) async {
    final current = state.state;
    if (current == null || name.trim().isEmpty) return;
    final engine = ref.read(sessionEngineProvider);
    final result = engine.addPlayer(current, name);
    switch (result) {
      case Failure():
        state = _message(
          errorMessage:
              'Já existe um jogador com esse nome. '
              'Adicione um sobrenome para diferenciar.',
        );
      case Success(:final value):
        final addedId = value.queue.last.value;
        final filled = engine.fillOpenCourts(value);
        try {
          await ref.read(sessionStateRepositoryProvider).saveState(filled);
          _previous = null;
          state = CourtsState(
            state: filled,
            infoMessage: 'Jogador adicionado à fila',
            recentlyAddedPlayerId: addedId,
          );
        } on Object {
          state = _message(
            errorMessage: 'Não foi possível adicionar o jogador',
          );
        }
    }
  }

  /// Records a match result and applies the rotation. [winnerPairId] must belong
  /// to the match; for [bothPairsLeft] it is ignored by the engine.
  Future<void> recordResult({
    required MatchId matchId,
    required PairId winnerPairId,
    bool winnerGotTired = false,
    bool bothPairsLeft = false,
  }) async {
    final current = state.state;
    if (current == null) return;
    try {
      final result = ref
          .read(sessionEngineProvider)
          .finishMatch(
            current,
            matchId: matchId,
            winnerPairId: winnerPairId,
            winnerGotTired: winnerGotTired,
            bothPairsLeft: bothPairsLeft,
          );
      if (result.hasErrors) {
        state = _message(errorMessage: 'Essa ação não pode ser concluída');
        return;
      }
      await ref.read(sessionStateRepositoryProvider).saveState(result.state);
      // Only enable undo once the new state is safely persisted.
      _previous = current;
      state = CourtsState(
        state: result.state,
        canUndo: true,
        infoMessage: 'Resultado registrado',
      );
    } on Object {
      state = _message(errorMessage: 'Essa ação não pode ser concluída');
    }
  }

  /// Restores the state from before the last recorded result (single level).
  /// The `undoPerformed` event is built by the engine (deterministic clock/ids),
  /// keeping domain event construction out of the ViewModel.
  Future<void> undo() async {
    final previous = _previous;
    if (previous == null) return;
    try {
      final restored = ref.read(sessionEngineProvider).undo(previous);
      await ref.read(sessionStateRepositoryProvider).saveState(restored);
      _previous = null;
      state = CourtsState(state: restored, infoMessage: 'Ação desfeita');
    } on Object {
      state = _message(errorMessage: 'Essa ação não pode ser concluída');
    }
  }

  /// Marks the session finished, recording a `sessionFinished` history event
  /// atomically with the status change. Returns `true` on success.
  Future<bool> finishSession() async {
    final sessionId = _sessionId;
    if (sessionId == null) return false;
    final current = state.state;
    try {
      final event = current == null
          ? null
          : ref.read(sessionEngineProvider).sessionFinishedEvent(current);
      await ref
          .read(sessionsRepositoryProvider)
          .updateStatus(
            SessionId(sessionId),
            SessionStatus.finished,
            event: event,
          );
      return true;
    } on Object {
      state = _message(errorMessage: 'Essa ação não pode ser concluída');
      return false;
    }
  }

  void clearMessages() => state = CourtsState(
    state: state.state,
    canUndo: _previous != null,
    recentlyAddedPlayerId: state.recentlyAddedPlayerId,
  );

  CourtsState _message({String? errorMessage, String? infoMessage}) =>
      CourtsState(
        state: state.state,
        canUndo: _previous != null,
        errorMessage: errorMessage,
        infoMessage: infoMessage,
        recentlyAddedPlayerId: state.recentlyAddedPlayerId,
      );
}

final courtsControllerProvider =
    NotifierProvider<CourtsController, CourtsState>(CourtsController.new);
