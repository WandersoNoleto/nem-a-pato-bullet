import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_dependencies.dart';
import '../../domain/categories.dart';
import '../../domain/deck.dart';
import '../../l10n/l10n.dart';
import '../../state/game_setup_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/table_theme.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_message.dart';
import '../widgets/choice_pill.dart';
import '../widgets/infinity_glyph.dart';
import '../widgets/deck_icon.dart';
import '../widgets/play_button.dart';
import '../widgets/raised_box.dart';
import '../widgets/screen_header.dart';
import '../widgets/section_label.dart';
import '../widgets/table_scaffold.dart';
import 'game_screen.dart';

/// "Preparar partida": rounds, decks and categories, before the game.
class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  final _startAreaKey = GlobalKey();
  late final _controller = GameSetupController(
    loadDecks: widget.dependencies.loadDecks,
    seen: widget.dependencies.seen,
  );

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final questions = _controller.questions;
    if (questions.isEmpty) {
      // Above the start button, which the message would cover.
      final startArea = _startAreaKey.currentContext?.size?.height ?? 0;
      showAppMessage(
        context,
        context.l10n.noCategoryChosen,
        bottom: startArea + 8,
      );
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GameScreen(
          questions: questions,
          seen: widget.dependencies.seen,
          rounds: _controller.rounds,
          sound: widget.dependencies.sound,
        ),
      ),
    );
    // The game marked questions as seen; refresh the "cartas no baralho" count.
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TableScaffold(
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: ScreenHeader(title: context.l10n.setupTitle),
            ),
            Expanded(child: _buildBody()),
            if (_controller.status == SetupStatus.ready)
              Padding(
                key: _startAreaKey,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: _StartArea(
                  unseenCount: _controller.unseenCount,
                  onStart: _start,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    final theme = TableTheme.of(context);
    return switch (_controller.status) {
      SetupStatus.loading => Center(
        child: CircularProgressIndicator(color: theme.title),
      ),
      SetupStatus.error => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            context.l10n.decksLoadFailed,
            textAlign: TextAlign.center,
            style: theme.hintStyle.copyWith(fontSize: 15),
          ),
        ),
      ),
      SetupStatus.ready => ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        children: [
          SectionLabel(context.l10n.roundsSection),
          _RoundsPicker(
            rounds: _controller.rounds,
            onChanged: _controller.setRounds,
          ),
          const SizedBox(height: 28),
          SectionLabel(context.l10n.decksSection),
          _DeckGrid(
            children: [
              for (final deck in _controller.decks)
                _DeckTile(
                  deck: deck,
                  selected: _controller.isSelected(deck),
                  onTap: () => _controller.toggleDeck(deck),
                ),
            ],
          ),
          const SizedBox(height: 28),
          SectionLabel(
            context.l10n.categoriesSection,
            detail: context.l10n.categoriesDetail(
              _controller.selectedCategories.length,
              _controller.categories.length,
            ),
          ),
          _CategoryPicker(controller: _controller),
        ],
      ),
    };
  }
}

// --- Rounds -----------------------------------------------------------------

class _RoundsPicker extends StatelessWidget {
  const _RoundsPicker({required this.rounds, required this.onChanged});

  final int? rounds;
  final ValueChanged<int?> onChanged;

  bool get _isCustom =>
      rounds != null && !GameSetupController.roundPresets.contains(rounds);

  Future<void> _pickCustom(BuildContext context) async {
    final custom = await showDialog<int>(
      context: context,
      builder: (_) => _CustomRoundsDialog(initial: _isCustom ? rounds : null),
    );
    if (custom != null) onChanged(custom);
  }

  @override
  Widget build(BuildContext context) {
    // One row: every option shares the width, so "+" never wraps alone.
    final options = [
      ChoicePill(
        label: '∞',
        semanticLabel: context.l10n.infiniteRounds,
        glyph: (color) => InfinityGlyph(color: color),
        selected: rounds == null,
        expand: true,
        onTap: () => onChanged(null),
      ),
      for (final preset in GameSetupController.roundPresets)
        ChoicePill(
          label: '$preset',
          selected: rounds == preset,
          expand: true,
          onTap: () => onChanged(preset),
        ),
      ChoicePill(
        label: _isCustom ? '$rounds' : '+',
        semanticLabel: context.l10n.customRounds,
        icon: _isCustom ? Icons.edit : null,
        selected: _isCustom,
        expand: true,
        onTap: () => _pickCustom(context),
      ),
    ];
    return Row(
      children: [
        for (final (index, option) in options.indexed) ...[
          if (index > 0) const SizedBox(width: 8),
          // ∞ is the default choice and gets a little more room.
          Expanded(flex: index == 0 ? 5 : 4, child: option),
        ],
      ],
    );
  }
}

class _CustomRoundsDialog extends StatefulWidget {
  const _CustomRoundsDialog({this.initial});

  final int? initial;

  @override
  State<_CustomRoundsDialog> createState() => _CustomRoundsDialogState();
}

class _CustomRoundsDialogState extends State<_CustomRoundsDialog> {
  static const _max = 999;

  late final _text = TextEditingController(
    text: widget.initial?.toString() ?? '',
  );
  String? _error;

  void _submit() {
    final value = int.tryParse(_text.text);
    if (value == null || value < 1 || value > _max) {
      setState(() => _error = context.l10n.customRoundsError(_max));
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.ink, width: 2.5),
    );
    return AppDialog(
      title: context.l10n.customRoundsTitle,
      actions: [
        DialogButton(label: context.l10n.ok, onPressed: _submit),
        DialogButton(
          label: context.l10n.cancel,
          primary: false,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _text,
            autofocus: true,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            cursorColor: AppColors.ink,
            style: AppTextStyles.answer.copyWith(fontSize: 40),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            decoration: InputDecoration(
              hintText: '25',
              hintStyle: AppTextStyles.answer.copyWith(
                fontSize: 40,
                color: AppColors.cardDivider,
              ),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: border,
              enabledBorder: border,
              focusedBorder: border,
            ),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            onSubmitted: (_) => _submit(),
          ),
          // Always takes room, so the panel doesn't jump when it shows.
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (error != null) ...[
                const Icon(
                  Icons.error_outline,
                  size: 18,
                  color: AppColors.orange,
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  error ?? context.l10n.customRoundsHint(_max),
                  textAlign: TextAlign.center,
                  style: AppDialog.bodyStyle.copyWith(
                    fontSize: 13,
                    color: error == null ? AppColors.cardMuted : AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Decks ------------------------------------------------------------------

/// Deck tiles in as many columns as fit: three on a typical phone, two on a
/// narrow one and more on wide screens, so no empty strip is left on the right.
class _DeckGrid extends StatelessWidget {
  const _DeckGrid({required this.children});

  static const _minTileWidth = 96.0;
  static const _spacing = 12.0;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // A larger system font needs wider tiles, so fewer columns.
        final minTileWidth = MediaQuery.textScalerOf(context)
            .scale(_minTileWidth)
            .clamp(_minTileWidth, _minTileWidth * 1.6);
        final columns = ((width + _spacing) / (minTileWidth + _spacing))
            .floor()
            .clamp(2, 8);
        // Rounded down so rounding never pushes the last tile to a new row.
        final tileWidth = ((width - _spacing * (columns - 1)) / columns)
            .floorToDouble();
        return Wrap(
          spacing: _spacing,
          runSpacing: _spacing,
          children: [
            for (final child in children)
              SizedBox(width: tileWidth, child: child),
          ],
        );
      },
    );
  }
}

class _DeckTile extends StatelessWidget {
  const _DeckTile({
    required this.deck,
    required this.selected,
    required this.onTap,
  });

  final Deck deck;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final count = deck.questions.length;
    return Semantics(
      button: true,
      selected: selected,
      label: context.l10n.deckTileLabel(deck.name, count),
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Unselected decks fade, so the selected ones stand out.
            AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: selected ? 1 : 0.55,
              child: RaisedBox(
                colors: selected
                    ? AppColors.headerGradient
                    : AppColors.paperGradient,
                width: double.infinity,
                lipHeight: 4,
                softShadow: false,
                padding: const EdgeInsets.fromLTRB(6, 14, 6, 10),
                child: Column(
                  children: [
                    DeckIcon(deck: deck, size: 36),
                    const SizedBox(height: 8),
                    // Room for two lines, so every tile has the same height.
                    SizedBox(
                      height: MediaQuery.textScalerOf(context).scale(34),
                      child: Center(child: _DeckName(deck.name)),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        context.l10n.questionCount(count),
                        maxLines: 1,
                        style: AppTextStyles.credits.copyWith(
                          fontSize: 10,
                          color: selected
                              ? AppColors.mutedOnYellow
                              : AppColors.cardMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selected)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.ink,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: AppColors.yellow,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A deck name in up to two lines. The font shrinks until the longest word
/// fits, so words never break in the middle on narrow tiles.
class _DeckName extends StatelessWidget {
  const _DeckName(this.name);

  static const _fontSize = 11.0;
  static const _minFontSize = 8.0;

  final String name;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.credits.copyWith(color: AppColors.ink);
    // Measured with what the Text inherits too, like the theme's spacing.
    final inherited = DefaultTextStyle.of(context).style;
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaler = MediaQuery.textScalerOf(context);
        final longest = name
            .split(RegExp(r'\s+'))
            .map(
              (word) => _width(
                word,
                inherited.merge(base.copyWith(fontSize: _fontSize)),
                scaler,
              ),
            )
            .fold(0.0, (a, b) => a > b ? a : b);
        final available = constraints.maxWidth;
        final fontSize = longest <= available
            ? _fontSize
            : (_fontSize * available / longest)
                  .clamp(_minFontSize, _fontSize)
                  .floorToDouble();
        return Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: base.copyWith(fontSize: fontSize),
        );
      },
    );
  }

  static double _width(String word, TextStyle style, TextScaler scaler) {
    final painter = TextPainter(
      text: TextSpan(text: word, style: style),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
      maxLines: 1,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }
}

// --- Categories -------------------------------------------------------------

/// Selected categories as removable tags, plus a search box that lists the
/// removed ones so they can be added back.
class _CategoryPicker extends StatefulWidget {
  const _CategoryPicker({required this.controller});

  final GameSetupController controller;

  @override
  State<_CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<_CategoryPicker> {
  final _search = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _add(DeckCategory category) {
    widget.controller.addCategory(category);
    _search.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = TableTheme.of(context);
    final controller = widget.controller;
    final selected = controller.selectedCategories;
    final removed = controller.removedCategories;
    final query = _search.text;
    final suggestions = [
      for (final category in removed)
        if (categoryMatches(category, query)) category,
    ];
    final showSuggestions = _focus.hasFocus || query.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RaisedBox(
          colors: AppColors.paperGradient,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (selected.isEmpty)
                Text(
                  context.l10n.noCategories,
                  style: AppTextStyles.credits.copyWith(
                    color: AppColors.cardMuted,
                  ),
                )
              else
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final category in selected)
                      _CategoryTag(
                        category: category,
                        onRemove: () => controller.removeCategory(category),
                      ),
                  ],
                ),
              const Divider(color: AppColors.cardDivider, thickness: 1.5),
              TextField(
                controller: _search,
                focusNode: _focus,
                onChanged: (_) => setState(() {}),
                style: AppTextStyles.credits.copyWith(fontSize: 14),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.cardMuted,
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 32),
                  hintText: context.l10n.searchCategory,
                ),
              ),
              if (showSuggestions) ...[
                if (suggestions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      removed.isEmpty
                          ? context.l10n.allCategoriesInGame
                          : context.l10n.noCategoryFound,
                      style: AppTextStyles.credits.copyWith(
                        color: AppColors.cardMuted,
                      ),
                    ),
                  )
                else
                  for (final category in suggestions)
                    InkWell(
                      onTap: () => _add(category),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add,
                              size: 18,
                              color: AppColors.ink,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                category.label,
                                style: AppTextStyles.credits.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ],
          ),
        ),
        if (removed.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.selectAllCategories,
              style: TextButton.styleFrom(foregroundColor: theme.hint),
              child: Text(
                context.l10n.selectAll,
                style: theme.hintStyle.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: theme.hint,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CategoryTag extends StatelessWidget {
  const _CategoryTag({required this.category, required this.onRemove});

  final DeckCategory category;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.removeCategory(category.label),
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onRemove,
        child: RaisedBox(
          colors: AppColors.headerGradient,
          radius: 999,
          borderWidth: 2,
          lipHeight: 2,
          softShadow: false,
          padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(category.label, style: AppTextStyles.credits),
              const SizedBox(width: 4),
              const Icon(Icons.close, size: 14, color: AppColors.ink),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Start ------------------------------------------------------------------

class _StartArea extends StatelessWidget {
  const _StartArea({required this.unseenCount, required this.onStart});

  final int unseenCount;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final hint = context.l10n.unseenCount(unseenCount);
    final theme = TableTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlayButton(
          label: context.l10n.startButton,
          color: theme.action.last,
          textColor: theme.onAction,
          pulse: false,
          tilt: 0,
          expand: true,
          onPressed: onStart,
        ),
        const SizedBox(height: 12),
        Text(hint, style: theme.hintStyle),
      ],
    );
  }
}
