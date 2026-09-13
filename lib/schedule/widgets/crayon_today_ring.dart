import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

/// Draws a single irregular, hand-drawn ellipse that deliberately overshoots
/// where the stroke closes, so it reads as crayon rather than geometry.
///
/// Authored in a 150x52 coordinate space and drawn into whatever box it is
/// given. The stroke width is intentionally NOT scaled with the box — a
/// crayon has one nib width regardless of how big the loop is.
///
/// Verbatim from `design/week-view/crayon_today_ring.dart` — the authored
/// path and its 150x52 space are the design, not a value to retoken.
class CrayonRingPainter extends CustomPainter {
  /// Creates the painter.
  const CrayonRingPainter({required this.color, this.strokeWidth = 2.6});

  /// Stroke colour. Design value: `ScheduleColors.dark.provAccent`-adjacent
  /// (`colors.error`, `#E0483C`) at 95%.
  final Color color;

  /// Nib width in logical pixels. Design value: 2.6.
  final double strokeWidth;

  static const _authored = Size(150, 52);

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / _authored.width;
    final sy = size.height / _authored.height;
    Offset p(double x, double y) => Offset(x * sx, y * sy);

    final path = Path()
      ..moveTo(28 * sx, 7 * sy)
      ..cubicTo(
        p(9, 10).dx,
        p(9, 10).dy,
        p(3, 24).dx,
        p(3, 24).dy,
        p(6, 35).dx,
        p(6, 35).dy,
      )
      ..cubicTo(
        p(9, 46).dx,
        p(9, 46).dy,
        p(34, 50).dx,
        p(34, 50).dy,
        p(70, 49).dx,
        p(70, 49).dy,
      )
      ..cubicTo(
        p(108, 48).dx,
        p(108, 48).dy,
        p(140, 41).dx,
        p(140, 41).dy,
        p(142, 28).dx,
        p(142, 28).dy,
      )
      ..cubicTo(
        p(144, 16).dx,
        p(144, 16).dy,
        p(118, 5).dx,
        p(118, 5).dy,
        p(80, 4).dx,
        p(80, 4).dy,
      )
      ..cubicTo(
        p(56, 3).dx,
        p(56, 3).dy,
        p(34, 5).dx,
        p(34, 5).dy,
        p(22, 11).dx,
        p(22, 11).dy,
      );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = color.withValues(alpha: 0.95),
    );
  }

  @override
  bool shouldRepaint(CrayonRingPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

/// Wraps [child] (the day-column header) in the hand-drawn today ring.
///
/// The ring is drawn in a [AppSizes.crayonRingWidth] x
/// [AppSizes.crayonRingHeight] box, offset by [AppSizes.crayonRingOffsetX] /
/// [AppSizes.crayonRingOffsetY] from the day header, so it overhangs the
/// header on all sides and must not be clipped by an ancestor.
class CrayonTodayRing extends StatelessWidget {
  /// Creates the ring wrapper.
  const CrayonTodayRing({required this.color, required this.child, super.key});

  /// Stroke colour.
  final Color color;

  /// The day-column header this ring is drawn around.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: sizes.crayonRingOffsetX,
          top: sizes.crayonRingOffsetY,
          child: CustomPaint(
            size: Size(sizes.crayonRingWidth, sizes.crayonRingHeight),
            painter: CrayonRingPainter(
              color: color,
              strokeWidth: sizes.crayonRingStroke,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
