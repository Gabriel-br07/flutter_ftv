import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/core/theme/session_status_chip.dart';
import 'package:flutter_ftv/core/theme/status_style.dart';
import 'package:flutter_ftv/core/utils/labels.dart';
import 'package:flutter_ftv/core/widgets/responsive_button_row.dart';
import 'package:flutter_ftv/features/courts/presentation/courts_controller.dart';
import 'package:flutter_ftv/features/courts/presentation/widgets/court_card.dart';
import 'package:flutter_ftv/features/courts/presentation/widgets/queue_section.dart';
import 'package:flutter_ftv/features/matches/domain/rotation_state.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The main operational screen: courts as large cards with the winner/exit
/// actions, the waiting queue, undo and finish-session.
class CourtsScreen extends ConsumerStatefulWidget {
  const CourtsScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  ConsumerState<CourtsScreen> createState() => _CourtsScreenState();
}

class _CourtsScreenState extends ConsumerState<CourtsScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(
      Future.microtask(
        () =>
            ref.read(courtsControllerProvider.notifier).load(widget.sessionId),
      ),
    );
  }

  CourtsController get _controller =>
      ref.read(courtsControllerProvider.notifier);

  String _pairNames(RotationState state, Map<String, String> names, PairId id) {
    final pair = state.pairById(id);
    if (pair == null) return '—';
    final one = names[pair.playerOneId.value] ?? '?';
    final two = names[pair.playerTwoId.value] ?? '?';
    return '$one & $two';
  }

  Future<void> _onTired(MatchId matchId, PairId home, PairId away) async {
    final winner = await showDialog<PairId>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vencedora cansou'),
        content: const Text('Qual dupla venceu antes de sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, home),
            child: const Text('Dupla 1'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, away),
            child: const Text('Dupla 2'),
          ),
        ],
      ),
    );
    if (winner != null) {
      await _controller.recordResult(
        matchId: matchId,
        winnerPairId: winner,
        winnerGotTired: true,
      );
    }
  }

  Future<void> _onBothLeft(MatchId matchId, PairId anyPair) async {
    final confirmed = await _confirm(
      title: 'Ambas saíram',
      message: 'Confirmar que as duas duplas saíram da quadra?',
      confirmLabel: 'Confirmar',
    );
    if (confirmed) {
      await _controller.recordResult(
        matchId: matchId,
        winnerPairId: anyPair,
        bothPairsLeft: true,
      );
    }
  }

  Future<void> _onAddPlayer() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const _AddPlayerDialog(),
    );
    if (name != null && name.isNotEmpty) {
      await _controller.addPlayer(name);
    }
  }

  Future<void> _onFinish() async {
    final confirmed = await _confirm(
      title: 'Finalizar pelada?',
      message:
          'Depois de finalizar, você ainda poderá ver esta pelada na lista e '
          'excluí-la quando quiser.',
      confirmLabel: 'Finalizar',
    );
    if (!confirmed) return;
    final done = await _controller.finishSession();
    if (done && mounted) context.go('/sessions');
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(courtsControllerProvider, (previous, next) {
      final message = next.infoMessage ?? next.errorMessage;
      if (message != null) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(message)));
        _controller.clearMessages();
      }
    });

    final courtsState = ref.watch(courtsControllerProvider);
    final rotation = courtsState.state;
    final recentlyAddedId = courtsState.recentlyAddedPlayerId;

    return Scaffold(
      key: const Key('courtsScreen'),
      appBar: AppBar(
        title: const Text('Quadras'),
        actions: [
          IconButton(
            key: const Key('addPlayerButton'),
            onPressed: rotation == null ? null : _onAddPlayer,
            icon: const Icon(Icons.person_add),
            tooltip: 'Adicionar jogador',
          ),
          IconButton(
            key: const Key('historyButton'),
            onPressed: () =>
                context.go('/sessions/${widget.sessionId}/history'),
            icon: const Icon(Icons.history),
            tooltip: 'Histórico',
          ),
        ],
      ),
      body: courtsState.isLoading || rotation == null
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(rotation, recentlyAddedId),
      bottomNavigationBar: rotation == null
          ? null
          : _BottomActions(
              canUndo: courtsState.canUndo,
              onUndo: _controller.undo,
              onFinish: _onFinish,
            ),
    );
  }

  Widget _buildBody(RotationState rotation, String? recentlyAddedId) {
    final names = {for (final p in rotation.roster) p.id.value: p.name};
    final waitingPairNames = <String>[];
    for (final slot in rotation.slots) {
      if (slot.matchId == null && slot.homePairId != null) {
        final pair = rotation.pairById(slot.homePairId!);
        if (pair?.status == PairStatus.waitingForUpperCourt) {
          waitingPairNames.add(_pairNames(rotation, names, slot.homePairId!));
        }
      }
    }

    final queued = rotation.queuedPlayers;
    final queueViews = <QueuePlayerView>[
      for (var i = 0; i < queued.length; i++)
        (
          name: queued[i].name,
          role: queued[i].id.value == recentlyAddedId
              ? QueueChipRole.newlyAdded
              : (i == 0 ? QueueChipRole.next : QueueChipRole.normal),
        ),
    ];

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  rotation.session.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              SessionStatusChip(status: rotation.session.status),
            ],
          ),
          Text(Labels.targetPoints(rotation.session.targetPoints)),
          const SizedBox(height: 16),
          for (final court in rotation.courts)
            _buildCourtCard(rotation, names, court.id, court.name),
          const SizedBox(height: 8),
          QueueSection(players: queueViews, waitingPairNames: waitingPairNames),
        ],
      ),
    );
  }

  Widget _buildCourtCard(
    RotationState rotation,
    Map<String, String> names,
    CourtId courtId,
    String courtName,
  ) {
    final label = 'Quadra $courtName';
    final cardKey = Key('court${courtName}Card');
    final isMainCourt = courtName == 'A';
    final slot = rotation.slotForCourt(courtId);
    final match = rotation.activeMatchOnCourt(courtId);

    if (match != null) {
      final home = match.pairOneId;
      final away = match.pairTwoId;
      return CourtCard(
        key: cardKey,
        name: label,
        status: CourtDisplayStatus.playing,
        active: true,
        isMainCourt: isMainCourt,
        pairOne: _pairNames(rotation, names, home),
        pairTwo: _pairNames(rotation, names, away),
        winnerOneKey: Key('court${courtName}WinnerPairOneButton'),
        winnerTwoKey: Key('court${courtName}WinnerPairTwoButton'),
        tiredKey: Key('court${courtName}TiredButton'),
        bothLeftKey: Key('court${courtName}BothLeftButton'),
        onWinOne: () =>
            _controller.recordResult(matchId: match.id, winnerPairId: home),
        onWinTwo: () =>
            _controller.recordResult(matchId: match.id, winnerPairId: away),
        onTired: () => _onTired(match.id, home, away),
        onBothLeft: () => _onBothLeft(match.id, home),
      );
    }

    if (slot?.homePairId != null) {
      final homePair = rotation.pairById(slot!.homePairId!);
      final waiting = homePair?.status == PairStatus.waitingForUpperCourt;
      return CourtCard(
        key: cardKey,
        name: label,
        status: waiting
            ? CourtDisplayStatus.awaitingUpperCourt
            : CourtDisplayStatus.awaitingPair,
        active: false,
        isMainCourt: isMainCourt,
        pairOne: _pairNames(rotation, names, slot.homePairId!),
      );
    }

    return CourtCard(
      key: cardKey,
      name: label,
      status: CourtDisplayStatus.empty,
      active: false,
      isMainCourt: isMainCourt,
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.canUndo,
    required this.onUndo,
    required this.onFinish,
  });

  final bool canUndo;
  final VoidCallback onUndo;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ResponsiveButtonRow(
          children: [
            OutlinedButton.icon(
              onPressed: canUndo ? onUndo : null,
              icon: const Icon(Icons.undo),
              label: const Text('Desfazer última ação'),
            ),
            FilledButton.icon(
              onPressed: onFinish,
              icon: const Icon(Icons.flag),
              label: const Text('Finalizar pelada'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog to add a player to the queue while the session is running. Owns its
/// own [TextEditingController] so it survives the dialog's exit animation
/// (disposing it from the caller would tear it down mid-animation).
class _AddPlayerDialog extends StatefulWidget {
  const _AddPlayerDialog();

  @override
  State<_AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<_AddPlayerDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.pop(context, _controller.text.trim());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar jogador'),
      content: TextField(
        key: const Key('courtsPlayerNameField'),
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          labelText: 'Nome do jogador',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('courtsConfirmAddPlayerButton'),
          onPressed: _submit,
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
