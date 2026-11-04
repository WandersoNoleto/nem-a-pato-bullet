import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/deck.dart';
import '../../state/game_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/play_button.dart';
import '../widgets/question_card.dart';

const _sampleDeckAsset = 'assets/decks/sample.json';

Future<Deck> _loadSampleDeck() async =>
    Deck.fromJsonString(await rootBundle.loadString(_sampleDeckAsset));

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _controller = GameController(loadDeck: _loadSampleDeck);

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
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => Column(
              children: [
                _TopBar(round: _controller.round),
                Expanded(child: Center(child: _buildCenter())),
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenter() {
    final question = _controller.current;
    return switch (_controller.status) {
      GameStatus.loading => const CircularProgressIndicator(
        color: AppColors.yellow,
      ),
      GameStatus.error => const _Message(
        title: 'Não deu para carregar as perguntas',
        body: 'Confira o arquivo do baralho e tente de novo.',
      ),
      GameStatus.outOfQuestions => const _Message(
        title: 'Acabaram as perguntas!',
        body: 'Todas as perguntas deste baralho já saíram.',
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
    final (button, hint) = switch (_controller.status) {
      GameStatus.question => (
        PlayButton(
          key: const ValueKey('reveal'),
          label: 'NEM A PATO!',
          color: AppColors.yellow,
          textColor: AppColors.ink,
          tilt: 0,
          expand: true,
          onPressed: _controller.reveal,
        ),
        'Gritou? Toque para revelar',
      ),
      GameStatus.revealed => (
        PlayButton(
          key: const ValueKey('next'),
          label: 'PRÓXIMA',
          color: AppColors.cream,
          textColor: AppColors.ink,
          pulse: false,
          tilt: 0,
          expand: true,
          onPressed: _controller.nextQuestion,
        ),
        'Quem errou fica com a carta',
      ),
      GameStatus.outOfQuestions || GameStatus.error => (
        PlayButton(
          key: const ValueKey('back'),
          label: 'VOLTAR',
          color: AppColors.cream,
          textColor: AppColors.ink,
          pulse: false,
          tilt: 0,
          expand: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
        '',
      ),
      GameStatus.loading => (const SizedBox.shrink(), ''),
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button,
        const SizedBox(height: 14),
        Text(hint, style: AppTextStyles.hint),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.round});

  final int round;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Voltar',
          style: IconButton.styleFrom(
            foregroundColor: AppColors.cream,
            side: const BorderSide(color: AppColors.cream, width: 2),
          ),
          icon: const Icon(Icons.arrow_back),
        ),
        const Spacer(),
        if (round > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.ink, width: 2),
            ),
            child: Text('RODADA $round', style: AppTextStyles.pill),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.category.copyWith(
            color: AppColors.yellow,
            fontSize: 26,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          textAlign: TextAlign.center,
          style: AppTextStyles.hint.copyWith(fontSize: 15),
        ),
      ],
    );
  }
}
