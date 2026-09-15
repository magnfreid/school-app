import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';

/// Extended FAB that returns the Week View to the anchor week.
///
/// Rendered only while `state.weekOffset != 0` — see [ScheduleView].
class ReturnToTodayFab extends StatelessWidget {
  /// Creates a [ReturnToTodayFab].
  const ReturnToTodayFab({required this.onPressed, super.key});

  /// Invoked when the FAB is tapped.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // `ScheduleView` wraps only the `Scaffold`'s `body` in
    // `MediaQuery.withNoTextScaling`; the `floatingActionButton` slot sits
    // outside it, so this kiosk screen's no-text-scaling rule has to be
    // re-applied here.
    return MediaQuery.withNoTextScaling(
      child: FloatingActionButton.extended(
        key: const Key('scheduleReturnToTodayFab'),
        onPressed: onPressed,
        icon: const Icon(Icons.keyboard_return),
        label: Text(context.l10n.scheduleReturnToTodayLabel),
        backgroundColor: context.colors.surfaceContainerHigh,
        foregroundColor: context.scheduleColors.onSurfaceStrong,
        extendedTextStyle: context.scheduleText.fabLabel,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radius.medium),
        ),
      ),
    );
  }
}
