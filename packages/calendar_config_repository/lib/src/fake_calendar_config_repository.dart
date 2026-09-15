import 'dart:async';

import 'calendar_config_exception.dart';
import 'calendar_config_repository.dart';
import 'models/calendar_config.dart';

/// Scriptable [CalendarConfigRepository] for tests and for UI work that
/// should not touch a backend.
///
/// Unlike [InMemoryCalendarConfigRepository] this adds no latency by default
/// and defaults to unconfigured, so the unconfigured branch is the
/// zero-argument case. No latency and no validation of its own — the fake is
/// scripted, not opinionated.
class FakeCalendarConfigRepository implements CalendarConfigRepository {
  /// Creates a [FakeCalendarConfigRepository].
  ///
  /// [initialConfig] seeds the current configuration; leave it `null` for
  /// unconfigured. When [saveError] is set, [save] throws it instead of
  /// succeeding. [saveDelay] holds each [save] call open, which is what lets
  /// a test observe behaviour that only exists while a request is in flight.
  /// [clearError] and [clearDelay] do the same for [clear].
  FakeCalendarConfigRepository({
    CalendarConfig? initialConfig,
    this.saveError,
    this.saveDelay = Duration.zero,
    this.clearError,
    this.clearDelay = Duration.zero,
  }) : _current = initialConfig;

  /// How long each [save] call takes before resolving.
  final Duration saveDelay;

  /// Error [save] throws when set. Mutable so a test can change it mid-run.
  CalendarConfigException? saveError;

  /// How long each [clear] call takes before resolving.
  final Duration clearDelay;

  /// Error [clear] throws when set. Mutable so a test can change it mid-run.
  CalendarConfigException? clearError;

  /// Configurations passed to each [save] call, in order.
  final List<CalendarConfig> saveCalls = [];

  /// Number of times [clear] has been called.
  int clearCount = 0;

  final _controller = StreamController<CalendarConfig?>.broadcast();
  CalendarConfig? _current;

  @override
  Stream<CalendarConfig?> get configChanges => Stream.multi((controller) {
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

  /// Pushes [config] onto the stream, simulating an out-of-band change.
  void emit(CalendarConfig? config) {
    _current = config;
    // A save held open by saveDelay can resolve after a test's tearDown has
    // disposed this fake; adding to a closed controller throws.
    if (!_controller.isClosed) _controller.add(config);
  }

  @override
  Future<void> save(CalendarConfig config) async {
    saveCalls.add(config);
    if (saveDelay > Duration.zero) await Future<void>.delayed(saveDelay);
    final error = saveError;
    if (error != null) throw error;
    emit(config);
  }

  @override
  Future<void> clear() async {
    clearCount++;
    if (clearDelay > Duration.zero) await Future<void>.delayed(clearDelay);
    final error = clearError;
    if (error != null) throw error;
    emit(null);
  }

  @override
  Future<void> dispose() => _controller.close();
}
