import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';

import 'display_exception.dart';
import 'display_platform.dart';
import 'display_repository.dart';

/// [DisplayRepository] backed by the device's real wakelock, brightness and
/// battery platform channels.
class DeviceDisplayRepository implements DisplayRepository {
  /// Creates a [DeviceDisplayRepository].
  ///
  /// [platform] defaults to a real [PluginDisplayPlatform]; override it in
  /// tests.
  DeviceDisplayRepository({DisplayPlatform? platform})
    : _platform = platform ?? PluginDisplayPlatform();

  final DisplayPlatform _platform;

  @override
  Stream<bool> get powerChanges => _powerChanges().distinct();

  Stream<bool> _powerChanges() async* {
    bool initial;
    try {
      initial = _isExternallyPowered(await _platform.batteryState());
    } catch (_) {
      initial = false;
    }
    yield initial;
    yield* _platform.batteryStateChanges
        .map(_isExternallyPowered)
        .handleError((Object _) {});
  }

  /// `unknown` is deliberately `false`: a device that cannot report power
  /// falls back to OS behaviour, which is visible and reportable, rather
  /// than silently holding a wakelock on battery.
  bool _isExternallyPowered(BatteryState state) => switch (state) {
    BatteryState.charging => true,
    BatteryState.full => true,
    BatteryState.connectedNotCharging => true,
    BatteryState.discharging => false,
    BatteryState.unknown => false,
  };

  @override
  Future<double> normalBrightness() => _guard(_platform.systemBrightness);

  @override
  Future<void> setBrightness(double level) =>
      _guard(() => _platform.setApplicationBrightness(level.clamp(0.0, 1.0)));

  @override
  Future<void> restoreBrightness() =>
      _guard(_platform.resetApplicationBrightness);

  @override
  Future<void> setWakelock({required bool enabled}) =>
      _guard(() => _platform.toggleWakelock(enable: enabled));

  /// Shared failure mapping for every method that talks to the platform.
  ///
  /// The clause order is load-bearing and the messages are deliberately
  /// distinct so a reordering fails a test. `MissingPluginException` is
  /// **not** a subtype of `PlatformException`, so the first two clauses are
  /// independent; the catch-all must stay last (reversing any pair is either
  /// `dead_code_on_catch_subtype` or a silent downgrade of the message).
  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on MissingPluginException catch (error) {
      throw DisplayException(
        'Display control is not available on this device.',
        cause: error,
      );
    } on PlatformException catch (error) {
      throw DisplayException(
        'The device rejected a display command.',
        cause: error,
      );
    } catch (error) {
      throw DisplayException('Could not control the display.', cause: error);
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await _platform.resetApplicationBrightness();
    } catch (_) {
      // dispose() must never throw — this hands the display back when
      // bootstrap.dart's RepositoryProvider disposes.
    }
    try {
      await _platform.toggleWakelock(enable: false);
    } catch (_) {
      // Same as above.
    }
  }
}
