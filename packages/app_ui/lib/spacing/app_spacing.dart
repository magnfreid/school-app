/// Spacing tokens for the application.
///
/// Base unit is 16dp. All values are multiples or fractions of the base.
class AppSpacing {
  /// Creates an [AppSpacing] instance, optionally overriding individual
  /// tokens.
  const AppSpacing({
    this.xsmall = 4,
    this.small = 8,
    this.medium = 16,
    this.large = 24,
    this.xlarge = 32,
    this.step5 = 5,
    this.step6 = 6,
    this.step7 = 7,
    this.step9 = 9,
    this.step10 = 10,
    this.step12 = 12,
    this.step13 = 13,
    this.step14 = 14,
    this.step18 = 18,
    this.step20 = 20,
    this.step22 = 22,
  });

  /// 4dp — one quarter of the base.
  final double xsmall;

  /// 8dp — half the base.
  final double small;

  /// 16dp — the base unit.
  final double medium;

  /// 24dp — one and a half times the base.
  final double large;

  /// 32dp — double the base.
  final double xlarge;

  /// 5dp — Week View: label→title gap inside cards and day headers.
  final double step5;

  /// 6dp — Week View: special-lane row gap, icon-button gaps.
  final double step6;

  /// 7dp — Week View: event card gap within a column, sync row gap.
  final double step7;

  /// 9dp — Week View: grid column gap, card vertical pad, hero subject top.
  final double step9;

  /// 10dp — Week View: countdown pill horizontal pad.
  final double step10;

  /// 12dp — Week View: special-lane top margin, card horizontal pad,
  /// eyebrow gap.
  final double step12;

  /// 13dp — Week View: week-banner inner gap.
  final double step13;

  /// 14dp — Week View: app-bar item gap, grid top margin, icon-group left
  /// margin.
  final double step14;

  /// 18dp — Week View: side margins, week-banner horizontal pad.
  final double step18;

  /// 20dp — Week View: app-bar horizontal pad.
  final double step20;

  /// 22dp — Week View: hero row gap, hero left pad.
  final double step22;
}
