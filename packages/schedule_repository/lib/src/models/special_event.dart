import 'package:freezed_annotation/freezed_annotation.dart';

part 'special_event.freezed.dart';

/// Background preset for a [SpecialEvent] banner.
///
/// A closed set: extending it needs a design sign-off (handoff § Known
/// deviations, item 3), not just an addition here.
enum SpecialEventColorPreset {
  /// The teal preset, used for the sample week-spanning banner.
  teal,

  /// The amber preset, used for the sample single-day banner.
  amber,

  /// The purple preset.
  purple,

  /// The green preset.
  green,

  /// The pink preset.
  pink,
}

/// A banner shown above the week grid, outside the day-column event
/// language.
///
/// Either spans the whole week ([SpecialEvent.wholeWeek]) or a single day
/// ([SpecialEvent.day]) — the sealed union rules out the illegal combination
/// of both a date and a week-span flag being set at once. A partial-week
/// span is deliberately absent, deferred pending design.
@freezed
sealed class SpecialEvent with _$SpecialEvent {
  /// A banner spanning the whole week.
  const factory SpecialEvent.wholeWeek({
    required String title,
    required SpecialEventColorPreset colorPreset,
  }) = SpecialEventWholeWeek;

  /// A banner for a single day.
  const factory SpecialEvent.day({
    required String title,
    required SpecialEventColorPreset colorPreset,
    required DateTime date,
  }) = SpecialEventDay;
}
