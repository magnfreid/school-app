import 'package:freezed_annotation/freezed_annotation.dart';

import 'schedule_event.dart';
import 'special_event.dart';

part 'week_schedule.freezed.dart';

/// One school week: Monday through Friday plus any special-event banners.
///
/// [weekStart] is the Monday of the week, local midnight. [weekNumber] is
/// the ISO-8601 week number of [weekStart]. [events] is flat, not grouped by
/// day — each event carries its own [ScheduleEvent.date].
@freezed
abstract class WeekSchedule with _$WeekSchedule {
  /// Creates a [WeekSchedule].
  const factory WeekSchedule({
    required DateTime weekStart,
    required int weekNumber,
    @Default(<ScheduleEvent>[]) List<ScheduleEvent> events,
    @Default(<SpecialEvent>[]) List<SpecialEvent> specialEvents,
  }) = _WeekSchedule;
}
