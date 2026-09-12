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
}
