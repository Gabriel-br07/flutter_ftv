import 'package:flutter_ftv/app/providers.dart';
import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/core/domain/result.dart';
import 'package:flutter_ftv/features/matches/domain/rotation_state.dart';
import 'package:flutter_ftv/features/sessions/domain/session_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UI state for the players screen.
class PlayersState {
  const PlayersState({
    this.isLoading = false,
    this.errorMessage,
    this.infoMessage,
    this.state,
  });

  final bool isLoading;
  final String? errorMessage;
  final String? infoMessage;
  final RotationState? state;
}

/// Coordinates the players screen: add/remove players, form pairs, and start
/// the round. All rules are delegated to [SessionEngine]; persistence to the
/// [SessionStateRepository].
class PlayersController extends Notifier<PlayersState> {
  String? _sessionId;

  @override
  PlayersState build() => const PlayersState();

  Future<void> load(String sessionId) async {
    _sessionId = sessionId;
    state = const PlayersState(isLoading: true);
    try {
      final loaded = await ref
          .read(sessionStateRepositoryProvider)
          .loadState(SessionId(sessionId));
      state = PlayersState(state: loaded);
    } on Object {
      state = const PlayersState(
        errorMessage: 'Não foi possível carregar os jogadores',
      );
    }
  }

  Future<void> addPlayer(String name) async {
    final current = state.state;
    if (current == null || name.trim().isEmpty) return;
    final result = ref.read(sessionEngineProvider).addPlayer(current, name);
    switch (result) {
      case Success(:final value):
        await _persist(
          value,
          errorMessage: 'Não foi possível adicionar o jogador',
        );
      case Failure():
        state = _message(
          errorMessage:
              'Já existe um jogador com esse nome. '
              'Adicione um sobrenome para diferenciar.',
        );
    }
  }

  /// Imports a batch of participant names (from a pasted list), adding the new,
  /// unique names to the end of the queue. Duplicates are skipped and reported.
  Future<void> importPlayers(List<String> names) async {
    final current = state.state;
    if (current == null) return;
    final result = ref.read(sessionEngineProvider).addPlayers(current, names);
    if (result.addedCount == 0) {
      state = _message(errorMessage: 'Nenhum nome novo para importar.');
      return;
    }
    final skipped = result.skippedDuplicates.length;
    final plural = result.addedCount == 1
        ? 'participante importado'
        : 'participantes importados';
    final message = skipped == 0
        ? '${result.addedCount} $plural com sucesso.'
        : '${result.addedCount} $plural ($skipped ignorados por duplicidade).';
    await _persist(
      result.state,
      infoMessage: message,
      errorMessage: 'Não foi possível importar os participantes',
    );
  }

  Future<void> removePlayer(PlayerId playerId) async {
    final current = state.state;
    if (current == null) return;
    await _persist(
      ref.read(sessionEngineProvider).removePlayer(current, playerId),
      errorMessage: 'Essa ação não pode ser concluída',
    );
  }

  /// Dissolves a formed (not-yet-started) pair, returning both players to the
  /// individual queue in arrival order.
  Future<void> dissolvePair(PairId pairId) async {
    final current = state.state;
    if (current == null) return;
    await _persist(
      ref.read(sessionEngineProvider).dissolveFormedPair(current, pairId),
      infoMessage: 'Dupla desfeita',
      errorMessage: 'Essa ação não pode ser concluída',
    );
  }

  Future<void> formAutomaticPairs() async {
    final current = state.state;
    if (current == null) return;
    if (current.queuedPlayers.length < 2) {
      state = _message(
        errorMessage: 'Não há jogadores suficientes para formar duplas',
      );
      return;
    }
    await _persist(
      ref.read(sessionEngineProvider).formAutomaticPairs(current),
      infoMessage: 'Duplas formadas',
      errorMessage: 'Essa ação não pode ser concluída',
    );
  }

  Future<void> createManualPair(PlayerId one, PlayerId two) async {
    final current = state.state;
    if (current == null) return;
    final result = ref
        .read(sessionEngineProvider)
        .createManualPair(current, playerOneId: one, playerTwoId: two);
    switch (result) {
      case Success(:final value):
        await _persist(
          value,
          infoMessage: 'Dupla escolhida enviada para o final da fila',
          errorMessage: 'Essa ação não pode ser concluída',
        );
      case Failure():
        state = _message(errorMessage: 'Selecione dois jogadores disponíveis');
    }
  }

  /// Fills the courts and marks the session active. Returns `true` when at least
  /// one match started (so the screen can navigate to the courts screen).
  Future<bool> start() async {
    final current = state.state;
    final sessionId = _sessionId;
    if (current == null || sessionId == null) return false;
    try {
      final engine = ref.read(sessionEngineProvider);
      final next = engine.startRound(current);
      final started = next.matches.isNotEmpty;
      if (!started) {
        state = _message(
          errorMessage: 'Não há duplas suficientes para preencher as quadras',
        );
        return false;
      }
      await ref.read(sessionStateRepositoryProvider).saveState(next);
      await ref
          .read(sessionsRepositoryProvider)
          .updateStatus(
            SessionId(sessionId),
            SessionStatus.active,
            event: engine.sessionStartedEvent(next),
          );
      state = PlayersState(state: next);
      return true;
    } on Object {
      state = _message(errorMessage: 'Essa ação não pode ser concluída');
      return false;
    }
  }

  void clearMessages() => state = PlayersState(state: state.state);

  Future<void> _persist(
    RotationState next, {
    String? infoMessage,
    required String errorMessage,
  }) async {
    try {
      await ref.read(sessionStateRepositoryProvider).saveState(next);
      state = PlayersState(state: next, infoMessage: infoMessage);
    } on Object {
      state = _message(errorMessage: errorMessage);
    }
  }

  PlayersState _message({String? errorMessage, String? infoMessage}) =>
      PlayersState(
        state: state.state,
        errorMessage: errorMessage,
        infoMessage: infoMessage,
      );
}

final playersControllerProvider =
    NotifierProvider<PlayersController, PlayersState>(PlayersController.new);
