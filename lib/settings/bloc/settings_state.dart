import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

/// State of the settings screen.
///
/// No variant carries data — nothing on this screen is worth carrying, and
/// nothing stored may be echoed into a state whose generated `toString()`
/// `_AppBlocObserver.onChange` logs under `kDebugMode`.
@freezed
sealed class SettingsState with _$SettingsState {
  /// Nothing in flight.
  const factory SettingsState.idle() = SettingsIdle;

  /// A confirmed unsubscribe is clearing the stored configuration.
  const factory SettingsState.unsubscribing() = SettingsUnsubscribing;

  /// The clear failed; the configuration is still stored.
  const factory SettingsState.failure() = SettingsFailure;

  /// The clear succeeded. The config gate, not this screen, navigates.
  const factory SettingsState.unsubscribed() = SettingsUnsubscribed;
}
