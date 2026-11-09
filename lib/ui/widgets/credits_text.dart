import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../theme/app_text_styles.dart';
import '../theme/table_theme.dart';

/// Credits to the original game, shown on the loading and home screens.
class CreditsText extends StatelessWidget {
  const CreditsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.credits,
      textAlign: TextAlign.center,
      style: AppTextStyles.credits.copyWith(
        color: TableTheme.of(context).onTable,
      ),
    );
  }
}
