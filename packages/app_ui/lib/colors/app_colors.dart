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
  static final ColorScheme dark = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  );
}
