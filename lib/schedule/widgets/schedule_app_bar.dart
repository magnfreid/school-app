import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_app/app/router/routes.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/schedule/widgets/week_nav_arrows.dart';

/// Band 1: week label, nav arrows, sync status, and the two icon buttons.
///
/// Not in the handoff's `lib/schedule/` file list — the handoff folds this
/// into `schedule_view.dart`'s prose, but it is broken out as its own widget
/// here to match the rest of the screen's one-band-per-file shape.
class ScheduleAppBar extends StatelessWidget {
  /// Creates a [ScheduleAppBar].
  const ScheduleAppBar({
    required this.weekLabel,
    required this.weekRange,
    required this.syncLabel,
    required this.syncHealthy,
    required this.onPreviousWeek,
    required this.onNextWeek,
    super.key,
  });

  /// Week-number label, `''` in non-loaded states.
  final String weekLabel;

  /// Week date-range label, `''` in non-loaded states.
  final String weekRange;

  /// Sync-status text.
  final String syncLabel;

  /// Whether the sync dot should render in its healthy colour.
  final bool syncHealthy;

  /// Invoked when the previous-week arrow is tapped.
  final VoidCallback onPreviousWeek;

  /// Invoked when the next-week arrow is tapped.
  final VoidCallback onNextWeek;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scheduleColors = context.scheduleColors;
    final scheduleText = context.scheduleText;
    final spacing = context.spacing;
    final sizes = context.sizes;
    final l10n = context.l10n;

    return SizedBox(
      height: sizes.appBarHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.step20),
        child: Row(
          spacing: spacing.step14,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              weekLabel,
              style: scheduleText.weekLabel.copyWith(color: colors.onSurface),
            ),
            Text(
              weekRange,
              style: scheduleText.weekRange.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: spacing.small),
              child: WeekNavArrows(
                onPrevious: onPreviousWeek,
                onNext: onNextWeek,
              ),
            ),
            const Spacer(),
            Row(
              spacing: spacing.step7,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: sizes.syncDotSize,
                  height: sizes.syncDotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: syncHealthy
                        ? scheduleColors.syncOk
                        : colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  syncLabel,
                  style: scheduleText.syncLabel.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: spacing.step14),
              child: Row(
                spacing: spacing.step6,
                children: [
                  _IconCircle(
                    icon: Icons.grid_view_outlined,
                    tooltip: l10n.scheduleAlternateViewTooltip,
                    onTap: null,
                  ),
                  _IconCircle(
                    icon: Icons.settings_outlined,
                    tooltip: l10n.scheduleSettingsTooltip,
                    // push, not go, so the stub settings page's auto back
                    // button works.
                    onTap: () => context.push(AppRoutes.settings.path),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One of the two round icon buttons in the app bar's right group.
///
/// A `GestureDetector`, not an `IconButton` — `IconButton` greys a
/// null-callback icon, and the placeholder alternate-view button must render
/// at full opacity while doing nothing.
class _IconCircle extends StatelessWidget {
  const _IconCircle({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sizes = context.sizes;

    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: sizes.iconButtonSize,
          height: sizes.iconButtonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surfaceContainerHigh,
          ),
          child: Icon(
            icon,
            size: sizes.iconGlyphSize,
            color: colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
