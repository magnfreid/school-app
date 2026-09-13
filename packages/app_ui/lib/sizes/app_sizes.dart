/// Component size tokens that are neither spacing nor radius.
class AppSizes {
  /// Creates an [AppSizes] instance, optionally overriding individual tokens.
  const AppSizes({
    this.inlineProgressIndicator = 20,
    this.inlineProgressStroke = 2,
    this.appBarHeight = 56,
    this.heroHeight = 138,
    this.heroEyebrowHeight = 24,
    this.heroAccentWidth = 4,
    this.weekBannerHeight = 38,
    this.dayBannerHeight = 32,
    this.dayHeaderHeight = 52,
    this.cardAccentWidth = 4,
    this.iconButtonSize = 44,
    this.iconGlyphSize = 21,
    this.navArrowWidth = 48,
    this.navArrowHeight = 44,
    this.navArrowGlyphWidth = 31,
    this.navArrowGlyphHeight = 22,
    this.syncDotSize = 7,
    this.crayonRingWidth = 126,
    this.crayonRingHeight = 56,
    this.crayonRingOffsetX = -6,
    this.crayonRingOffsetY = -2,
    this.crayonRingStroke = 2.6,
    this.hairline = 1,
  });

  /// Diameter of a progress indicator rendered inside a control.
  final double inlineProgressIndicator;

  /// Stroke width of a progress indicator rendered inside a control.
  final double inlineProgressStroke;

  /// Week View: height of band 1, the app bar.
  final double appBarHeight;

  /// Week View: height of band 2, the next-event hero.
  final double heroHeight;

  /// Week View: fixed height of the hero's eyebrow row.
  final double heroEyebrowHeight;

  /// Week View: width of the hero's left accent edge.
  final double heroAccentWidth;

  /// Week View: height of the special lane's week-spanning row.
  final double weekBannerHeight;

  /// Week View: height of the special lane's single-day row.
  final double dayBannerHeight;

  /// Week View: height of a day column's header.
  final double dayHeaderHeight;

  /// Week View: width of an event card's left accent edge.
  final double cardAccentWidth;

  /// Week View: diameter of the app bar's icon buttons.
  final double iconButtonSize;

  /// Week View: size of the glyph inside an app-bar icon button.
  final double iconGlyphSize;

  /// Week View: width of a week-nav arrow's tap target.
  final double navArrowWidth;

  /// Week View: height of a week-nav arrow's tap target.
  final double navArrowHeight;

  /// Week View: width of a week-nav arrow's painted glyph.
  final double navArrowGlyphWidth;

  /// Week View: height of a week-nav arrow's painted glyph.
  final double navArrowGlyphHeight;

  /// Week View: diameter of the sync-status dot.
  final double syncDotSize;

  /// Week View: width of the crayon today-ring's paint box.
  final double crayonRingWidth;

  /// Week View: height of the crayon today-ring's paint box.
  final double crayonRingHeight;

  /// Week View: horizontal offset of the crayon today-ring from its header.
  final double crayonRingOffsetX;

  /// Week View: vertical offset of the crayon today-ring from its header.
  final double crayonRingOffsetY;

  /// Week View: stroke width of the crayon today-ring.
  final double crayonRingStroke;

  /// Week View: width of a 1dp hairline divider or border.
  final double hairline;
}
