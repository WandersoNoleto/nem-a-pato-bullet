import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/table_theme.dart';

/// The "NEM / A / PATO! / BULLET" logo, laid out like the cover, in the
/// theme's colors.
class GameTitle extends StatelessWidget {
  const GameTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final color = TableTheme.of(context).title;
    final large = AppTextStyles.titleLarge.copyWith(color: color);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('NEM', style: large),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _OrangeRule(),
              const SizedBox(width: 16),
              Text('A', style: AppTextStyles.titleSmall.copyWith(color: color)),
              const SizedBox(width: 16),
              const _OrangeRule(),
            ],
          ),
          const SizedBox(height: 12),
          Text('PATO!', style: large),
          const SizedBox(height: 24),
          const _BulletTag(),
        ],
      ),
    );
  }
}

class _OrangeRule extends StatelessWidget {
  const _OrangeRule();

  @override
  Widget build(BuildContext context) {
    return Container(width: 110, height: 4, color: AppColors.orange);
  }
}

class _BulletTag extends StatelessWidget {
  const _BulletTag();

  @override
  Widget build(BuildContext context) {
    final theme = TableTheme.of(context);
    return Transform.rotate(
      angle: 0.07,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: theme.action.last,
          boxShadow: const [
            BoxShadow(color: AppColors.orange, offset: Offset(6, 6)),
          ],
        ),
        child: Text(
          'BULLET',
          style: AppTextStyles.tag.copyWith(color: theme.onAction),
        ),
      ),
    );
  }
}
