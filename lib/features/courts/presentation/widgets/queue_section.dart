import 'package:flutter/material.dart';
import 'package:flutter_ftv/core/theme/status_style.dart';
import 'package:flutter_ftv/core/utils/labels.dart';

/// A queued player as shown on the courts screen: the display [name] and the
/// [role] that drives its emphasis (next to enter / just added / ordinary).
typedef QueuePlayerView = ({String name, QueueChipRole role});

/// Shows the individual player queue plus any pairs waiting to rise to the
/// upper court. Always visible on the courts screen. Highlights the next player
/// to enter and any player just added, each with color + icon + text label.
class QueueSection extends StatelessWidget {
  const QueueSection({
    required this.players,
    required this.waitingPairNames,
    super.key,
  });

  final List<QueuePlayerView> players;
  final List<String> waitingPairNames;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: const Key('queueSection'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fila de espera', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (players.isEmpty)
              const Text('Nenhum jogador na fila')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < players.length; i++)
                    _QueueChip.forPlayer(
                      position: i + 1,
                      player: players[i],
                      scheme: theme.colorScheme,
                    ),
                ],
              ),
            if (waitingPairNames.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Aguardando quadra superior',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final names in waitingPairNames)
                    _QueueChip(
                      text: names,
                      style: courtStatusStyle(
                        theme.colorScheme,
                        CourtDisplayStatus.awaitingUpperCourt,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A single queue chip. All chips share one filled-tonal shape so the queue
/// reads as one family: ordinary players use a neutral tone, the next player and
/// a just-added player use a soft accent with a leading icon and a small [badge].
/// Color is always paired with the icon and/or the text label — never color
/// alone.
class _QueueChip extends StatelessWidget {
  const _QueueChip({required this.text, required this.style, this.badge});

  /// Builds a chip for a queued [player] at 1-based [position].
  factory _QueueChip.forPlayer({
    required int position,
    required QueuePlayerView player,
    required ColorScheme scheme,
  }) {
    final badge = switch (player.role) {
      QueueChipRole.next => Labels.nextInQueue,
      QueueChipRole.newlyAdded => Labels.newlyAdded,
      QueueChipRole.normal => null,
    };
    return _QueueChip(
      text: '$position. ${player.name}',
      style: queueChipStyle(scheme, player.role),
      badge: badge,
    );
  }

  final String text;
  final StatusStyle style;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    // Cap a single chip's width so a very long name (or an "A & B" pair chip)
    // can't exceed the row inside the Wrap; the label then ellipsizes.
    final maxChipWidth = MediaQuery.sizeOf(context).width - 48;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxChipWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (style.icon != null) ...[
              Icon(style.icon, size: 16, color: style.foreground),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  color: style.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              _RoleBadge(label: badge!, style: style),
            ],
          ],
        ),
      ),
    );
  }
}

/// A small pill inside a chip naming its role (e.g. "Próximo", "Novo"). Uses the
/// chip's own [StatusStyle] inverted (foreground as background) so it stands out
/// while keeping the same guaranteed-contrast Material color pair.
class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.label, required this.style});

  final String label;
  final StatusStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: style.foreground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: style.background,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
