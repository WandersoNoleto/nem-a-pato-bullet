import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Back button and title at the top of the black screens.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Voltar',
          style: IconButton.styleFrom(
            foregroundColor: AppColors.cream,
            side: const BorderSide(color: AppColors.cream, width: 2),
          ),
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: AppTextStyles.category.copyWith(
            color: AppColors.yellow,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
