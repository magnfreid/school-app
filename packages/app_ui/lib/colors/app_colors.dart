import 'package:flutter/material.dart';

/// App color tokens and derived [ColorScheme]s.
///
/// Built around a single [seed] color and Material 3's
/// [ColorScheme.fromSeed] so light and dark palettes stay harmonized.
/// Override [seed] to re-skin the app without touching widget code.
abstract final class AppColors {
  /// Seed color driving both light and dark [ColorScheme]s.
  static const Color seed = Color(0xFF2563EB);

  /// Light-mode color scheme derived from [seed].
  static final ColorScheme light = ColorScheme.fromSeed(seedColor: seed);

  /// Dark-mode color scheme derived from [seed].
  ///
  /// Roles used by the Week View kiosk screen are pinned to its palette via
  /// [ColorScheme.copyWith] — see `docs`/the Week View handoff for the exact
  /// mapping. Every other role stays seed-derived so screens that haven't
  /// adopted that palette yet still get a working [ColorScheme.primary].
  static final ColorScheme dark =
      ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ).copyWith(
        surface: const Color(0xFF0E0F12),
        onSurface: const Color(0xFFE4E1E9),
        surfaceContainer: const Color(0xFF191A1F),
        surfaceContainerHigh: const Color(0xFF1C1D22),
        onSurfaceVariant: const Color(0xFF8E8E98),
        outline: const Color(0xFF4A4B54),
        outlineVariant: const Color(0xFF33343B),
        error: const Color(0xFFE0483C),
        errorContainer: const Color(0xFF26181A),
        onErrorContainer: const Color(0xFFFFE2DE),
      );
}
