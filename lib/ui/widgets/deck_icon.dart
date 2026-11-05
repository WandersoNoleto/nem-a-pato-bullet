import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/deck.dart';
import '../theme/app_colors.dart';

/// The deck's own SVG symbol, or a playing-card symbol when it has none.
///
/// Custom symbols are painted in ink so every deck matches the app's look.
class DeckIcon extends StatelessWidget {
  const DeckIcon({super.key, required this.deck, this.size = 32});

  final Deck deck;
  final double size;

  @override
  Widget build(BuildContext context) {
    final svg = deck.iconSvg;
    if (svg == null) return _CardSymbol(size: size);
    return SvgPicture.string(
      svg,
      width: size,
      height: size,
      colorFilter: const ColorFilter.mode(AppColors.ink, BlendMode.srcIn),
      // A broken SVG falls back to the default symbol instead of crashing.
      errorBuilder: (_, _, _) => _CardSymbol(size: size),
    );
  }
}

/// Two stacked playing cards.
class _CardSymbol extends StatelessWidget {
  const _CardSymbol({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _CardSymbolPainter()),
    );
  }
}

class _CardSymbolPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final stroke = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.08
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = AppColors.cream;

    void card(double angle, Offset center) {
      canvas
        ..save()
        ..translate(center.dx, center.dy)
        ..rotate(angle);
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: s * 0.5, height: s * 0.7),
        Radius.circular(s * 0.08),
      );
      canvas
        ..drawRRect(rect, fill)
        ..drawRRect(rect, stroke)
        ..restore();
    }

    card(-0.25, Offset(s * 0.4, s * 0.52));
    card(0.2, Offset(s * 0.6, s * 0.48));

    // A small diamond on the front card.
    canvas
      ..save()
      ..translate(s * 0.6, s * 0.48)
      ..rotate(0.2);
    final diamond = Path()
      ..moveTo(0, -s * 0.12)
      ..lineTo(s * 0.08, 0)
      ..lineTo(0, s * 0.12)
      ..lineTo(-s * 0.08, 0)
      ..close();
    canvas
      ..drawPath(diamond, Paint()..color = AppColors.orange)
      ..restore();
  }

  @override
  bool shouldRepaint(_CardSymbolPainter oldDelegate) => false;
}
