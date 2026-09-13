import 'package:freezed_annotation/freezed_annotation.dart';

import 'event_severity.dart';

part 'schedule_event.freezed.dart';

/// A single calendar event on the week grid.
///
/// [date] is the day the event belongs to, local midnight. [time] is the
/// event's local start instant; when non-null it falls on the same calendar
/// day as [date] — `null` means a day-only event. [kindLabel] is the raw
/// display word from the calendar (`LÄXA`, `INLÄMNING`), or `null` for a
/// plain event.
@freezed
abstract class ScheduleEvent with _$ScheduleEvent {
  /// Creates a [ScheduleEvent].
  const factory ScheduleEvent({
    required String id,
    required String title,
    required String subjectCode,
    required DateTime date,
    required EventSeverity severity,
    DateTime? time,
    String? kindLabel,
  }) = _ScheduleEvent;
}
