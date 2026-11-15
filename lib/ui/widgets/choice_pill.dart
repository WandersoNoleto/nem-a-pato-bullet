import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/table_theme.dart';
import 'raised_box.dart';

/// A rounded option that takes the theme's action colors when selected.
class ChoicePill extends StatelessWidget {
  const ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.semanticLabel,
    this.icon,
    this.leading,
    this.glyph,
    this.expand = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? semanticLabel;
  final IconData? icon;

  /// Shown before the label, like a flag.
  final Widget? leading;

  /// Drawn instead of the label, in the pill's text color.
  final Widget Function(Color color)? glyph;

  /// Fills the available width, shrinking the content if it doesn't fit.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final leading = this.leading;
    final glyph = this.glyph;
    final theme = TableTheme.of(context);
    final foreground = selected ? theme.onSelected : AppColors.ink;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[leading, const SizedBox(width: 8)],
        if (glyph != null)
          glyph(foreground)
        else
          Text(
            label,
            style: AppTextStyles.pill.copyWith(fontSize: 16, color: foreground),
          ),
        if (icon != null) ...[
          const SizedBox(width: 4),
          Icon(icon, size: 14, color: foreground),
        ],
      ],
    );
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel ?? label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: RaisedBox(
          colors: selected ? theme.action : AppColors.paperGradient,
          lipColor: selected ? theme.actionLip : null,
          radius: 999,
          borderWidth: 2,
          lipHeight: 3,
          softShadow: false,
          width: expand ? double.infinity : null,
          constraints: const BoxConstraints(minWidth: 48),
          padding: EdgeInsets.symmetric(
            horizontal: expand ? 6 : 14,
            vertical: 10,
          ),
          child: expand
              // Shrinks to fit, keeping the height of one line of text.
              ? SizedBox(
                  height: 16,
                  child: FittedBox(fit: BoxFit.scaleDown, child: content),
                )
              : content,
        ),
      ),
    );
  }
}
