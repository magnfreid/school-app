import 'package:flutter/material.dart';

/// Typography tokens used across the app.
///
/// Wraps Material 3's 2021 type scale so [TextTheme] can be swapped or
/// extended in one place (e.g. to plug in a custom font family).
abstract final class AppTypography {
  /// Light-mode text theme (dark ink on light surface).
  static final TextTheme lightTextTheme = Typography.material2021().black;

  /// Dark-mode text theme (light ink on dark surface).
  static final TextTheme darkTextTheme = Typography.material2021().white;
}
