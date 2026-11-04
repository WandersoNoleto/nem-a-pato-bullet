import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/credits_text.dart';
import '../widgets/game_title.dart';
import '../widgets/play_button.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _play(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const GameScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellow,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Title and mascot are kept a bit smaller and high on the
              // screen, leaving room to breathe around the play button.
              const FractionallySizedBox(
                widthFactor: 0.75,
                child: GameTitle(),
              ),
              const SizedBox(height: 12),
              Expanded(
                flex: 5,
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Image.asset(
                    'assets/images/mascot.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              PlayButton(label: 'JOGAR', onPressed: () => _play(context)),
              const Spacer(),
              const CreditsText(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
