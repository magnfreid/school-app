import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';

/// Previous/next week navigation targets.
///
/// Material `arrow_back`/`arrow_forward` glyphs — a deliberate departure
/// from the handoff's custom-painted geometry. No `InkWell`, no background,
/// no ripple container.
class WeekNavArrows extends StatelessWidget {
  /// Creates [WeekNavArrows].
  const WeekNavArrows({
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  /// Invoked when the previous-week arrow is tapped.
  final VoidCallback onPrevious;

  /// Invoked when the next-week arrow is tapped.
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      spacing: context.spacing.step6,
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavArrow(
          icon: Icons.arrow_back,
          tooltip: l10n.scheduleNavPreviousWeekTooltip,
          onTap: onPrevious,
        ),
        _NavArrow(
          icon: Icons.arrow_forward,
          tooltip: l10n.scheduleNavNextWeekTooltip,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _NavArrow extends StatelessWidget {
  const _NavArrow({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: sizes.navArrowWidth,
          height: sizes.navArrowHeight,
          child: Center(
            child: Icon(
              icon,
              size: sizes.iconGlyphSize,
              color: context.scheduleColors.onSurfaceStrong,
            ),
          ),
        ),
      ),
    );
  }
}
