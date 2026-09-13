/// ISO-8601 week arithmetic used to build [WeekSchedule.weekStart] and
/// [WeekSchedule.weekNumber].
///
/// Not exported from the package barrel — this is implementation detail of
/// the mock week and the fake repository, not a public contract.
library;

/// Returns the Monday of [date]'s ISO week, at local midnight.
///
/// Local day arithmetic uses the [DateTime] constructor (which normalizes
/// calendrically) rather than `.add(Duration(...))`, so a Swedish DST
/// transition never shifts the result off midnight.
DateTime startOfIsoWeek(DateTime date) {
  // DateTime.weekday is 1 (Monday) through 7 (Sunday).
  final daysSinceMonday = date.weekday - DateTime.monday;
  return DateTime(date.year, date.month, date.day - daysSinceMonday);
}

/// Returns the ISO-8601 week number (1..53) of [date].
///
/// Computed on [DateTime.utc] values so the day-of-year subtraction below is
/// never perturbed by a local DST transition.
int isoWeekNumber(DateTime date) {
  final utcDate = DateTime.utc(date.year, date.month, date.day);
  // ISO week 1 is the week containing the year's first Thursday, i.e. the
  // week that contains 4 January. Shifting to the Thursday of the same ISO
  // week collapses that into a single day-of-year computation.
  final thursdayOfWeek = utcDate.add(
    Duration(days: DateTime.thursday - utcDate.weekday),
  );
  final firstDayOfYear = DateTime.utc(thursdayOfWeek.year, 1, 1);
  final dayOfYear = thursdayOfWeek.difference(firstDayOfYear).inDays + 1;
  return 1 + ((dayOfYear - 1) ~/ 7);
}
