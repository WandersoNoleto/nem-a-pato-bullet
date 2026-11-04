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
                  painter: _TrailPainter(tailX: trainLeft + trainWidth * 0.88),
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
  _TrailPainter({required this.tailX});

  /// Where the back of the train is; the trail runs from here to the right.
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

    if (tailX >= railEnd) return;

    canvas.drawLine(
      Offset(tailX, railY),
      Offset(railEnd, railY),
      stroke..color = AppColors.ink,
    );

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
  bool shouldRepaint(_TrailPainter oldDelegate) => oldDelegate.tailX != tailX;
}
