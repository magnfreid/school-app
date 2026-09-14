import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_event.freezed.dart';

/// Events [ScheduleBloc] can react to.
///
/// Named `ScheduleBlocEvent`, not `ScheduleEvent` — `ScheduleEvent` is
/// already the calendar-item model exported by `schedule_repository`.
@freezed
sealed class ScheduleBlocEvent with _$ScheduleBlocEvent {
  /// Requests the initial load, for the anchor week.
  const factory ScheduleBlocEvent.started() = ScheduleStarted;

  /// Requests the week at [offset] weeks from the anchor week.
  ///
  /// [offset] is absolute: weeks from the anchor week (0 = the anchor week),
  /// clamped to ±`ScheduleRepository.windowRadiusInWeeks`.
  const factory ScheduleBlocEvent.weekChanged(int offset) = ScheduleWeekChanged;

  /// Requests a re-fetch of the currently displayed week.
  const factory ScheduleBlocEvent.refreshRequested() = ScheduleRefreshRequested;

  /// Requests a return to the anchor week after the idle timeout elapsed.
  const factory ScheduleBlocEvent.idleTimeoutElapsed() =
      ScheduleIdleTimeoutElapsed;

  /// Signals that the anchor week has rolled over and the display must
  /// return to it.
  const factory ScheduleBlocEvent.anchorChanged() = ScheduleAnchorChanged;
}
