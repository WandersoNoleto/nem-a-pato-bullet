import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Placeholder until the question screen step.
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellow,
      appBar: AppBar(
        backgroundColor: AppColors.yellow,
        foregroundColor: AppColors.ink,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Em breve', style: AppTextStyles.titleSmall),
      ),
    );
  }
}
