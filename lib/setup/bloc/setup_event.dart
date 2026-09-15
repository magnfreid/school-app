import 'package:freezed_annotation/freezed_annotation.dart';

part 'setup_event.freezed.dart';

/// Events [SetupBloc] can react to.
@freezed
sealed class SetupEvent with _$SetupEvent {
  /// The user edited the calendar ID field.
  const factory SetupEvent.calendarIdChanged(String value) =
      SetupCalendarIdChanged;

  /// The user edited the service-account key field.
  const factory SetupEvent.serviceAccountKeyChanged(String value) =
      SetupServiceAccountKeyChanged;

  /// The user tapped save.
  const factory SetupEvent.submitted() = SetupSubmitted;
}
