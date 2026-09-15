import 'package:freezed_annotation/freezed_annotation.dart';

import 'service_account_key.dart';

part 'calendar_config.freezed.dart';

/// Which calendar the schedule is read from, and the credential used to read
/// it.
///
/// The credential travels as [ServiceAccountKey], not a bare `String` — its
/// `toString()` is redacted, so this class's own Freezed-generated
/// `toString()` never prints it verbatim.
@freezed
abstract class CalendarConfig with _$CalendarConfig {
  /// Creates a [CalendarConfig].
  const factory CalendarConfig({
    required String calendarId,
    required ServiceAccountKey serviceAccountKey,
  }) = _CalendarConfig;
}
