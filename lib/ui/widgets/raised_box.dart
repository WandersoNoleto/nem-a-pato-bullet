import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/table_theme.dart';

/// A piece with volume: a gradient with a light top edge, an outline, a solid
/// lip underneath and a soft shadow on the table.
///
/// When [pressed], the piece sinks onto its lip.
class RaisedBox extends StatelessWidget {
  const RaisedBox({
    super.key,
    required this.colors,
    required this.child,
    this.radius = 14,
    this.borderWidth = 2.5,
    this.lipHeight = 5,
    this.lipColor,
    this.softShadow = true,
    this.pressed = false,
    this.padding,
    this.constraints,
    this.width,
  });

  /// Top and bottom colors.
  final List<Color> colors;
  final Widget child;
  final double radius;
  final double borderWidth;
  final double lipHeight;

  /// Defaults to the theme's lip color.
  final Color? lipColor;
  final bool softShadow;
  final bool pressed;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = TableTheme.of(context);
    final lip = pressed ? 0.0 : lipHeight;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 80),
      width: width,
      constraints: constraints,
      padding: padding,
      transform: Matrix4.translationValues(0, lipHeight - lip, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(colors.first, AppColors.white, 0.55)!,
            colors.first,
            colors.last,
          ],
          stops: const [0, 0.08, 1],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.ink, width: borderWidth),
        boxShadow: [
          BoxShadow(color: lipColor ?? theme.pieceLip, offset: Offset(0, lip)),
          if (softShadow)
            BoxShadow(
              color: theme.pieceShadow,
              offset: Offset(0, lip + 7),
              blurRadius: 14,
            ),
        ],
      ),
      child: child,
    );
  }
}
