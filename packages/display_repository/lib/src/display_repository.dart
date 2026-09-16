import 'dart:async';

/// Controls the kiosk display's wakelock, brightness and reports whether the
/// device is on external power.
///
/// Depend on this interface, never on a concrete implementation. Wire the
/// implementation in `bootstrap.dart` and nowhere else.
abstract interface class DisplayRepository {
  /// Whether the device is attached to external power. Emits the current
  /// value on subscription.
  ///
  /// Never emits an error: a power state that cannot be read is reported as
  /// `false` (not powered) so the app falls back to OS behaviour, and an
  /// error from the underlying platform stream is dropped, leaving the last
  /// reported value standing.
  Stream<bool> get powerChanges;

  /// The OS-configured screen brightness, 0.0–1.0 — what the display shows
  /// when this app is not overriding it.
  ///
  /// Throws a [DisplayException] when the platform call fails.
  Future<double> normalBrightness();

  /// Overrides this application's screen brightness. [level] is clamped to
  /// 0.0–1.0. Throws a [DisplayException] when the platform call fails.
  Future<void> setBrightness(double level);

  /// Drops this application's brightness override, handing the backlight
  /// back to the OS. Throws a [DisplayException] when the platform call
  /// fails.
  Future<void> restoreBrightness();

  /// Keeps the screen on while [enabled]. Throws a [DisplayException] when
  /// the platform call fails.
  Future<void> setWakelock({required bool enabled});

  /// Releases resources and hands the display back to the OS.
  /// Never throws.
  Future<void> dispose();
}
