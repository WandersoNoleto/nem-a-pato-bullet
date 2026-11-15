import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A bold "∞" drawn as a lemniscate, since the display font has no such glyph
/// and the fallback one looks thin and small next to the numbers.
class InfinityGlyph extends StatelessWidget {
  const InfinityGlyph({super.key, required this.color, this.width = 30});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 0.5,
      child: CustomPaint(painter: _InfinityPainter(color)),
    );
  }
}

class _InfinityPainter extends CustomPainter {
  _InfinityPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.height * 0.24;
    final a = (size.width - stroke) / 2;
    final center = size.center(Offset.zero);
    final path = Path();
    const steps = 96;
    for (var i = 0; i <= steps; i++) {
      final t = 2 * math.pi * i / steps;
      final sin = math.sin(t);
      final scale = a / (1 + sin * sin);
      // The lemniscate is flat; stretch it a bit taller to read as "∞".
      final point =
          center + Offset(scale * math.cos(t), scale * sin * math.cos(t) * 1.3);
      i == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      path..close(),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_InfinityPainter old) => old.color != color;
}
