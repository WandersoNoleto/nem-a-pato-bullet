import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Title of a section on the black screens, with an optional muted detail.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.detail});

  final String text;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final detail = this.detail;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text.rich(
        TextSpan(
          text: text,
          children: [
            if (detail != null)
              TextSpan(text: '  ·  $detail', style: AppTextStyles.hint),
          ],
        ),
        style: AppTextStyles.pill.copyWith(color: AppColors.cream),
      ),
    );
  }
}
