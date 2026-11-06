import 'package:flutter/material.dart';

import '../theme/table_theme.dart';

/// A screen on the themed "table" background.
class TableScaffold extends StatelessWidget {
  const TableScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = TableTheme.of(context);
    return Scaffold(
      backgroundColor: theme.background.last,
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(painter: _TablePainter(theme)),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _TablePainter extends CustomPainter {
  _TablePainter(this.theme);

  final TableTheme theme;

  @override
  void paint(Canvas canvas, Size size) {
    final area = Offset.zero & size;
    canvas
      ..drawRect(
        area,
        Paint()
          ..shader = LinearGradient(
            begin: const Alignment(-0.17, -1),
            end: const Alignment(0.17, 1),
            colors: theme.background,
            stops: const [0, 0.48, 1],
          ).createShader(area),
      )
      ..drawOval(
        Rect.fromLTWH(
          -size.width * 0.2,
          size.height * 0.74,
          size.width * 1.4,
          size.height * 0.42,
        ),
        Paint()..color = theme.horizon,
      );
  }

  @override
  bool shouldRepaint(_TablePainter oldDelegate) => oldDelegate.theme != theme;
}
