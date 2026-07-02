import 'package:flutter/material.dart';

/// Which of the two pairs on a court this tile represents, used to give each a
/// distinct accent color. The color is always paired with the "Dupla N" text
/// label, so the two are never told apart by color alone.
enum PairAccent { one, two }

/// Shows one pair on a court card: a "Dupla N" badge and the two player names.
class PairTile extends StatelessWidget {
  const PairTile({
    required this.label,
    required this.playerNames,
    this.accent = PairAccent.one,
    super.key,
  });

  final String label;
  final String playerNames;
  final PairAccent accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (Color bg, Color fg) = switch (accent) {
      PairAccent.one => (scheme.primaryContainer, scheme.onPrimaryContainer),
      PairAccent.two => (scheme.tertiaryContainer, scheme.onTertiaryContainer),
    };
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(color: fg, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            playerNames,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
