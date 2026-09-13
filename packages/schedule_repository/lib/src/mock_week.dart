import 'models/event_severity.dart';
import 'models/schedule_event.dart';
import 'models/special_event.dart';
import 'models/week_schedule.dart';
import 'week_math.dart';

/// Builds the design's mock week, seeded on the ISO week containing [today].
///
/// Content is verbatim from `design/week-view/Week View.dc.html`: ten
/// events, a week-spanning special and a single-day special. Not exported
/// from the package barrel — this is implementation detail of
/// [FakeScheduleRepository].
///
/// Every string is literal except the `MS · LÄXA` title, which interpolates
/// the computed week number (the mock's literal `v.38` would be wrong in
/// every other week now that the seed is dynamic).
WeekSchedule mockWeekSchedule({required DateTime today}) {
  final weekStart = startOfIsoWeek(today);
  final weekNumber = isoWeekNumber(weekStart);

  DateTime dayOffset(int days) =>
      DateTime(weekStart.year, weekStart.month, weekStart.day + days);

  DateTime timeOn(DateTime date, int hour, int minute) =>
      DateTime(date.year, date.month, date.day, hour, minute);

  final monday = dayOffset(0);
  final tuesday = dayOffset(1);
  final wednesday = dayOffset(2);
  final thursday = dayOffset(3);
  final friday = dayOffset(4);

  return WeekSchedule(
    weekStart: weekStart,
    weekNumber: weekNumber,
    events: [
      ScheduleEvent(
        id: 'mock-mon-ma-laxa',
        title: 'Läs s. 44–51',
        subjectCode: 'MA',
        date: monday,
        severity: EventSeverity.laxa,
        kindLabel: 'LÄXA',
      ),
      ScheduleEvent(
        id: 'mock-mon-so-inlamning',
        title: 'Källkritik',
        subjectCode: 'SO',
        date: monday,
        severity: EventSeverity.other,
        time: timeOn(monday, 23, 59),
        kindLabel: 'INLÄMNING',
      ),
      ScheduleEvent(
        id: 'mock-tue-sv-laxa',
        title: 'Läs s. 12–30',
        subjectCode: 'SV',
        date: tuesday,
        severity: EventSeverity.laxa,
        kindLabel: 'LÄXA',
      ),
      ScheduleEvent(
        id: 'mock-tue-idh',
        title: 'Ta med simkläder',
        subjectCode: 'IDH',
        date: tuesday,
        severity: EventSeverity.other,
      ),
      ScheduleEvent(
        id: 'mock-wed-sv-laxa',
        title: 'Skriv novell, kap 3',
        subjectCode: 'SV',
        date: wednesday,
        severity: EventSeverity.laxa,
        kindLabel: 'LÄXA',
      ),
      ScheduleEvent(
        id: 'mock-thu-ma-prov',
        title: 'Ekvationer',
        subjectCode: 'MA',
        date: thursday,
        severity: EventSeverity.prov,
        time: timeOn(thursday, 10, 0),
        kindLabel: 'PROV',
      ),
      ScheduleEvent(
        id: 'mock-thu-ms-laxa',
        title: 'Glosor v.$weekNumber',
        subjectCode: 'MS',
        date: thursday,
        severity: EventSeverity.laxa,
        kindLabel: 'LÄXA',
      ),
      ScheduleEvent(
        id: 'mock-thu-so-laxa',
        title: 'Läs kap 4',
        subjectCode: 'SO',
        date: thursday,
        severity: EventSeverity.laxa,
        kindLabel: 'LÄXA',
      ),
      ScheduleEvent(
        id: 'mock-fri-so-redovisning',
        title: 'Redovisning grupparbete',
        subjectCode: 'SO',
        date: friday,
        severity: EventSeverity.other,
        time: timeOn(friday, 13, 15),
      ),
      ScheduleEvent(
        id: 'mock-fri-no-laxa',
        title: 'Repetera kap 2',
        subjectCode: 'NO',
        date: friday,
        severity: EventSeverity.laxa,
        kindLabel: 'LÄXA',
      ),
    ],
    specialEvents: [
      const SpecialEvent.wholeWeek(
        title: 'Temavecka: Hållbarhet',
        colorPreset: SpecialEventColorPreset.teal,
      ),
      SpecialEvent.day(
        title: 'Friluftsdag',
        colorPreset: SpecialEventColorPreset.amber,
        date: wednesday,
      ),
    ],
  );
}
