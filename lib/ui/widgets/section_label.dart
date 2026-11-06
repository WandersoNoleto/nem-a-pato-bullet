import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/table_theme.dart';

/// Title of a section on the table screens, with an optional muted detail.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.detail});

  final String text;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final detail = this.detail;
    final theme = TableTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text.rich(
        TextSpan(
          text: text,
          children: [
            if (detail != null)
              TextSpan(text: '  ·  $detail', style: theme.hintStyle),
          ],
        ),
        style: AppTextStyles.pill.copyWith(color: theme.onTable),
      ),
    );
  }
}
