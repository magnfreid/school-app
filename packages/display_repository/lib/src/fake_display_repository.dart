import 'dart:async';

import 'display_exception.dart';
import 'display_repository.dart';

/// Scriptable [DisplayRepository] for tests and for UI work that should not
/// touch a device's platform channels.
///
/// Unlike [DeviceDisplayRepository] this adds no latency by default and
/// defaults to not externally powered, so the "OS in charge" branch is the
/// zero-argument case. No latency and no validation of its own — the fake is
/// scripted, not opinionated.
class FakeDisplayRepository implements DisplayRepository {
  /// Creates a [FakeDisplayRepository].
  ///
  /// [initialExternallyPowered] seeds [powerChanges]; leave it `false` — the
  /// zero-argument case is "OS in charge", the branch in which this fake
  /// creates no timers and does nothing, mirroring
  /// `FakeCalendarConfigRepository` defaulting to unconfigured.
  FakeDisplayRepository({
    bool initialExternallyPowered = false,
    this.normalBrightnessValue = 1.0,
    this.normalBrightnessError,
    this.setBrightnessError,
    this.restoreBrightnessError,
    this.setWakelockError,
  }) : _current = initialExternallyPowered;

  /// Every call made on this fake, in order, one entry per call:
  /// `'normal'`, `'restore'`, `'wakelock:true'`, `'wakelock:false'`,
  /// `'brightness:0.60'` (`toStringAsFixed(2)`). Recorded *before* the
  /// scripted error is thrown, so a test can assert what was attempted.
  final List<String> calls = [];

  /// Values passed to [setBrightness], in order.
  final List<double> brightnessCalls = [];

  /// Values passed to [setWakelock], in order.
  final List<bool> wakelockCalls = [];

  /// Number of [restoreBrightness] calls.
  int restoreCount = 0;

  /// What [normalBrightness] returns. Mutable so a test can change it
  /// mid-run.
  double normalBrightnessValue;

  /// Error [normalBrightness] throws when set. Mutable so a test can change
  /// it mid-run.
  DisplayException? normalBrightnessError;

  /// Error [setBrightness] throws when set. Mutable so a test can change it
  /// mid-run.
  DisplayException? setBrightnessError;

  /// Error [restoreBrightness] throws when set. Mutable so a test can change
  /// it mid-run.
  DisplayException? restoreBrightnessError;

  /// Error [setWakelock] throws when set. Mutable so a test can change it
  /// mid-run.
  DisplayException? setWakelockError;

  final _controller = StreamController<bool>.broadcast();
  bool _current;

  @override
  Stream<bool> get powerChanges => Stream.multi((controller) {
    controller.add(_current);
    final subscription = _controller.stream.listen(
      controller.add,
      onError: controller.addError,
      onDone: controller.close,
    );
    controller
      ..onPause = subscription.pause
      ..onResume = subscription.resume
      ..onCancel = subscription.cancel;
  });

  /// Pushes a new power state onto [powerChanges].
  void emitPower({required bool isExternallyPowered}) {
    _current = isExternallyPowered;
    // A subscriber can outlive a test's tearDown that disposed this fake;
    // adding to a closed controller throws.
    if (!_controller.isClosed) _controller.add(isExternallyPowered);
  }

  @override
  Future<double> normalBrightness() async {
    calls.add('normal');
    final error = normalBrightnessError;
    if (error != null) throw error;
    return normalBrightnessValue;
  }

  @override
  Future<void> setBrightness(double level) async {
    calls.add('brightness:${level.toStringAsFixed(2)}');
    brightnessCalls.add(level);
    final error = setBrightnessError;
    if (error != null) throw error;
  }

  @override
  Future<void> restoreBrightness() async {
    calls.add('restore');
    restoreCount++;
    final error = restoreBrightnessError;
    if (error != null) throw error;
  }

  @override
  Future<void> setWakelock({required bool enabled}) async {
    calls.add('wakelock:$enabled');
    wakelockCalls.add(enabled);
    final error = setWakelockError;
    if (error != null) throw error;
  }

  @override
  Future<void> dispose() => _controller.close();
}
