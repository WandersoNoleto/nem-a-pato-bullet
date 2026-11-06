import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A rounded option that turns yellow when selected.
class ChoicePill extends StatelessWidget {
  const ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.semanticLabel,
    this.icon,
    this.leading,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? semanticLabel;
  final IconData? icon;

  /// Shown before the label, like a flag.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final leading = this.leading;
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel ?? label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(minWidth: 48),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.yellow : AppColors.cream,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.ink, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[leading, const SizedBox(width: 8)],
              Text(label, style: AppTextStyles.pill.copyWith(fontSize: 16)),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, size: 14, color: AppColors.ink),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
