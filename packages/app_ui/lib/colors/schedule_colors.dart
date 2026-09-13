import 'package:flutter/material.dart';

/// One special-event banner's colour triple.
///
/// A plain value type, not a [ThemeExtension] — presets are looked up and
/// handed to a widget as a value, never read from `Theme.of(context)`
/// directly.
@immutable
class SpecialBannerColors {
  /// Creates a [SpecialBannerColors].
  const SpecialBannerColors({
    required this.background,
    required this.label,
    required this.title,
  });

  /// Banner fill colour.
  final Color background;

  /// Colour of the small eyebrow label (`ALL WEEK` / `ALL DAY`).
  final Color label;

  /// Colour of the banner's title text.
  final Color title;

  /// Linearly interpolates between [a] and [b].
  static SpecialBannerColors lerp(
    SpecialBannerColors a,
    SpecialBannerColors b,
    double t,
  ) {
    return SpecialBannerColors(
      background: Color.lerp(a.background, b.background, t)!,
      label: Color.lerp(a.label, b.label, t)!,
      title: Color.lerp(a.title, b.title, t)!,
    );
  }
}

/// Colour tokens for the Week View screen that have no Material role.
///
/// Registered on both [ThemeData.extensions] in `app_theme.dart` so
/// `Theme.of(context).extension<ScheduleColors>()` is never null — see
/// `context.scheduleColors`.
class ScheduleColors extends ThemeExtension<ScheduleColors> {
  /// Creates a [ScheduleColors].
  const ScheduleColors({
    required this.onSurfaceStrong,
    required this.onSurfaceMedium,
    required this.dayName,
    required this.provLabel,
    required this.syncOk,
    required this.bannerTeal,
    required this.bannerAmber,
    required this.bannerPurple,
    required this.bannerGreen,
    required this.bannerPink,
  });

  /// The Week View's dark-kiosk palette. Registered on both app themes.
  static const ScheduleColors dark = ScheduleColors(
    onSurfaceStrong: Color(0xFFFFFFFF),
    onSurfaceMedium: Color(0xFFA8A8B2),
    dayName: Color(0xFFC9C6CF),
    provLabel: Color(0xFFFF8A80),
    syncOk: Color(0xFF5C9C72),
    bannerTeal: SpecialBannerColors(
      background: Color(0xFF12514A),
      label: Color(0xFF7FD9C4),
      title: Color(0xFFD9F5EE),
    ),
    bannerAmber: SpecialBannerColors(
      background: Color(0xFF5A3D0C),
      label: Color(0xFFF5C46B),
      title: Color(0xFFFFE9C2),
    ),
    bannerPurple: SpecialBannerColors(
      background: Color(0xFF3A2A5C),
      label: Color(0xFFC4AEEF),
      title: Color(0xFFEDE4FF),
    ),
    bannerGreen: SpecialBannerColors(
      background: Color(0xFF1E4A2B),
      label: Color(0xFF8FD9A0),
      title: Color(0xFFDFF5E4),
    ),
    bannerPink: SpecialBannerColors(
      background: Color(0xFF5A2242),
      label: Color(0xFFF0A8C8),
      title: Color(0xFFFFE0EE),
    ),
  );

  /// Hero title, hero date, today's day name, nav-arrow glyphs.
  final Color onSurfaceStrong;

  /// Hero subject, hero date line, countdown pill text, today's date.
  final Color onSurfaceMedium;

  /// Non-today day names.
  final Color dayName;

  /// `prov` labels and the hero eyebrow.
  final Color provLabel;

  /// Sync dot, healthy.
  final Color syncOk;

  /// Teal special-event banner preset.
  final SpecialBannerColors bannerTeal;

  /// Amber special-event banner preset.
  final SpecialBannerColors bannerAmber;

  /// Purple special-event banner preset.
  final SpecialBannerColors bannerPurple;

  /// Green special-event banner preset.
  final SpecialBannerColors bannerGreen;

  /// Pink special-event banner preset.
  final SpecialBannerColors bannerPink;

  @override
  ScheduleColors copyWith({
    Color? onSurfaceStrong,
    Color? onSurfaceMedium,
    Color? dayName,
    Color? provLabel,
    Color? syncOk,
    SpecialBannerColors? bannerTeal,
    SpecialBannerColors? bannerAmber,
    SpecialBannerColors? bannerPurple,
    SpecialBannerColors? bannerGreen,
    SpecialBannerColors? bannerPink,
  }) {
    return ScheduleColors(
      onSurfaceStrong: onSurfaceStrong ?? this.onSurfaceStrong,
      onSurfaceMedium: onSurfaceMedium ?? this.onSurfaceMedium,
      dayName: dayName ?? this.dayName,
      provLabel: provLabel ?? this.provLabel,
      syncOk: syncOk ?? this.syncOk,
      bannerTeal: bannerTeal ?? this.bannerTeal,
      bannerAmber: bannerAmber ?? this.bannerAmber,
      bannerPurple: bannerPurple ?? this.bannerPurple,
      bannerGreen: bannerGreen ?? this.bannerGreen,
      bannerPink: bannerPink ?? this.bannerPink,
    );
  }

  @override
  ScheduleColors lerp(ThemeExtension<ScheduleColors>? other, double t) {
    if (other is! ScheduleColors) return this;
    return ScheduleColors(
      onSurfaceStrong: Color.lerp(onSurfaceStrong, other.onSurfaceStrong, t)!,
      onSurfaceMedium: Color.lerp(onSurfaceMedium, other.onSurfaceMedium, t)!,
      dayName: Color.lerp(dayName, other.dayName, t)!,
      provLabel: Color.lerp(provLabel, other.provLabel, t)!,
      syncOk: Color.lerp(syncOk, other.syncOk, t)!,
      bannerTeal: SpecialBannerColors.lerp(bannerTeal, other.bannerTeal, t),
      bannerAmber: SpecialBannerColors.lerp(bannerAmber, other.bannerAmber, t),
      bannerPurple: SpecialBannerColors.lerp(
        bannerPurple,
        other.bannerPurple,
        t,
      ),
      bannerGreen: SpecialBannerColors.lerp(bannerGreen, other.bannerGreen, t),
      bannerPink: SpecialBannerColors.lerp(bannerPink, other.bannerPink, t),
    );
  }
}
