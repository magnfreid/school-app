import 'package:flutter/material.dart';

/// An [IconButton] that cycles through system / light / dark themes.
///
/// Stateless and BLoC-free — pass the current [mode], a localized [tooltip],
/// and an [onPressed] callback to connect it to whatever state management the
/// app uses.
class ThemeSwitcherWidget extends StatelessWidget {
  /// Creates a [ThemeSwitcherWidget].
  const ThemeSwitcherWidget({
    super.key,
    required this.mode,
    required this.onPressed,
    this.tooltip,
  });

  /// The currently active theme mode, used to derive the icon.
  final ThemeMode mode;

  /// Tooltip shown on long-press. Pass a localized string from the caller.
  final String? tooltip;

  /// Called when the button is tapped.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(_iconFor(mode)),
    );
  }

  IconData _iconFor(ThemeMode mode) => switch (mode) {
    .system => Icons.brightness_auto_outlined,
    .light => Icons.light_mode_outlined,
    .dark => Icons.dark_mode_outlined,
  };
}
