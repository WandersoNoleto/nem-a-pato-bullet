import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'raised_box.dart';

/// A chunky game button that sinks into its shadow when pressed.
///
/// By default it is the tilted, pulsing black JOGAR button. With a [gradient]
/// it becomes a raised piece, used on the table screens.
class PlayButton extends StatefulWidget {
  const PlayButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.ink,
    this.gradient,
    this.textColor = AppColors.white,
    this.pulse = true,
    this.tilt = -0.04,
    this.expand = false,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;

  /// Top and bottom colors; makes the button a raised piece.
  final List<Color>? gradient;
  final Color textColor;
  final bool pulse;

  /// Rotation in radians.
  final double tilt;

  /// Fills the available width.
  final bool expand;

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton>
    with SingleTickerProviderStateMixin {
  static const _shadowOffset = 6.0;

  late final AnimationController _pulse;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 1,
      upperBound: 1.06,
    );
    if (widget.pulse) _pulse.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _setPressed(bool value) => setState(() => _pressed = value);

  void _onTap() {
    HapticFeedback.mediumImpact();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final offset = _pressed ? _shadowOffset : 0.0;
    final gradient = widget.gradient;
    final label = FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        widget.label,
        textAlign: TextAlign.center,
        style: AppTextStyles.button.copyWith(
          color: widget.textColor,
          shadows: widget.textColor == AppColors.white && gradient != null
              ? AppTextStyles.raisedTextShadow
              : null,
        ),
      ),
    );
    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: _onTap,
        child: ScaleTransition(
          scale: _pulse,
          child: Transform.rotate(
            angle: widget.tilt,
            child: gradient == null
                ? _buildFlat(offset, label)
                : RaisedBox(
                    colors: gradient,
                    radius: 12,
                    width: widget.expand ? double.infinity : null,
                    pressed: _pressed,
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.expand ? 16 : 48,
                      vertical: 18,
                    ),
                    child: label,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlat(double offset, Widget label) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 80),
      width: widget.expand ? double.infinity : null,
      transform: Matrix4.translationValues(offset, offset, 0),
      padding: EdgeInsets.symmetric(
        horizontal: widget.expand ? 16 : 48,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange,
            offset: Offset(_shadowOffset - offset, _shadowOffset - offset),
          ),
        ],
      ),
      child: label,
    );
  }
}
