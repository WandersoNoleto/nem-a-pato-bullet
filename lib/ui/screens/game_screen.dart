import 'package:flutter/material.dart';

import '../../domain/question.dart';
import '../../state/game_controller.dart';
import '../../state/seen_questions.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/table_theme.dart';
import '../widgets/play_button.dart';
import '../widgets/question_card.dart';
import '../widgets/raised_box.dart';
import '../widgets/screen_header.dart';
import '../widgets/table_scaffold.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.questions,
    required this.seen,
    this.rounds,
  });

  /// The questions the game draws from, already filtered by the setup.
  final List<Question> questions;
  final SeenQuestions seen;

  /// Null means infinite.
  final int? rounds;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final _controller = GameController(
    questions: widget.questions,
    seen: widget.seen,
    rounds: widget.rounds,
  );

  @override
  void initState() {
    super.initState();
    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TableScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => Column(
            children: [
              _TopBar(round: _controller.round, rounds: _controller.rounds),
              Expanded(child: Center(child: _buildCenter())),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenter() {
    final question = _controller.current;
    return switch (_controller.status) {
      GameStatus.outOfQuestions => const _Message(
        title: 'Acabaram as perguntas!',
        body: 'Todas as perguntas escolhidas para esta partida já saíram.',
      ),
      GameStatus.finished => _Message(
        title: 'Fim da partida!',
        body:
            '${_controller.round} rodadas jogadas. Quem ficou com mais '
            'cartas é o pato da mesa.',
      ),
      GameStatus.question || GameStatus.revealed => AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) => SlideTransition(
          position: Tween(
            begin: const Offset(1.2, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
        child: QuestionCard(
          key: ValueKey(question!.id),
          question: question,
          revealed: _controller.status == GameStatus.revealed,
        ),
      ),
    };
  }

  Widget _buildActions() {
    final back = PlayButton(
      key: const ValueKey('back'),
      label: 'VOLTAR',
      gradient: AppColors.paperGradient,
      textColor: AppColors.ink,
      pulse: false,
      tilt: 0,
      expand: true,
      onPressed: () => Navigator.of(context).pop(),
    );
    final (buttons, hint) = switch (_controller.status) {
      GameStatus.question => (
        [
          PlayButton(
            key: const ValueKey('reveal'),
            label: 'NEM A PATO!',
            gradient: AppColors.actionGradient,
            textColor: AppColors.white,
            tilt: 0,
            expand: true,
            onPressed: _controller.reveal,
          ),
        ],
        'Gritou? Toque para revelar',
      ),
      GameStatus.revealed => (
        [
          PlayButton(
            key: const ValueKey('next'),
            label: 'PRÓXIMA',
            gradient: AppColors.paperGradient,
            textColor: AppColors.ink,
            pulse: false,
            tilt: 0,
            expand: true,
            onPressed: _controller.nextQuestion,
          ),
        ],
        'Quem errou fica com a carta',
      ),
      GameStatus.finished => (
        [
          PlayButton(
            key: const ValueKey('again'),
            label: 'JOGAR DE NOVO',
            gradient: AppColors.actionGradient,
            textColor: AppColors.white,
            tilt: 0,
            expand: true,
            onPressed: _controller.start,
          ),
          const SizedBox(height: 16),
          back,
        ],
        'Mesmas escolhas, perguntas novas',
      ),
      GameStatus.outOfQuestions => ([back], ''),
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...buttons,
        const SizedBox(height: 14),
        Text(hint, style: TableTheme.of(context).hintStyle),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.round, required this.rounds});

  final int round;
  final int? rounds;

  @override
  Widget build(BuildContext context) {
    final total = rounds;
    final theme = TableTheme.of(context);
    return Row(
      children: [
        const RaisedBackButton(),
        const Spacer(),
        if (round > 0)
          RaisedBox(
            colors: theme.pill,
            radius: 999,
            borderWidth: 2,
            lipHeight: 3,
            lipColor: theme.pillLip,
            softShadow: false,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              total == null ? 'RODADA $round' : 'RODADA $round DE $total',
              style: AppTextStyles.pill.copyWith(color: theme.onPill),
            ),
          ),
        const Spacer(),
        // Balances the back button so the round pill stays centered.
        const SizedBox(width: 48),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = TableTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.category.copyWith(
            color: theme.onTable,
            fontSize: 26,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          textAlign: TextAlign.center,
          style: theme.hintStyle.copyWith(fontSize: 15),
        ),
      ],
    );
  }
}
