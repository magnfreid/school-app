import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide easy access to the current [ColorScheme].
extension ColorsExtensionX on BuildContext {
  /// Shorthand for `Theme.of(context).colorScheme`.
  ColorScheme get colors => Theme.of(this).colorScheme;
}
