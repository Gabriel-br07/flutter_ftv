import 'package:flutter/material.dart';
import 'package:flutter_ftv/core/layout/app_breakpoints.dart';

/// Lays out a small set of action buttons that sit side-by-side on roomy
/// screens but stack vertically (full width) on narrow ones, so labels never
/// overflow or get clipped on small phones.
///
/// Pass the buttons **unwrapped** — this widget adds the [Expanded] in the
/// horizontal layout and stretches them in the vertical one.
class ResponsiveButtonRow extends StatelessWidget {
  const ResponsiveButtonRow({
    required this.children,
    this.spacing = 12,
    this.breakpoint = AppBreakpoints.compact,
    super.key,
  });

  /// The buttons to lay out, in order.
  final List<Widget> children;

  /// Gap between buttons (horizontal gap when in a row, vertical when stacked).
  final double spacing;

  /// Below this available width the buttons stack vertically.
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: spacing),
                children[i],
              ],
            ],
          );
        }
        return Row(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) SizedBox(width: spacing),
              Expanded(child: children[i]),
            ],
          ],
        );
      },
    );
  }
}
