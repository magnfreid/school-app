import 'package:app_ui/sizes/app_sizes.dart';
import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide easy access to size tokens.
extension SizesExtensionX on BuildContext {
  /// Returns an [AppSizes] instance for accessing size tokens.
  ///
  /// Example: `context.sizes.inlineProgressIndicator`
  AppSizes get sizes => const AppSizes();
}
