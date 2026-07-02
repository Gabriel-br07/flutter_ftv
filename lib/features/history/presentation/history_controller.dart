import 'package:flutter_ftv/app/providers.dart';
import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/history/domain/history_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UI state for the history screen.
class HistoryState {
  const HistoryState({
    this.isLoading = false,
    this.errorMessage,
    this.events = const [],
  });

  final bool isLoading;
  final String? errorMessage;
  final List<HistoryEvent> events;
}

/// Loads the session's history events (newest first).
class HistoryController extends Notifier<HistoryState> {
  @override
  HistoryState build() => const HistoryState();

  Future<void> load(String sessionId) async {
    state = const HistoryState(isLoading: true);
    try {
      final loaded = await ref
          .read(sessionStateRepositoryProvider)
          .loadState(SessionId(sessionId));
      state = HistoryState(events: loaded.history.reversed.toList());
    } on Object {
      state = const HistoryState(
        errorMessage: 'Não foi possível carregar o histórico',
      );
    }
  }
}

final historyControllerProvider =
    NotifierProvider<HistoryController, HistoryState>(HistoryController.new);
