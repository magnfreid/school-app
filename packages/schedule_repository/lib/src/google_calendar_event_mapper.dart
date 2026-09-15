import 'package:googleapis/calendar/v3.dart';

import 'models/event_severity.dart';
import 'models/schedule_event.dart';
import 'models/special_event.dart';
import 'models/week_schedule.dart';
import 'week_math.dart';

// Extended-property key names, private so a typo here fails a test rather
// than silently matching nothing.
const _kindKey = 'kind';
const _subjectCodeKey = 'subjectCode';
const _severityKey = 'severity';
const _kindLabelKey = 'kindLabel';
const _colorPresetKey = 'colorPreset';
const _spanKey = 'span';

/// Maps Calendar [events] onto the window of [weekCount] weeks that starts
/// at [windowStart] (a Monday, local midnight).
///
/// Returns exactly [weekCount] `WeekSchedule`s, ascending, consecutive
/// Mondays from [windowStart], with empty lists where there is no content.
/// An event with no recognized `kind` extended property — including one that
/// never had the property at all — is skipped, not surfaced as a malformed
/// card.
List<WeekSchedule> mapCalendarEventsToWindow({
  required List<Event> events,
  required DateTime windowStart,
  required int weekCount,
}) {
  final scheduleEvents = List<List<ScheduleEvent>>.generate(
    weekCount,
    (_) => <ScheduleEvent>[],
  );
  final specialEvents = List<List<SpecialEvent>>.generate(
    weekCount,
    (_) => <SpecialEvent>[],
  );

  for (final event in events) {
    if (event.status == 'cancelled') continue;

    final id = event.id;
    if (id == null || id.isEmpty) continue;

    final start = event.start;
    if (start == null || (start.date == null && start.dateTime == null)) {
      continue;
    }

    final private = event.extendedProperties?.private;
    final kind = private?[_kindKey]?.trim().toLowerCase();
    if (kind != 'schedule' && kind != 'special') continue;

    final DateTime date;
    final DateTime? time;
    final startDate = start.date;
    if (startDate != null) {
      date = DateTime(startDate.year, startDate.month, startDate.day);
      time = null;
    } else {
      final local = start.dateTime!.toLocal();
      date = DateTime(local.year, local.month, local.day);
      time = local;
    }

    final weekIndex = _weekIndex(
      weekStart: startOfIsoWeek(date),
      windowStart: windowStart,
    );
    if (weekIndex < 0 || weekIndex >= weekCount) continue;

    if (kind == 'schedule') {
      scheduleEvents[weekIndex].add(
        _mapScheduleEvent(event: event, id: id, date: date, time: time),
      );
    } else {
      specialEvents[weekIndex].add(
        _mapSpecialEvent(event: event, private: private, date: date),
      );
    }
  }

  return [
    for (var i = 0; i < weekCount; i++)
      _weekAt(windowStart, i, scheduleEvents[i], specialEvents[i]),
  ];
}

WeekSchedule _weekAt(
  DateTime windowStart,
  int index,
  List<ScheduleEvent> events,
  List<SpecialEvent> specialEvents,
) {
  final weekStart = DateTime(
    windowStart.year,
    windowStart.month,
    windowStart.day + index * 7,
  );
  return WeekSchedule(
    weekStart: weekStart,
    weekNumber: isoWeekNumber(weekStart),
    events: events,
    specialEvents: specialEvents,
  );
}

/// Whole weeks between [windowStart] and [weekStart], computed on
/// calendar-date UTC instants so a DST transition crossed by the window
/// never perturbs the result — the same trick [isoWeekNumber] uses.
int _weekIndex({required DateTime weekStart, required DateTime windowStart}) {
  final utcWeekStart = DateTime.utc(
    weekStart.year,
    weekStart.month,
    weekStart.day,
  );
  final utcWindowStart = DateTime.utc(
    windowStart.year,
    windowStart.month,
    windowStart.day,
  );
  return utcWeekStart.difference(utcWindowStart).inDays ~/ 7;
}

ScheduleEvent _mapScheduleEvent({
  required Event event,
  required String id,
  required DateTime date,
  required DateTime? time,
}) {
  final private = event.extendedProperties?.private;
  final severityValue = private?[_severityKey]?.trim().toLowerCase();
  final severity = switch (severityValue) {
    'prov' => EventSeverity.prov,
    'laxa' => EventSeverity.laxa,
    _ => EventSeverity.other,
  };
  final kindLabelValue = private?[_kindLabelKey]?.trim();
  final kindLabel = (kindLabelValue == null || kindLabelValue.isEmpty)
      ? null
      : kindLabelValue;

  return ScheduleEvent(
    id: id,
    title: event.summary ?? '',
    subjectCode: private?[_subjectCodeKey] ?? '',
    date: date,
    severity: severity,
    time: time,
    kindLabel: kindLabel,
  );
}

SpecialEvent _mapSpecialEvent({
  required Event event,
  required Map<String, String>? private,
  required DateTime date,
}) {
  final colorPresetValue = private?[_colorPresetKey]?.trim().toLowerCase();
  final colorPreset = switch (colorPresetValue) {
    'teal' => SpecialEventColorPreset.teal,
    'amber' => SpecialEventColorPreset.amber,
    'purple' => SpecialEventColorPreset.purple,
    'green' => SpecialEventColorPreset.green,
    'pink' => SpecialEventColorPreset.pink,
    _ => SpecialEventColorPreset.teal,
  };
  final spanValue = private?[_spanKey]?.trim().toLowerCase();
  final title = event.summary ?? '';

  return spanValue == 'week'
      ? SpecialEvent.wholeWeek(title: title, colorPreset: colorPreset)
      : SpecialEvent.day(title: title, colorPreset: colorPreset, date: date);
}
