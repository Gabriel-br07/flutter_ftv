import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/matches/domain/rotation_state.dart';
import 'package:flutter_ftv/features/pairs/domain/pair.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_origin.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_status.dart';
import 'package:flutter_ftv/features/players/domain/player.dart';
import 'package:flutter_ftv/features/players/domain/player_status.dart';
import 'package:flutter_ftv/features/players/presentation/players_controller.dart';
import 'package:flutter_ftv/features/players/presentation/widgets/import_participants_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Adds players by arrival order and forms the pairs that start the round.
class PlayersScreen extends ConsumerStatefulWidget {
  const PlayersScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  ConsumerState<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends ConsumerState<PlayersScreen> {
  final _nameController = TextEditingController();
  final _selected = <String>{};

  @override
  void initState() {
    super.initState();
    unawaited(
      Future.microtask(
        () =>
            ref.read(playersControllerProvider.notifier).load(widget.sessionId),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  PlayersController get _controller =>
      ref.read(playersControllerProvider.notifier);

  Future<void> _addPlayer() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    _nameController.clear();
    await _controller.addPlayer(name);
  }

  Future<void> _importParticipants() async {
    final roster =
        ref.read(playersControllerProvider).state?.roster ?? const [];
    final existingNames = [
      for (final p in roster)
        if (p.status != PlayerStatus.removed) p.name,
    ];
    final names = await showImportParticipantsSheet(
      context,
      existingNames: existingNames,
    );
    if (names != null && names.isNotEmpty) {
      await _controller.importPlayers(names);
    }
  }

  Future<void> _confirmRemove(Player player) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover jogador'),
        content: Text('Remover ${player.name} da pelada?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await _controller.removePlayer(player.id);
    }
  }

  Future<void> _chooseManualPair() async {
    if (_selected.length != 2) return;
    final ids = _selected.map(PlayerId.new).toList();
    setState(_selected.clear);
    await _controller.createManualPair(ids[0], ids[1]);
  }

  Future<void> _confirmDissolve(Pair pair, String names) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desfazer dupla'),
        content: Text('Desfazer a dupla $names?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Desfazer'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await _controller.dissolvePair(pair.id);
    }
  }

  /// The formed pairs still waiting to enter a court, ordered the way they will
  /// take courts: automatic pairs first, the manually chosen ones last.
  List<Pair> _formedPairs(RotationState? rotation) {
    if (rotation == null) return const [];
    final onCourt = {
      for (final slot in rotation.slots)
        for (final id in slot.pairIds) id.value,
    };
    return [
      for (final p in rotation.pairs)
        if (p.status != PairStatus.dissolved && !onCourt.contains(p.id.value))
          p,
    ]..sort((a, b) {
      if (a.origin != b.origin) {
        return a.origin == PairOrigin.automatic ? -1 : 1;
      }
      return a.queueOrder.compareTo(b.queueOrder);
    });
  }

  Future<void> _start() async {
    final started = await _controller.start();
    if (started && mounted) {
      context.go('/sessions/${widget.sessionId}/courts');
    }
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_selected.length < 2) {
        _selected.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(playersControllerProvider, (previous, next) {
      final message = next.infoMessage ?? next.errorMessage;
      if (message != null) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(message)));
        _controller.clearMessages();
      }
    });

    final playersState = ref.watch(playersControllerProvider);
    final rotation = playersState.state;
    final queue = rotation?.queuedPlayers ?? const <Player>[];
    final pairs = _formedPairs(rotation);
    final names = {
      for (final p in rotation?.roster ?? const <Player>[]) p.id.value: p.name,
    };
    final hasPairs = pairs.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogadores'),
        actions: [
          IconButton(
            key: const Key('importParticipantsButton'),
            onPressed: _importParticipants,
            icon: const Icon(Icons.playlist_add),
            tooltip: 'Importar participantes',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('playerNameField'),
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      onSubmitted: (_) => _addPlayer(),
                      decoration: const InputDecoration(
                        labelText: 'Nome do jogador',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    key: const Key('addPlayerButton'),
                    onPressed: _addPlayer,
                    iconSize: 32,
                    icon: const Icon(Icons.add),
                    tooltip: 'Adicionar jogador',
                  ),
                ],
              ),
            ),
            Expanded(
              child: playersState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _DraftList(
                      players: queue,
                      pairs: pairs,
                      names: names,
                      selected: _selected,
                      onToggle: _toggle,
                      onRemove: _confirmRemove,
                      onDissolve: _confirmDissolve,
                    ),
            ),
            _BottomBar(
              canFormPairs: queue.length >= 2,
              canChoosePair: _selected.length == 2,
              canStart: hasPairs || queue.length >= 2,
              onFormPairs: _controller.formAutomaticPairs,
              onChoosePair: _chooseManualPair,
              onStart: _start,
            ),
          ],
        ),
      ),
    );
  }
}

/// The draft roster: individual players (in arrival order) followed by the
/// pairs already formed. A manually chosen pair is marked "Escolhida" and lands
/// last; the odd leftover keeps a priority badge.
class _DraftList extends StatelessWidget {
  const _DraftList({
    required this.players,
    required this.pairs,
    required this.names,
    required this.selected,
    required this.onToggle,
    required this.onRemove,
    required this.onDissolve,
  });

  final List<Player> players;
  final List<Pair> pairs;
  final Map<String, String> names;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final ValueChanged<Player> onRemove;
  final void Function(Pair pair, String names) onDissolve;

  String _pairNames(Pair pair) {
    final one = names[pair.playerOneId.value] ?? '?';
    final two = names[pair.playerTwoId.value] ?? '?';
    return '$one & $two';
  }

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty && pairs.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum jogador cadastrado',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (players.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('Ordem de chegada', style: theme.textTheme.titleMedium),
          ),
          for (var i = 0; i < players.length; i++)
            _PlayerCard(
              position: i + 1,
              player: players[i],
              selected: selected.contains(players[i].id.value),
              onToggle: () => onToggle(players[i].id.value),
              onRemove: () => onRemove(players[i]),
            ),
        ],
        if (pairs.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text('Duplas formadas', style: theme.textTheme.titleMedium),
          ),
          for (final pair in pairs)
            _PairCard(
              pair: pair,
              names: _pairNames(pair),
              onDissolve: () => onDissolve(pair, _pairNames(pair)),
            ),
        ],
      ],
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.position,
    required this.player,
    required this.selected,
    required this.onToggle,
    required this.onRemove,
  });

  final int position;
  final Player player;
  final bool selected;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final waiting = player.status == PlayerStatus.waitingForPair;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: CheckboxListTile(
        value: selected,
        onChanged: (_) => onToggle(),
        controlAffinity: ListTileControlAffinity.leading,
        title: Row(
          children: [
            Expanded(
              child: Text(
                '$position. ${player.name}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            if (waiting)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.priority_high,
                      size: 14,
                      color: scheme.onTertiaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Prioridade',
                      style: TextStyle(
                        color: scheme.onTertiaryContainer,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        subtitle: waiting ? const Text('Jogador aguardando dupla') : null,
        secondary: IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Remover',
        ),
      ),
    );
  }
}

class _PairCard extends StatelessWidget {
  const _PairCard({
    required this.pair,
    required this.names,
    required this.onDissolve,
  });

  final Pair pair;
  final String names;
  final VoidCallback onDissolve;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final manual = pair.origin == PairOrigin.manual;
    final (Color bg, Color fg) = manual
        ? (scheme.tertiaryContainer, scheme.onTertiaryContainer)
        : (scheme.primaryContainer, scheme.onPrimaryContainer);
    return Card(
      child: ListTile(
        leading: Icon(Icons.groups, color: scheme.primary),
        title: Text(
          names,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  manual ? 'Escolhida' : 'Automática',
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          onPressed: onDissolve,
          icon: const Icon(Icons.link_off),
          tooltip: 'Desfazer dupla',
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.canFormPairs,
    required this.canChoosePair,
    required this.canStart,
    required this.onFormPairs,
    required this.onChoosePair,
    required this.onStart,
  });

  final bool canFormPairs;
  final bool canChoosePair;
  final bool canStart;
  final VoidCallback onFormPairs;
  final VoidCallback onChoosePair;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    key: const Key('formPairsButton'),
                    onPressed: canFormPairs ? onFormPairs : null,
                    child: const Text('Formar duplas'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    key: const Key('manualPairButton'),
                    onPressed: canChoosePair ? onChoosePair : null,
                    child: const Text('Escolher dupla'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              key: const Key('startRoundButton'),
              onPressed: canStart ? onStart : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar pelada'),
            ),
          ],
        ),
      ),
    );
  }
}
