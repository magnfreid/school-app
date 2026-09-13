import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_config.freezed.dart';

/// Which calendar the schedule is read from.
///
/// Credentials belong to the secure-storage chunk, not here — this carries
/// only the identifier.
@freezed
abstract class CalendarConfig with _$CalendarConfig {
  /// Creates a [CalendarConfig].
  const factory CalendarConfig({required String calendarId}) = _CalendarConfig;
}
