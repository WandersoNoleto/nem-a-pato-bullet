import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/table_theme.dart';

/// A screen on the themed background: a soft top-to-bottom gradient, with
/// the sunburst only where the game happens.
class TableScaffold extends StatelessWidget {
  const TableScaffold({super.key, required this.child, this.rays = false});

  final Widget child;

  /// Draws the sunburst over the gradient; used by the game screen only.
  final bool rays;

  @override
  Widget build(BuildContext context) {
    final theme = TableTheme.of(context);
    return Scaffold(
      backgroundColor: theme.background.last,
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(painter: _TablePainter(theme, rays: rays)),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _TablePainter extends CustomPainter {
  _TablePainter(this.theme, {required this.rays});

  static const _rayCount = 24;

  /// Where the rays start, as a fraction of the screen: behind the card.
  static const _center = Offset(0.5, 0.45);

  final TableTheme theme;
  final bool rays;

  @override
  void paint(Canvas canvas, Size size) {
    final area = Offset.zero & size;
    canvas.drawRect(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: theme.background,
          stops: const [0, 0.45, 1],
        ).createShader(area),
    );
    if (rays) _paintRays(canvas, size);
  }

  void _paintRays(Canvas canvas, Size size) {
    final center = Offset(size.width * _center.dx, size.height * _center.dy);
    final reach = size.longestSide * 1.5;
    const step = 2 * pi / _rayCount;
    final paint = Paint()..color = theme.rays;
    final path = Path();
    for (var i = 0; i < _rayCount; i++) {
      final start = i * step;
      path
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx + reach * cos(start), center.dy + reach * sin(start))
        ..lineTo(
          center.dx + reach * cos(start + step / 2),
          center.dy + reach * sin(start + step / 2),
        )
        ..close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TablePainter oldDelegate) =>
      oldDelegate.theme != theme || oldDelegate.rays != rays;
}
