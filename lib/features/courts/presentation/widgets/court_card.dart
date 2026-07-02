import 'package:flutter/material.dart';
import 'package:flutter_ftv/core/layout/app_breakpoints.dart';
import 'package:flutter_ftv/core/theme/status_style.dart';
import 'package:flutter_ftv/core/utils/labels.dart';
import 'package:flutter_ftv/core/widgets/responsive_button_row.dart';
import 'package:flutter_ftv/features/courts/presentation/widgets/pair_tile.dart';

/// A large card for a single court showing the current match (or empty state)
/// and the primary winner/exit actions.
class CourtCard extends StatelessWidget {
  const CourtCard({
    required this.name,
    required this.status,
    required this.active,
    this.isMainCourt = false,
    this.pairOne,
    this.pairTwo,
    this.onWinOne,
    this.onWinTwo,
    this.onTired,
    this.onBothLeft,
    this.winnerOneKey,
    this.winnerTwoKey,
    this.tiredKey,
    this.bothLeftKey,
    super.key,
  });

  final String name;

  /// The court's current display status, driving the status chip's color, icon
  /// and (via [Labels.courtStatus]) its label.
  final CourtDisplayStatus status;

  /// Whether a match is in progress here (shows the winner/exit actions and
  /// gives the card a highlighted border).
  final bool active;

  /// Whether this is Court A (the main court), shown with a "Principal" badge.
  final bool isMainCourt;
  final String? pairOne;
  final String? pairTwo;
  final VoidCallback? onWinOne;
  final VoidCallback? onWinTwo;
  final VoidCallback? onTired;
  final VoidCallback? onBothLeft;

  /// Stable keys for the action buttons, supplied per court by the screen so
  /// integration tests can target a specific court's buttons.
  final Key? winnerOneKey;
  final Key? winnerTwoKey;
  final Key? tiredKey;
  final Key? bothLeftKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      // A highlighted border marks the court with a live match at a glance.
      shape: active
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: scheme.primary, width: 2),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CourtHeader(
              name: name,
              isMainCourt: isMainCourt,
              status: status,
              scheme: scheme,
              titleStyle: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (pairOne == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  Labels.courtStatus(CourtDisplayStatus.empty),
                  style: theme.textTheme.titleMedium,
                ),
              )
            else ...[
              PairTile(label: 'Dupla 1', playerNames: pairOne!),
              if (pairTwo != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text('x', style: theme.textTheme.titleMedium),
                ),
                PairTile(
                  label: 'Dupla 2',
                  playerNames: pairTwo!,
                  accent: PairAccent.two,
                ),
              ],
            ],
            if (active) ...[
              const SizedBox(height: 16),
              ResponsiveButtonRow(
                children: [
                  FilledButton(
                    key: winnerOneKey,
                    onPressed: onWinOne,
                    child: const Text('Dupla 1 venceu'),
                  ),
                  FilledButton(
                    key: winnerTwoKey,
                    onPressed: onWinTwo,
                    child: const Text('Dupla 2 venceu'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ResponsiveButtonRow(
                spacing: 0,
                children: [
                  TextButton(
                    key: tiredKey,
                    onPressed: onTired,
                    child: const Text('Vencedora cansou'),
                  ),
                  TextButton(
                    key: bothLeftKey,
                    onPressed: onBothLeft,
                    child: const Text('Ambas saíram'),
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

/// Court card header: the court name, an optional "Principal" badge and the
/// status chip. On roomy widths they sit on one line (name flexes, chip
/// ellipsizes if needed); on narrow widths the chip drops to its own line so a
/// long status never overflows or squashes the name.
class _CourtHeader extends StatelessWidget {
  const _CourtHeader({
    required this.name,
    required this.isMainCourt,
    required this.status,
    required this.scheme,
    required this.titleStyle,
  });

  final String name;
  final bool isMainCourt;
  final CourtDisplayStatus status;
  final ColorScheme scheme;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final chip = StatusChip(
      label: Labels.courtStatus(status),
      style: courtStatusStyle(scheme, status),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final title = Text(
          name,
          style: titleStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );

        if (constraints.maxWidth < AppBreakpoints.compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(child: title),
                  if (isMainCourt) ...[
                    const SizedBox(width: 8),
                    _MainCourtBadge(scheme: scheme),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerLeft, child: chip),
            ],
          );
        }

        // Title is the only flexible child, so it absorbs all slack and keeps
        // the chip flush right; the chip is capped so a long status truncates
        // (via StatusChip's internal ellipsis) instead of overflowing.
        return Row(
          children: [
            Expanded(child: title),
            if (isMainCourt) ...[
              const SizedBox(width: 8),
              _MainCourtBadge(scheme: scheme),
            ],
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.55,
              ),
              child: chip,
            ),
          ],
        );
      },
    );
  }
}

class _MainCourtBadge extends StatelessWidget {
  const _MainCourtBadge({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: scheme.onPrimary),
          const SizedBox(width: 4),
          Text(
            Labels.mainCourtBadge,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: scheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
