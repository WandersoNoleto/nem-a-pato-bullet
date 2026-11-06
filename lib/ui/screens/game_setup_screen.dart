import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_dependencies.dart';
import '../../domain/categories.dart';
import '../../domain/deck.dart';
import '../../state/game_setup_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/table_theme.dart';
import '../widgets/choice_pill.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha pelo menos uma categoria.')),
      );
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GameScreen(
          questions: questions,
          seen: widget.dependencies.seen,
          rounds: _controller.rounds,
        ),
      ),
    );
    // The game marked questions as seen; refresh the "inéditas" count.
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TableScaffold(
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: ScreenHeader(title: 'PREPARAR PARTIDA'),
            ),
            Expanded(child: _buildBody()),
            if (_controller.status == SetupStatus.ready)
              Padding(
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
        child: CircularProgressIndicator(color: theme.onTable),
      ),
      SetupStatus.error => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Não deu para carregar os baralhos.',
            textAlign: TextAlign.center,
            style: theme.hintStyle.copyWith(fontSize: 15),
          ),
        ),
      ),
      SetupStatus.ready => ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        children: [
          const SectionLabel('RODADAS'),
          _RoundsPicker(
            rounds: _controller.rounds,
            onChanged: _controller.setRounds,
          ),
          const SizedBox(height: 28),
          const SectionLabel('BARALHOS'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
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
            'CATEGORIAS',
            detail:
                '${_controller.selectedCategories.length} de '
                '${_controller.categories.length}',
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoicePill(
          label: '∞',
          semanticLabel: 'Infinitas',
          selected: rounds == null,
          onTap: () => onChanged(null),
        ),
        for (final preset in GameSetupController.roundPresets)
          ChoicePill(
            label: '$preset',
            selected: rounds == preset,
            onTap: () => onChanged(preset),
          ),
        ChoicePill(
          label: _isCustom ? '$rounds' : '+',
          semanticLabel: 'Outra quantidade',
          icon: _isCustom ? Icons.edit : null,
          selected: _isCustom,
          onTap: () => _pickCustom(context),
        ),
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
      setState(() => _error = 'Digite um número de 1 a $_max');
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
    return AlertDialog(
      title: const Text('Quantas rodadas?'),
      content: TextField(
        controller: _text,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        decoration: InputDecoration(hintText: '25', errorText: _error),
        onChanged: (_) {
          if (_error != null) setState(() => _error = null);
        },
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('OK')),
      ],
    );
  }
}

// --- Decks ------------------------------------------------------------------

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
      label: 'Baralho ${deck.name}, $count perguntas',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            RaisedBox(
              colors: selected
                  ? AppColors.actionGradient
                  : AppColors.paperGradient,
              width: 118,
              lipHeight: 4,
              softShadow: false,
              padding: const EdgeInsets.fromLTRB(6, 14, 6, 10),
              child: Column(
                children: [
                  DeckIcon(deck: deck, size: 36),
                  const SizedBox(height: 8),
                  // Room for two lines, so every tile has the same height.
                  SizedBox(
                    height: 34,
                    child: Center(
                      child: Text(
                        deck.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.credits.copyWith(
                          fontSize: 11,
                          color: selected ? AppColors.white : AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    count == 1 ? '1 pergunta' : '$count perguntas',
                    style: AppTextStyles.credits.copyWith(
                      fontSize: 10,
                      color: selected
                          ? AppColors.mutedOnAction
                          : AppColors.cardMuted,
                    ),
                  ),
                ],
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
                  'Nenhuma categoria escolhida',
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
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: AppColors.cardMuted),
                  prefixIconConstraints: BoxConstraints(minWidth: 32),
                  hintText: 'Buscar categoria para adicionar',
                ),
              ),
              if (showSuggestions) ...[
                if (suggestions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      removed.isEmpty
                          ? 'Todas as categorias já estão na partida'
                          : 'Nenhuma categoria encontrada',
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
                'Selecionar todas',
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
      label: 'Remover ${category.label}',
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
    final hint = switch (unseenCount) {
      0 => 'Nenhuma pergunta inédita com essas escolhas',
      1 => '1 pergunta inédita',
      _ => '$unseenCount perguntas inéditas',
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlayButton(
          label: 'COMEÇAR',
          gradient: AppColors.actionGradient,
          textColor: AppColors.white,
          pulse: false,
          tilt: 0,
          expand: true,
          onPressed: onStart,
        ),
        const SizedBox(height: 12),
        Text(hint, style: TableTheme.of(context).hintStyle),
      ],
    );
  }
}
