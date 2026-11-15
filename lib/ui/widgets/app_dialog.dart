import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/table_theme.dart';
import 'play_button.dart';
import 'raised_box.dart';

/// A dialog on a paper panel: display-font title, content and sticker
/// buttons stacked under it, the main action first.
///
/// Scrolls when it doesn't fit, e.g. on short phones or with a large font.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.child,
    this.actions = const [],
  });

  final String title;
  final Widget child;

  /// Usually [DialogButton]s.
  final List<Widget> actions;

  /// Body text on the panel.
  static final bodyStyle = AppTextStyles.fact.copyWith(
    fontSize: 14,
    height: 1.4,
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: RaisedBox(
          colors: AppColors.paperGradient,
          radius: 18,
          borderWidth: 3,
          lipHeight: 6,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.titleSmall.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 20),
                DefaultTextStyle.merge(style: bodyStyle, child: child),
                for (final (index, action) in actions.indexed) ...[
                  SizedBox(height: index == 0 ? 24 : 16),
                  action,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A full-width sticker button for [AppDialog]: the main action in the
/// theme's action colors, the others on paper.
class DialogButton extends StatelessWidget {
  const DialogButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.primary = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final theme = TableTheme.of(context);
    return PlayButton(
      label: label,
      color: primary ? theme.action.last : AppColors.white,
      textColor: primary ? theme.onAction : AppColors.ink,
      shadowColor: primary ? AppColors.orange : theme.paperLip,
      pulse: false,
      tilt: 0,
      expand: true,
      onPressed: onPressed,
    );
  }
}
