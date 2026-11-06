import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/table_theme.dart';
import 'raised_box.dart';

/// Back button and title at the top of the table screens.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const RaisedBackButton(),
        const SizedBox(width: 14),
        Text(
          title,
          style: AppTextStyles.category.copyWith(
            color: TableTheme.of(context).onTable,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

/// The round back button used on every table screen.
class RaisedBackButton extends StatelessWidget {
  const RaisedBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RaisedBox(
      colors: AppColors.paperGradient,
      radius: 999,
      borderWidth: 2,
      lipHeight: 3,
      softShadow: false,
      child: IconButton(
        onPressed: () => Navigator.of(context).maybePop(),
        tooltip: context.l10n.back,
        color: AppColors.ink,
        visualDensity: VisualDensity.compact,
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
