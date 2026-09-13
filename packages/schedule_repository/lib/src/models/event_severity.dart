/// How urgently a [ScheduleEvent] should read on the week grid.
///
/// This is a cross-repo contract with the Cowork task that writes the
/// calendar events: these three values only. Adding a value here needs that
/// task to change in step.
enum EventSeverity {
  /// A graded test — the one severity with its own accent colour.
  prov,

  /// Homework — visually identical to [other], told apart only by its
  /// [ScheduleEvent.kindLabel].
  laxa,

  /// Everything else: plain events, submissions, and any other kind label.
  other,
}
