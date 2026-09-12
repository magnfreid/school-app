import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide easy access to the current [ThemeData].
extension ThemeExtensionX on BuildContext {
  /// Shorthand for `Theme.of(context)`.
  ThemeData get theme => Theme.of(this);
}
