import 'package:freezed_annotation/freezed_annotation.dart';

import 'week_schedule.dart';

part 'schedule_window.freezed.dart';

/// The window of weeks [ScheduleRepository.fetchWindow] returns, plus when
/// the backend was last successfully reconciled.
///
/// [lastSyncedAt] documents as: when the repository last successfully talked
/// to the backend — not when this call returned. A cache hit carries the
/// older timestamp forward unchanged.
@freezed
abstract class ScheduleWindow with _$ScheduleWindow {
  /// Creates a [ScheduleWindow].
  const factory ScheduleWindow({
    required List<WeekSchedule> weeks,
    required DateTime lastSyncedAt,
  }) = _ScheduleWindow;
}
