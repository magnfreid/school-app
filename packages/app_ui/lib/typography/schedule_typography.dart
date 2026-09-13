import 'package:flutter/material.dart';

/// Named text roles for the Week View screen.
///
/// Sizes are chosen for across-the-room legibility and don't map onto the
/// M3 phone type scale, so they live here as their own named roles rather
/// than bending [TextTheme]. Mirrors the [AppSpacing]/`context.spacing`
/// idiom: a plain token bag, not a [ThemeExtension] — construct with
/// `const ScheduleTypography()` via `context.scheduleText`.
///
/// None of these carry a colour or a `fontFamily`: colour is applied at the
/// call site with `.copyWith(color: ...)`, and the family comes from the
/// merged `DefaultTextStyle`.
class ScheduleTypography {
  /// Creates a [ScheduleTypography] instance, optionally overriding
  /// individual roles.
  const ScheduleTypography({
    this.heroTitle = const TextStyle(
      fontSize: 44,
      fontWeight: FontWeight.w400,
      height: 1.1,
    ),
    this.heroDate = const TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w400,
      height: 1,
    ),
    this.heroSubject = const TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w300,
    ),
    this.heroDateSub = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w300,
    ),
    this.heroEyebrow = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 2.6,
    ),
    this.countdownPill = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
    ),
    this.weekLabel = const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
    this.weekRange = const TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
    this.syncLabel = const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
    this.bannerLabelWeek = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 2.2,
    ),
    this.bannerTitleWeek = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
    this.bannerLabelDay = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.8,
    ),
    this.bannerTitleDay = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    this.dayName = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2,
    ),
    this.dayDate = const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
    this.eventLabel = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.6,
    ),
    this.eventTitle = const TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w400,
      height: 1.25,
    ),
  });

  /// Next-event hero title. 44 / w400 / h1.1.
  final TextStyle heroTitle;

  /// Next-event hero date. 40 / w400 / h1.0.
  final TextStyle heroDate;

  /// Next-event hero subject code. 21 / w300.
  final TextStyle heroSubject;

  /// Next-event hero date/time sub-line. 20 / w300.
  final TextStyle heroDateSub;

  /// Next-event hero eyebrow (`NEXT · {kind}`). 12 / w500 / ls2.6.
  final TextStyle heroEyebrow;

  /// Countdown pill text. 13 / w400.
  final TextStyle countdownPill;

  /// App-bar week-number label. 21 / w500.
  final TextStyle weekLabel;

  /// App-bar week date-range label. 17 / w300.
  final TextStyle weekRange;

  /// App-bar sync-status label. 15 / w300.
  final TextStyle syncLabel;

  /// Week-spanning special-event banner label. 11 / w500 / ls2.2.
  final TextStyle bannerLabelWeek;

  /// Week-spanning special-event banner title. 18 / w400.
  final TextStyle bannerTitleWeek;

  /// Single-day special-event banner label. 10 / w500 / ls1.8.
  final TextStyle bannerLabelDay;

  /// Single-day special-event banner title. 16 / w400.
  final TextStyle bannerTitleDay;

  /// Day-column header day name. 16 / w500 / ls1.2.
  final TextStyle dayName;

  /// Day-column header date. 14 / w300.
  final TextStyle dayDate;

  /// Event card label (`SUBJECT · KIND · TIME`). 11 / w500 / ls1.6.
  final TextStyle eventLabel;

  /// Event card title. 19 / w400 / h1.25.
  final TextStyle eventTitle;
}
