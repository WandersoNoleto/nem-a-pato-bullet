import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_dialog.dart';

/// Shows the game rules on a paper panel, with the note that the score stays
/// at the table.
Future<void> showRulesDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const RulesDialog(),
  );
}

class RulesDialog extends StatelessWidget {
  const RulesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = [
      l10n.rulesSetup,
      l10n.rulesRead,
      l10n.rulesGuess,
      l10n.rulesChallenge,
      l10n.rulesOut,
    ];
    return AppDialog(
      title: l10n.rulesTitle,
      actions: [
        DialogButton(
          label: l10n.rulesClose,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, step) in steps.indexed)
            _Step(
              number: index + 1,
              text: step,
              highlight: index == steps.length - 1,
            ),
          const SizedBox(height: 4),
          _Note(text: l10n.rulesNote),
        ],
      ),
    );
  }
}

/// A numbered step; the elimination rule is [highlight]ed in yellow.
class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.text,
    this.highlight = false,
  });

  final int number;
  final String text;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final style = AppDialog.bodyStyle;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: highlight ? AppColors.yellow : AppColors.ink,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.ink, width: 2),
            ),
            child: Text(
              '$number',
              style: AppTextStyles.pill.copyWith(
                color: highlight ? AppColors.ink : AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: highlight
                    ? style.copyWith(fontWeight: FontWeight.w900)
                    : style,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The reminder that the app doesn't keep score.
class _Note extends StatelessWidget {
  const _Note({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.headerGradient,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.ink, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.fact.copyWith(
                fontSize: 13,
                height: 1.4,
                color: AppColors.mutedOnYellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
