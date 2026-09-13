import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';

/// Previous/next week navigation targets.
///
/// Custom-painted filled arrow glyphs, not Material icons — their weight and
/// proportions are wrong for this size at the design's fidelity. No
/// `InkWell`, no background, no ripple container.
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
      children: [
        _NavArrow(
          direction: _ArrowDirection.left,
          tooltip: l10n.scheduleNavPreviousWeekTooltip,
          onTap: onPrevious,
        ),
        _NavArrow(
          direction: _ArrowDirection.right,
          tooltip: l10n.scheduleNavNextWeekTooltip,
          onTap: onNext,
        ),
      ],
    );
  }
}

enum _ArrowDirection { left, right }

class _NavArrow extends StatelessWidget {
  const _NavArrow({
    required this.direction,
    required this.tooltip,
    required this.onTap,
  });

  final _ArrowDirection direction;
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
            child: CustomPaint(
              size: Size(sizes.navArrowGlyphWidth, sizes.navArrowGlyphHeight),
              painter: _NavArrowPainter(
                direction: direction,
                color: context.scheduleColors.onSurfaceStrong,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints a filled arrow glyph authored in a 28x20 box, scaled into whatever
/// [Size] it is given.
///
/// Vertices per the handoff, closed, in order. Right: (1,7.5) (15,7.5)
/// (15,3) (26,10) (15,17) (15,12.5) (1,12.5). Left mirrors it horizontally.
class _NavArrowPainter extends CustomPainter {
  const _NavArrowPainter({required this.direction, required this.color});

  final _ArrowDirection direction;
  final Color color;

  static const _authoredWidth = 28.0;
  static const _authoredHeight = 20.0;

  static const _rightPoints = [
    Offset(1, 7.5),
    Offset(15, 7.5),
    Offset(15, 3),
    Offset(26, 10),
    Offset(15, 17),
    Offset(15, 12.5),
    Offset(1, 12.5),
  ];

  static const _leftPoints = [
    Offset(27, 7.5),
    Offset(13, 7.5),
    Offset(13, 3),
    Offset(2, 10),
    Offset(13, 17),
    Offset(13, 12.5),
    Offset(27, 12.5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / _authoredWidth;
    final sy = size.height / _authoredHeight;
    final points = direction == _ArrowDirection.right
        ? _rightPoints
        : _leftPoints;

    final path = Path()..moveTo(points.first.dx * sx, points.first.dy * sy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx * sx, point.dy * sy);
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _NavArrowPainter oldDelegate) =>
      oldDelegate.direction != direction || oldDelegate.color != color;
}
