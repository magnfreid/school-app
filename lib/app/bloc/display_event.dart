import 'package:freezed_annotation/freezed_annotation.dart';

part 'display_event.freezed.dart';

/// Events [DisplayBloc] can react to.
///
/// No transformer on any of these — they are independent, and the default
/// (concurrent) is correct per CLAUDE.md.
@freezed
sealed class DisplayEvent with _$DisplayEvent {
  /// Subscribe to power and start the dim-level check timer.
  const factory DisplayEvent.started() = DisplayStarted;

  /// External power was attached or detached.
  const factory DisplayEvent.powerChanged({required bool isExternallyPowered}) =
      DisplayPowerChanged;

  /// A pointer went down anywhere in the app.
  const factory DisplayEvent.userInteracted() = DisplayUserInteracted;

  /// No interaction for [DisplayBloc.idleTimeout].
  const factory DisplayEvent.idleTimeoutElapsed() = DisplayIdleTimeoutElapsed;

  /// Periodic tick that re-derives the dim level so an idle display crosses
  /// the 21:00 / 06:00 boundary without a touch.
  const factory DisplayEvent.dimLevelChecked() = DisplayDimLevelChecked;

  /// The app entered or left the foreground.
  const factory DisplayEvent.foregroundChanged({required bool isForeground}) =
      DisplayForegroundChanged;
}
