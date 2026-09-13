/// Border-radius tokens for the application.
///
/// Base unit is 16dp. All values are multiples or fractions of the base.
class AppRadius {
  /// Creates an [AppRadius] instance, optionally overriding individual
  /// tokens.
  const AppRadius({
    this.xsmall = 4,
    this.small = 8,
    this.medium = 16,
    this.large = 24,
    this.xlarge = 32,
    this.step3 = 3,
    this.step12 = 12,
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

  /// 3dp — Week View: special-event banners.
  final double step3;

  /// 12dp — Week View: countdown pill.
  final double step12;
}
