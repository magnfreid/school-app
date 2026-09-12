import 'package:app_ui/radius/app_radius.dart';
import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide easy access to radius tokens.
extension RadiusExtensionX on BuildContext {
  /// Returns an [AppRadius] instance for accessing radius tokens.
  ///
  /// Example: `context.radius.medium`
  AppRadius get radius => const AppRadius();
}
