import 'package:flutter/material.dart';

import '../../app_dependencies.dart';
import '../../data/deck_files.dart';
import '../../domain/categories.dart';
import '../../domain/deck.dart';
import '../../domain/question.dart';
import '../../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/table_theme.dart';
import '../widgets/app_message.dart';
import '../widgets/deck_icon.dart';
import '../widgets/panel.dart';
import '../widgets/raised_box.dart';
import '../widgets/screen_header.dart';
import '../widgets/section_label.dart';
import '../widgets/table_scaffold.dart';

/// One deck: its categories and questions, with the answers hidden until a
/// question is tapped, and the deck's actions.
class DeckDetailsScreen extends StatefulWidget {
  const DeckDetailsScreen({
    super.key,
    required this.deck,
    required this.dependencies,
  });

  final Deck deck;
  final AppDependencies dependencies;

  @override
  State<DeckDetailsScreen> createState() => _DeckDetailsScreenState();
}

class _DeckDetailsScreenState extends State<DeckDetailsScreen> {
  bool _exporting = false;

  Future<void> _export() async {
    final deck = widget.deck;
    setState(() => _exporting = true);
    try {
      final saved = await widget.dependencies.deckFiles.save(
        fileName: deckFileName(deck.name),
        content: deck.toJsonString(),
      );
      if (saved && mounted) {
        showAppMessage(context, context.l10n.deckExported(deck.name));
      }
    } on Exception catch (error) {
      debugPrint('Could not export deck: $error');
      if (mounted) showAppMessage(context, context.l10n.exportFailed);
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deck = widget.deck;
    final categories = categoriesOf([deck]);
    final theme = TableTheme.of(context);
    return TableScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: ScreenHeader(title: context.l10n.deckDetailsTitle),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                _Summary(
                  deck: deck,
                  categories: categories.length,
                  actions: [
                    _ActionPill(
                      icon: Icons.ios_share,
                      label: context.l10n.exportButton,
                      semanticLabel: context.l10n.exportDeck,
                      busy: _exporting,
                      onTap: _export,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(context.l10n.deckDetailsHint, style: theme.hintStyle),
                for (final category in categories) ...[
                  const SizedBox(height: 20),
                  _CategorySection(
                    label: category.label,
                    questions: [
                      for (final question in deck.questions)
                        if (question.categoryKey == category.key) question,
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The deck's symbol, name and size on a compact yellow piece, like a card
/// header, with the deck's actions under a thin line.
class _Summary extends StatelessWidget {
  const _Summary({
    required this.deck,
    required this.categories,
    required this.actions,
  });

  final Deck deck;
  final int categories;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return RaisedBox(
      colors: AppColors.headerGradient,
      lipHeight: 4,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              DeckIcon(deck: deck, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deck.name,
                      style: AppTextStyles.category.copyWith(
                        fontSize: 16,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.questionCount(deck.questions.length)}'
                      ' · ${l10n.categoryCount(categories)}',
                      style: AppTextStyles.credits.copyWith(
                        color: AppColors.mutedOnYellow,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(
            height: 1.5,
            thickness: 1.5,
            color: AppColors.mutedOnYellow.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: actions),
        ],
      ),
    );
  }
}

/// A small paper pill with an icon and a label, for the deck's actions.
class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.icon,
    required this.label,
    required this.onTap,
    this.semanticLabel,
    this.busy = false,
  });

  final IconData icon;
  final String label;
  final String? semanticLabel;
  final VoidCallback onTap;

  /// Shows a spinner and ignores taps while the action runs.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: busy ? null : onTap,
        child: RaisedBox(
          colors: AppColors.paperGradient,
          lipColor: AppColors.ink,
          radius: 999,
          borderWidth: 2,
          lipHeight: 2,
          softShadow: false,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              busy
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.ink,
                      ),
                    )
                  : Icon(icon, size: 16, color: AppColors.ink),
              const SizedBox(width: 6),
              Text(label, style: AppTextStyles.credits.copyWith(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.label, required this.questions});

  final String label;
  final List<Question> questions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(label.toUpperCase(), detail: '${questions.length}'),
        Panel(
          children: [
            for (final question in questions)
              _QuestionRow(key: ValueKey(question.id), question: question),
          ],
        ),
      ],
    );
  }
}

/// A question that shows its answer and fun fact when tapped, like the card
/// flipping in the game.
class _QuestionRow extends StatefulWidget {
  const _QuestionRow({super.key, required this.question});

  final Question question;

  @override
  State<_QuestionRow> createState() => _QuestionRowState();
}

class _QuestionRowState extends State<_QuestionRow> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    final fact = question.fact;
    final l10n = context.l10n;
    return Semantics(
      button: true,
      expanded: _revealed,
      child: InkWell(
        onTap: () => setState(() => _revealed = !_revealed),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      question.text,
                      style: AppTextStyles.credits.copyWith(
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _revealed ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.ink,
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                alignment: Alignment.topCenter,
                child: !_revealed
                    ? const SizedBox(width: double.infinity)
                    : Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.answerLabel,
                              style: AppTextStyles.cardLabel,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              question.answer,
                              style: AppTextStyles.answer.copyWith(
                                fontSize: 24,
                              ),
                            ),
                            if (fact != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                l10n.factLabel,
                                style: AppTextStyles.cardLabel,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                fact,
                                style: AppTextStyles.fact.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
