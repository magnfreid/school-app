import 'package:app_ui/spacing/app_spacing.dart';
import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide easy access to spacing tokens.
extension SpacingExtensionX on BuildContext {
  /// Returns an [AppSpacing] instance for accessing spacing tokens.
  ///
  /// Example: `context.spacing.medium`
  AppSpacing get spacing => const AppSpacing();
}
