import 'package:flutter_ftv/core/theme/status_style.dart';
import 'package:flutter_ftv/features/history/domain/history_event_type.dart';
import 'package:flutter_ftv/features/sessions/domain/session_status.dart';

/// Brazilian-Portuguese user-facing labels derived from domain values.
///
/// All app text lives here (or in the widgets) in Portuguese; the domain layer
/// stays English. The history screen formats events by *type* via
/// [historyEventLabel], not by the engine's English `description`.
class Labels {
  const Labels._();

  static String targetPoints(int points) => 'Jogo até $points pontos';

  static String courtCount(int count) =>
      count == 1 ? '1 quadra' : '$count quadras';

  static String sessionStatus(SessionStatus status) => switch (status) {
    SessionStatus.draft => 'Rascunho',
    SessionStatus.active => 'Em andamento',
    SessionStatus.finished => 'Finalizada',
  };

  static String courtStatus(CourtDisplayStatus status) => switch (status) {
    CourtDisplayStatus.playing => 'Em jogo',
    CourtDisplayStatus.awaitingUpperCourt => 'Aguardando quadra superior',
    CourtDisplayStatus.awaitingPair => 'Aguardando dupla',
    CourtDisplayStatus.empty => 'Sem partida',
  };

  /// Badge marking Court A as the main court.
  static const String mainCourtBadge = 'Principal';

  /// Badge for the next player to enter.
  static const String nextInQueue = 'Próximo';

  /// Badge for a player just added while the session is running.
  static const String newlyAdded = 'Novo';

  static String historyEventLabel(HistoryEventType type) => switch (type) {
    HistoryEventType.sessionCreated => 'Pelada criada',
    HistoryEventType.playerAdded => 'Jogador adicionado',
    HistoryEventType.playerRemoved => 'Jogador removido',
    HistoryEventType.pairsGenerated => 'Duplas formadas',
    HistoryEventType.matchStarted => 'Partida iniciada',
    HistoryEventType.matchFinished => 'Partida finalizada',
    HistoryEventType.winnerTired => 'Vencedora cansou',
    HistoryEventType.bothPairsLeft => 'Ambas as duplas saíram',
    HistoryEventType.playerReturnedToQueue => 'Jogador voltou para a fila',
    HistoryEventType.pairDissolved => 'Dupla desfeita',
    HistoryEventType.rotationApplied => 'Rotação aplicada',
    HistoryEventType.undoPerformed => 'Ação desfeita',
    HistoryEventType.sessionStarted => 'Pelada iniciada',
    HistoryEventType.sessionFinished => 'Pelada finalizada',
  };
}
