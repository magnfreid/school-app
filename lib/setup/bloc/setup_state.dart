import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setup_state.freezed.dart';

/// Why a field was rejected. Mapped to copy in the view.
enum SetupFieldError {
  /// The field was submitted empty.
  empty,

  /// The service-account key field did not contain valid JSON.
  malformedJson,
}

/// State of the setup screen.
///
/// Every variant declares both value fields so `state.calendarId` /
/// `state.serviceAccountKey` resolve on the sealed base — the same trick
/// `ScheduleState.weekOffset` uses.
///
/// The service-account key is carried as [ServiceAccountKey], never a bare
/// `String` — Freezed's generated `toString()` prints every field verbatim,
/// and `_AppBlocObserver.onChange` logs it under `kDebugMode`. Wrapping in
/// [ServiceAccountKey] makes that redaction mechanical instead of a standing
/// rule.
@freezed
sealed class SetupState with _$SetupState {
  /// The form is being edited, with either field possibly carrying an error
  /// from the last submit attempt.
  const factory SetupState.editing({
    @Default('') String calendarId,
    @Default(ServiceAccountKey('')) ServiceAccountKey serviceAccountKey,
    SetupFieldError? calendarIdError,
    SetupFieldError? serviceAccountKeyError,
  }) = SetupEditing;

  /// A validated submission is being saved.
  const factory SetupState.submitting({
    required String calendarId,
    required ServiceAccountKey serviceAccountKey,
  }) = SetupSubmitting;

  /// The save failed.
  const factory SetupState.failure({
    required String calendarId,
    required ServiceAccountKey serviceAccountKey,
  }) = SetupFailure;

  /// The save succeeded.
  const factory SetupState.saved({
    required String calendarId,
    required ServiceAccountKey serviceAccountKey,
  }) = SetupSaved;
}
