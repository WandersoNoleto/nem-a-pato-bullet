import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'raised_box.dart';

/// Cream box that groups rows, like a card on the table.
class Panel extends StatelessWidget {
  const Panel({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RaisedBox(
      colors: AppColors.paperGradient,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, child) in children.indexed) ...[
                if (index > 0)
                  const Divider(
                    height: 1.5,
                    thickness: 1.5,
                    color: AppColors.cardDivider,
                  ),
                child,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A tappable row in a [Panel]: leading icon, title, optional subtitle and a
/// trailing widget.
class PanelRow extends StatelessWidget {
  const PanelRow({
    super.key,
    required this.leading,
    required this.title,
    required this.trailing,
    required this.onTap,
    this.subtitle,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.credits.copyWith(fontSize: 15),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: AppTextStyles.credits.copyWith(
                        color: AppColors.cardMuted,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }
}

/// A [PanelRow] for an action, with a chevron or a spinner while it runs.
class PanelActionRow extends StatelessWidget {
  const PanelActionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.busy = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  /// Shows a spinner and ignores taps while the action runs.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return PanelRow(
      leading: Icon(icon, size: 28, color: AppColors.ink),
      title: title,
      subtitle: subtitle,
      trailing: busy
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.ink,
              ),
            )
          : const Icon(Icons.chevron_right, color: AppColors.ink),
      onTap: busy ? null : onTap,
    );
  }
}
