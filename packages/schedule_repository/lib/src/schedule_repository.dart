import 'models/week_schedule.dart';
import 'schedule_exception.dart';

/// Provides the school schedule around a given week.
///
/// Depend on this interface, never on a concrete implementation. Wire the
/// implementation in `bootstrap.dart` and nowhere else. Pull-based rather
/// than stream-based: the schedule bloc owns refresh concurrency via
/// `droppable()` on its own `refreshRequested` event, so a stream here would
/// duplicate that machinery.
abstract interface class ScheduleRepository {
  /// Weeks either side of the anchor week that a window covers.
  static const int windowRadiusInWeeks = 2;

  /// Returns the window of weeks around [anchor].
  ///
  /// Returns exactly `2 * windowRadiusInWeeks + 1` weeks, ascending by
  /// [WeekSchedule.weekStart], consecutive, with the anchor's own week at
  /// index [windowRadiusInWeeks]. A week with no content is still present,
  /// with empty lists — the caller never has to handle a hole. The anchor's
  /// time-of-day is ignored.
  ///
  /// Throws a [ScheduleException] when the window cannot be read.
  Future<List<WeekSchedule>> fetchWindow({required DateTime anchor});

  /// Releases resources held by the implementation.
  ///
  /// Exists so the Google Calendar implementation has one place to close its
  /// HTTP client, mirroring `AuthRepository.dispose`.
  Future<void> dispose();
}
