import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/game_title.dart';

/// Placeholder until the home screen step.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.yellow,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: GameTitle(),
          ),
        ),
      ),
    );
  }
}
