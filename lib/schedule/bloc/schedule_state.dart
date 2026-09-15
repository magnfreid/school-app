import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'schedule_state.freezed.dart';

/// Where a date sits relative to "now", for hero/day-header word choice.
enum RelativeDay {
  /// The date is today.
  today,

  /// The date is tomorrow.
  tomorrow,

  /// The date is neither today nor tomorrow.
  later,
}

/// How fresh the last successful sync is, for the app bar's sync dot.
enum ScheduleSyncHealth {
  /// The last successful sync is within the warning threshold.
  healthy,

  /// The last successful sync is older than the warning threshold.
  warning,
}

/// The next upcoming event in the displayed week, plus its relative timing.
@freezed
abstract class NextEvent with _$NextEvent {
  /// Creates a [NextEvent].
  const factory NextEvent({
    required ScheduleEvent event,
    required int daysUntil,
    required RelativeDay relativeDay,
  }) = _NextEvent;
}

/// One day column's worth of content.
@freezed
abstract class ScheduleDay with _$ScheduleDay {
  /// Creates a [ScheduleDay].
  const factory ScheduleDay({
    required DateTime date,
    required bool isToday,
    @Default(<ScheduleEvent>[]) List<ScheduleEvent> events,
    SpecialEventDay? special,
  }) = _ScheduleDay;
}

/// State of the schedule screen.
@freezed
sealed class ScheduleState with _$ScheduleState {
  /// Before the first load has started.
  const factory ScheduleState.initial({@Default(0) int weekOffset}) =
      ScheduleInitial;

  /// A week is being fetched.
  const factory ScheduleState.loading({@Default(0) int weekOffset}) =
      ScheduleLoading;

  /// A week loaded successfully.
  const factory ScheduleState.loaded({
    required int weekOffset,
    required WeekSchedule week,
    required DateTime lastSyncedAt,
    required ScheduleSyncHealth syncHealth,
    required List<ScheduleDay> days,
    NextEvent? nextEvent,
    SpecialEventWholeWeek? weekSpecial,
  }) = ScheduleLoaded;

  /// A week failed to load.
  const factory ScheduleState.failure({@Default(0) int weekOffset}) =
      ScheduleFailure;
}
