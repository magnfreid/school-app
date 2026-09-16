import 'package:battery_plus/battery_plus.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// The slice of the platform this package uses.
///
/// Not exported from the barrel: internal to the package, injected so the
/// repository's tests need no device and no plugin registration. Mirrors
/// `CalendarEventsSource` in `schedule_repository`.
abstract interface class DisplayPlatform {
  /// Emits the device's battery/power state as it changes.
  Stream<BatteryState> get batteryStateChanges;

  /// The device's current battery/power state.
  Future<BatteryState> batteryState();

  /// The OS-configured screen brightness, 0.0–1.0.
  Future<double> systemBrightness();

  /// Overrides this application's screen brightness.
  Future<void> setApplicationBrightness(double brightness);

  /// Drops this application's brightness override.
  Future<void> resetApplicationBrightness();

  /// Enables or disables the wakelock.
  Future<void> toggleWakelock({required bool enable});
}

/// [DisplayPlatform] backed by wakelock_plus, screen_brightness and
/// battery_plus. A pass-through: it catches nothing and maps nothing — the
/// same contract as `GoogleCalendarEventsSource`.
class PluginDisplayPlatform implements DisplayPlatform {
  /// Creates a [PluginDisplayPlatform].
  PluginDisplayPlatform();

  @override
  Stream<BatteryState> get batteryStateChanges =>
      Battery().onBatteryStateChanged;

  @override
  Future<BatteryState> batteryState() => Battery().batteryState;

  @override
  Future<double> systemBrightness() => ScreenBrightness.instance.system;

  @override
  Future<void> setApplicationBrightness(double brightness) =>
      ScreenBrightness.instance.setApplicationScreenBrightness(brightness);

  @override
  Future<void> resetApplicationBrightness() =>
      ScreenBrightness.instance.resetApplicationScreenBrightness();

  @override
  Future<void> toggleWakelock({required bool enable}) =>
      WakelockPlus.toggle(enable: enable);
}
