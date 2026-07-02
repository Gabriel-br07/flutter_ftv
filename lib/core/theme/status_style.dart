import 'package:flutter/material.dart';

/// Semantic display states surfaced on the courts screen. Kept separate from the
/// domain enums (`CourtStatus`, `PairStatus`) because the UI needs finer
/// distinctions (e.g. "waiting for a pair" vs "waiting to rise to the upper
/// court") than any single domain enum expresses.
enum CourtDisplayStatus {
  /// A match is in progress.
  playing,

  /// The court holds a reigning winner waiting to rise to the court above.
  awaitingUpperCourt,

  /// The court has a pair but is waiting for an opponent.
  awaitingPair,

  /// No pair is assigned to the court.
  empty,
}

/// Roles a queue chip can play, driving its emphasis.
enum QueueChipRole {
  /// The next player to enter.
  next,

  /// A player just added while the session is running.
  newlyAdded,

  /// An ordinary queued player.
  normal,
}

/// A resolved (background, foreground, icon) triple for a status indicator.
///
/// All colors come from the active [ColorScheme] roles — never hard-coded — so
/// contrast holds in any theme. Color is always paired with an [icon] (and, at
/// the call site, a text label) so state is never conveyed by color alone.
@immutable
class StatusStyle {
  const StatusStyle({
    required this.background,
    required this.foreground,
    this.icon,
  });

  final Color background;
  final Color foreground;

  /// Optional leading icon; `null` renders a text-only (icon-less) indicator.
  final IconData? icon;
}

/// Visual style for a court's [status], from the theme's [scheme].
StatusStyle courtStatusStyle(ColorScheme scheme, CourtDisplayStatus status) =>
    switch (status) {
      CourtDisplayStatus.playing => StatusStyle(
        background: scheme.primaryContainer,
        foreground: scheme.onPrimaryContainer,
        icon: Icons.sports_volleyball,
      ),
      CourtDisplayStatus.awaitingUpperCourt => StatusStyle(
        background: scheme.tertiaryContainer,
        foreground: scheme.onTertiaryContainer,
        icon: Icons.arrow_upward,
      ),
      CourtDisplayStatus.awaitingPair => StatusStyle(
        background: scheme.secondaryContainer,
        foreground: scheme.onSecondaryContainer,
        icon: Icons.hourglass_top,
      ),
      CourtDisplayStatus.empty => StatusStyle(
        background: scheme.surfaceContainerHighest,
        foreground: scheme.onSurfaceVariant,
        icon: Icons.remove_circle_outline,
      ),
    };

/// Visual style for a queue chip's [role], from the theme's [scheme]. Every role
/// returns a filled tonal style so all queue chips read as one family: an
/// ordinary player gets a subtle neutral (no icon); the next player and a
/// just-added player get a soft accent with a leading icon.
StatusStyle queueChipStyle(ColorScheme scheme, QueueChipRole role) =>
    switch (role) {
      QueueChipRole.next => StatusStyle(
        background: scheme.primaryContainer,
        foreground: scheme.onPrimaryContainer,
        icon: Icons.arrow_forward,
      ),
      QueueChipRole.newlyAdded => StatusStyle(
        background: scheme.tertiaryContainer,
        foreground: scheme.onTertiaryContainer,
        icon: Icons.fiber_new,
      ),
      QueueChipRole.normal => StatusStyle(
        background: scheme.surfaceContainerHighest,
        foreground: scheme.onSurfaceVariant,
      ),
    };

/// A compact status indicator: an [icon] and a text [label] on a tonal
/// background, all colored from a [StatusStyle]. Combining icon + text + color
/// keeps the state legible without relying on color alone (accessibility).
class StatusChip extends StatelessWidget {
  const StatusChip({required this.label, required this.style, super.key});

  final String label;
  final StatusStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
          // Flexible + ellipsis: a no-op inside an unbounded parent (e.g. a
          // Wrap, where the chip keeps its intrinsic width), but lets the label
          // truncate instead of overflowing when a parent bounds the width.
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                color: style.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
