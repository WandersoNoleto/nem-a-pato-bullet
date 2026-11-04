import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// The "NEM / A / PATO! / BULLET" logo, laid out like the cover.
class GameTitle extends StatelessWidget {
  const GameTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('NEM', style: AppTextStyles.titleLarge),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _OrangeRule(),
              SizedBox(width: 16),
              Text('A', style: AppTextStyles.titleSmall),
              SizedBox(width: 16),
              _OrangeRule(),
            ],
          ),
          const SizedBox(height: 12),
          const Text('PATO!', style: AppTextStyles.titleLarge),
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
    return Transform.rotate(
      angle: 0.07,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.ink,
          boxShadow: [BoxShadow(color: AppColors.orange, offset: Offset(6, 6))],
        ),
        child: const Text('BULLET', style: AppTextStyles.tag),
      ),
    );
  }
}
