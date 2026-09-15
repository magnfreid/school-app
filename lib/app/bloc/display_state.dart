import 'package:freezed_annotation/freezed_annotation.dart';

part 'display_state.freezed.dart';

/// Which idle dim level applies.
enum DisplayDimLevel {
  /// The daytime dim level (06:00–21:00, device-local).
  daytime,

  /// The night dim level (21:00–06:00, device-local).
  night,
}

/// State of the kiosk display.
@freezed
sealed class DisplayState with _$DisplayState {
  /// The OS owns the screen: no wakelock, no brightness override.
  const factory DisplayState.released() = DisplayReleased;

  /// Charging and recently touched: screen held on at normal brightness.
  const factory DisplayState.awake() = DisplayAwake;

  /// Charging and idle: screen held on, backlight reduced.
  const factory DisplayState.dimmed(DisplayDimLevel level) = DisplayDimmed;
}
