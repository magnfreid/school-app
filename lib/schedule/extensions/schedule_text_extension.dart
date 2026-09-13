import 'package:intl/intl.dart';
import 'package:school_app/l10n/app_localizations.dart';
import 'package:schedule_repository/schedule_repository.dart';

/// Separator used between the pieces of a formatted schedule string.
const _separator = ' · ';

/// Every formatted (date, time, kind) string the Week View screen needs,
/// built on the resolved [AppLocalizations] so the locale always matches
/// `this.localeName`.
extension ScheduleTextX on AppLocalizations {
  /// Short, upper-cased weekday name, e.g. `MÅN`, `TORS`.
  String dayNameShort(DateTime d) =>
      DateFormat.E(localeName).format(d).toUpperCase();

  /// Full weekday name with its first character upper-cased, e.g. `Torsdag`.
  String dayNameLong(DateTime d) {
    final name = DateFormat.EEEE(localeName).format(d);
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  /// Day and abbreviated month, e.g. `14 sep.`.
  ///
  /// The Swedish CLDR pattern includes the trailing period — keep it, do not
  /// strip it.
  String dayAndMonth(DateTime d) => DateFormat.MMMd(localeName).format(d);

  /// Hour and minute, e.g. `10:00`.
  String timeOfDay(DateTime t) => DateFormat.Hm(localeName).format(t);

  /// Formats the date range for a displayed week.
  ///
  /// Uses [scheduleWeekRange] when [start] and [end] fall in the same month,
  /// [scheduleWeekRangeCrossMonth] otherwise.
  String weekRange(DateTime start, DateTime end) {
    final startDay = DateFormat.d(localeName).format(start);
    if (start.year == end.year && start.month == end.month) {
      return scheduleWeekRange(
        startDay,
        DateFormat.d(localeName).format(end),
        DateFormat.MMMM(localeName).format(start),
      );
    }
    return scheduleWeekRangeCrossMonth(
      startDay,
      DateFormat.MMMM(localeName).format(start),
      DateFormat.d(localeName).format(end),
      DateFormat.MMMM(localeName).format(end),
    );
  }

  /// The event's severity/kind word, or `null` for a plain event with no
  /// [ScheduleEvent.kindLabel].
  ///
  /// Matching the raw Swedish `INLÄMNING` is data mapping, not copy — it is
  /// what the calendar writes, and it is the only way an `en` device gets an
  /// English word for it.
  String? kindWord(ScheduleEvent e) {
    switch (e.severity) {
      case EventSeverity.prov:
        return scheduleSeverityProv;
      case EventSeverity.laxa:
        return scheduleSeverityLaxa;
      case EventSeverity.other:
        final label = e.kindLabel;
        if (label == null) return null;
        if (label.trim().toUpperCase() == 'INLÄMNING') {
          return scheduleSeverityInlamning;
        }
        return label.toUpperCase();
    }
  }

  /// Event card label: `SUBJECT · KIND · TIME`, with `· KIND` omitted for
  /// plain events and `· TIME` omitted for day-only ones.
  String eventCardLabel(ScheduleEvent e) {
    final kind = kindWord(e);
    final time = e.time;
    final formattedTime = time == null ? null : timeOfDay(time);
    return [e.subjectCode, ?kind, ?formattedTime].join(_separator);
  }

  /// Eyebrow text above the next-event hero title.
  String heroEyebrow(ScheduleEvent e) {
    final kind = kindWord(e);
    return kind == null
        ? scheduleNextEventEyebrowPlain
        : scheduleNextEventEyebrow(kind);
  }

  /// Date/time sub-line under the hero's relative-day word.
  ///
  /// The time segment is omitted for day-only events.
  String heroDateLine(ScheduleEvent e) {
    final date = dayAndMonth(e.date);
    final time = e.time;
    return time == null ? date : '$date$_separator${timeOfDay(time)}';
  }
}
