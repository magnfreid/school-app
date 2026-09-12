import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide easy access to the current [TextTheme].
extension TextExtensionX on BuildContext {
  /// Shorthand for `Theme.of(context).textTheme`.
  TextTheme get text => Theme.of(this).textTheme;
}
