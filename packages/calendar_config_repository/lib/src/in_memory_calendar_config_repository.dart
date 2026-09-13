import 'dart:async';

import 'calendar_config_exception.dart';
import 'calendar_config_repository.dart';
import 'models/calendar_config.dart';

/// [CalendarConfigRepository] backed by nothing but a stream held in memory.
///
/// The starter's default so a fresh clone boots straight to the schedule
/// without going through configuration first — the role
/// `InMemoryAuthRepository` plays today. Replace it in `bootstrap.dart` with
/// a real implementation — the app layer depends on [CalendarConfigRepository]
/// and does not change.
class InMemoryCalendarConfigRepository implements CalendarConfigRepository {
  /// Creates an [InMemoryCalendarConfigRepository], already configured with a
  /// placeholder calendar id.
  InMemoryCalendarConfigRepository();

  final _controller = StreamController<CalendarConfig?>.broadcast();
  CalendarConfig? _current = const CalendarConfig(
    calendarId: 'in-memory-calendar',
  );

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

  @override
  Future<void> save(CalendarConfig config) async {
    // Stand-in for storage latency so loading states are visible while
    // developing against this implementation.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (config.calendarId.isEmpty) {
      throw const CalendarConfigException('A calendar id is required.');
    }

    _current = config;
    // The delay above means dispose() can land mid-flight; adding to a closed
    // controller throws.
    if (!_controller.isClosed) _controller.add(_current);
  }

  @override
  Future<void> clear() async {
    _current = null;
    if (!_controller.isClosed) _controller.add(null);
  }

  @override
  Future<void> dispose() => _controller.close();
}
