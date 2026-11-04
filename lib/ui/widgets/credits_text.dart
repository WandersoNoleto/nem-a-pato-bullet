import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

/// Credits to the original game, shown on the loading and home screens.
class CreditsText extends StatelessWidget {
  const CreditsText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Inspirado em "Nem a Pato!", de Rodrigo Rego · Grok Games',
      textAlign: TextAlign.center,
      style: AppTextStyles.credits,
    );
  }
}
