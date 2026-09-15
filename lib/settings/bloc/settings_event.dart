import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_event.freezed.dart';

/// Events [SettingsBloc] can react to.
@freezed
sealed class SettingsEvent with _$SettingsEvent {
  /// The user confirmed the unsubscribe dialog.
  const factory SettingsEvent.unsubscribeConfirmed() =
      SettingsUnsubscribeConfirmed;
}
