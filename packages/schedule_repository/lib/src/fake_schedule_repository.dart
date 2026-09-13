import 'models/week_schedule.dart';
import 'mock_week.dart';
import 'schedule_exception.dart';
import 'schedule_repository.dart';
import 'week_math.dart';

/// Scriptable [ScheduleRepository] for tests and for `fvm flutter run`
/// without credentials.
///
/// Holds content for exactly one week — [week] — and returns it for whichever
/// entry of the window matches its [WeekSchedule.weekStart]; every other
/// entry in the window comes back empty.
class FakeScheduleRepository implements ScheduleRepository {
  /// Creates a [FakeScheduleRepository].
  ///
  /// [week] seeds the one week this fake holds content for; when omitted, it
  /// defaults to the mock week containing [today] (or [DateTime.now] when
  /// [today] is also omitted). On a Saturday or Sunday, the seeded week is
  /// the just-ended Mon–Fri week — [today] is the escape hatch for tests that
  /// need a fixed day.
  ///
  /// When [fetchError] is set, [fetchWindow] throws it instead of
  /// succeeding. [fetchDelay] holds each [fetchWindow] call open, which is
  /// what lets a test observe behaviour that only exists while a request is
  /// in flight.
  FakeScheduleRepository({
    DateTime? today,
    WeekSchedule? week,
    this.fetchError,
    this.fetchDelay = Duration.zero,
  }) : week = week ?? mockWeekSchedule(today: today ?? DateTime.now());

  /// The one week this fake holds content for.
  final WeekSchedule week;

  /// How long each [fetchWindow] call takes before resolving.
  final Duration fetchDelay;

  /// Error [fetchWindow] throws when set. Mutable so a test can change it
  /// mid-run.
  ScheduleException? fetchError;

  /// Anchors passed to each [fetchWindow] call, in order.
  final List<DateTime> fetchCalls = [];

  @override
  Future<List<WeekSchedule>> fetchWindow({required DateTime anchor}) async {
    fetchCalls.add(anchor);
    if (fetchDelay > Duration.zero) await Future<void>.delayed(fetchDelay);
    final error = fetchError;
    if (error != null) throw error;

    final anchorWeekStart = startOfIsoWeek(anchor);
    const radius = ScheduleRepository.windowRadiusInWeeks;
    return [
      for (var offset = -radius; offset <= radius; offset++)
        _weekAt(
          DateTime(
            anchorWeekStart.year,
            anchorWeekStart.month,
            anchorWeekStart.day + offset * 7,
          ),
        ),
    ];
  }

  WeekSchedule _weekAt(DateTime weekStart) {
    if (weekStart == week.weekStart) return week;
    return WeekSchedule(
      weekStart: weekStart,
      weekNumber: isoWeekNumber(weekStart),
    );
  }

  @override
  Future<void> dispose() async {}
}
