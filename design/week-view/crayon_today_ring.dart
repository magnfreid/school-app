// Reference implementation of the hand-drawn "today" ring.
//
// This is the one piece of the design that has no Flutter equivalent, so the
// exact geometry is given here. Move it to
// `lib/schedule/widgets/crayon_today_ring.dart` and take the colour from
// `context.colors` / the ScheduleColors theme extension rather than a literal.

import 'package:flutter/widgets.dart';

/// Draws a single irregular, hand-drawn ellipse that deliberately overshoots
/// where the stroke closes, so it reads as crayon rather than geometry.
///
/// Authored in a 150x52 coordinate space and drawn into whatever box it is
/// given. The stroke width is intentionally NOT scaled with the box — a
/// crayon has one nib width regardless of how big the loop is.
class CrayonRingPainter extends CustomPainter {
  /// Creates the painter.
  const CrayonRingPainter({required this.color, this.strokeWidth = 2.6});

  /// Stroke colour. Design value: ScheduleColors.todayRing (#E0483C) at 95%.
  final Color color;

  /// Nib width in logical pixels. Design value: 2.6.
  final double strokeWidth;

  static const Size _authored = Size(150, 52);

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / _authored.width;
    final sy = size.height / _authored.height;
    Offset p(double x, double y) => Offset(x * sx, y * sy);

    final path = Path()
      ..moveTo(28 * sx, 7 * sy)
      ..cubicTo(p(9, 10).dx, p(9, 10).dy, p(3, 24).dx, p(3, 24).dy,
          p(6, 35).dx, p(6, 35).dy)
      ..cubicTo(p(9, 46).dx, p(9, 46).dy, p(34, 50).dx, p(34, 50).dy,
          p(70, 49).dx, p(70, 49).dy)
      ..cubicTo(p(108, 48).dx, p(108, 48).dy, p(140, 41).dx, p(140, 41).dy,
          p(142, 28).dx, p(142, 28).dy)
      ..cubicTo(p(144, 16).dx, p(144, 16).dy, p(118, 5).dx, p(118, 5).dy,
          p(80, 4).dx, p(80, 4).dy)
      ..cubicTo(p(56, 3).dx, p(56, 3).dy, p(34, 5).dx, p(34, 5).dy,
          p(22, 11).dx, p(22, 11).dy);

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

/// Wraps [child] (the day-column header) in the ring.
///
/// The ring is drawn in a 126x56 box offset (-6, -2) from the 52dp-tall
/// header, so it overhangs the header on all sides and is not clipped.
/// Keep the header's `clipBehavior` at none / avoid wrapping in anything
/// that clips.
class CrayonTodayRing extends StatelessWidget {
  /// Creates the ring wrapper.
  const CrayonTodayRing({required this.color, required this.child, super.key});

  /// Stroke colour.
  final Color color;

  /// The day-column header this ring is drawn around.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -6,
          top: -2,
          child: CustomPaint(
            size: const Size(126, 56),
            painter: CrayonRingPainter(color: color),
          ),
        ),
        child,
      ],
    );
  }
}
