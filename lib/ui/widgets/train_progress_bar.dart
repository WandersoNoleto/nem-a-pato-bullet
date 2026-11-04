import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A loading bar where the mascot train runs right to left, leaving a trail.
class TrainProgressBar extends StatelessWidget {
  const TrainProgressBar({super.key, required this.progress});

  /// From 0 (start) to 1 (done).
  final double progress;

  static const trainWidth = 64.0;
  static const trainHeight = 41.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: trainHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final trainLeft =
              (constraints.maxWidth - trainWidth) * (1 - progress);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _TrailPainter(
                    frontX: trainLeft,
                    tailX: trainLeft + trainWidth * 0.88,
                  ),
                ),
              ),
              Positioned(
                left: trainLeft,
                top: 0,
                width: trainWidth,
                height: trainHeight,
                // The source art already faces left, the way the train runs.
                child: Image.asset(
                  'assets/images/mascot_train.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TrailPainter extends CustomPainter {
  _TrailPainter({required this.frontX, required this.tailX});

  /// Where the nose of the train is; the filled bar runs from here to the
  /// right, so it is complete when the train reaches the left edge.
  final double frontX;

  /// Where the back of the train is; the speed lines start here.
  final double tailX;

  @override
  void paint(Canvas canvas, Size size) {
    final railY = size.height - 2;
    final railEnd = size.width - 2;
    final stroke = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    canvas.drawLine(
      Offset(2, railY),
      Offset(railEnd, railY),
      stroke..color = AppColors.ink.withValues(alpha: 0.15),
    );

    canvas.drawLine(
      Offset(frontX.clamp(2.0, railEnd), railY),
      Offset(railEnd, railY),
      stroke..color = AppColors.ink,
    );

    if (tailX >= railEnd) return;

    final speedLine = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..color = AppColors.ink.withValues(alpha: 0.6);
    const lines = [
      (y: 0.45, length: 32.0),
      (y: 0.6, length: 22.0),
      (y: 0.75, length: 14.0),
    ];
    for (final line in lines) {
      final y = size.height * line.y;
      final end = (tailX + line.length).clamp(tailX, size.width);
      canvas.drawLine(Offset(tailX, y), Offset(end, y), speedLine);
    }
  }

  @override
  bool shouldRepaint(_TrailPainter oldDelegate) =>
      oldDelegate.frontX != frontX || oldDelegate.tailX != tailX;
}
