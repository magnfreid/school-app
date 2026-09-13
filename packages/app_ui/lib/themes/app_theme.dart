import 'package:app_ui/colors/app_colors.dart';
import 'package:app_ui/colors/schedule_colors.dart';
import 'package:app_ui/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// App [ThemeData] factories.
///
/// The `lightTheme` and `darkTheme` getters are the single source of
/// truth for `MaterialApp.theme` / `MaterialApp.darkTheme`. Kept here
/// (not in `lib/`) so visual concerns stay isolated from feature code.
abstract final class AppTheme {
  /// Light theme wired to [AppColors.light] and [AppTypography.textTheme].
  static ThemeData get lightTheme => _base(AppColors.light);

  /// Dark theme wired to [AppColors.dark] and [AppTypography.textTheme].
  static ThemeData get darkTheme => _base(AppColors.dark);

  static ThemeData _base(ColorScheme scheme) {
    final textTheme = scheme.brightness == Brightness.dark
        ? AppTypography.darkTextTheme
        : AppTypography.lightTextTheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      extensions: const [ScheduleColors.dark],
    );
  }
}
