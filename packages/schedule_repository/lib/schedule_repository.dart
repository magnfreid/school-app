/// Schedule repository package.
///
/// Exposes the [ScheduleRepository] interface, the domain types that cross
/// its boundary, and [FakeScheduleRepository] for tests and for `fvm flutter
/// run` without credentials. There is no in-memory placeholder here — the
/// real implementation is a later chunk.
library;

export 'src/models/event_severity.dart';
export 'src/models/schedule_event.dart';
export 'src/models/special_event.dart';
export 'src/models/week_schedule.dart';
export 'src/fake_schedule_repository.dart';
export 'src/google_calendar_schedule_repository.dart';
export 'src/schedule_exception.dart';
export 'src/schedule_repository.dart';
