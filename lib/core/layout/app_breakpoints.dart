/// Width breakpoints (in logical pixels) for adapting layout to screen size.
///
/// Kept intentionally small: [compact] is the threshold below which secondary
/// elements (status chips, paired action buttons) should stack instead of
/// sitting side-by-side; [medium] separates phones from tablets/landscape.
class AppBreakpoints {
  const AppBreakpoints._();

  /// Below this width, prefer vertical/stacked layouts over horizontal ones.
  static const double compact = 340;

  /// At/above this width, the viewport is tablet- or landscape-sized.
  static const double medium = 600;
}
