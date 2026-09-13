import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_event.freezed.dart';

/// Events [ScheduleBloc] can react to.
///
/// Named `ScheduleBlocEvent`, not `ScheduleEvent` — `ScheduleEvent` is
/// already the calendar-item model exported by `schedule_repository`.
@freezed
sealed class ScheduleBlocEvent with _$ScheduleBlocEvent {
  /// Requests the initial load, for the week containing "now".
  const factory ScheduleBlocEvent.started() = ScheduleStarted;

  /// Requests the week at [offset] weeks from the week containing "now".
  ///
  /// [offset] is absolute: weeks from the week containing "now" (0 = this
  /// week).
  const factory ScheduleBlocEvent.weekChanged(int offset) = ScheduleWeekChanged;

  /// Requests a re-fetch of the currently displayed week.
  const factory ScheduleBlocEvent.refreshRequested() = ScheduleRefreshRequested;
}
