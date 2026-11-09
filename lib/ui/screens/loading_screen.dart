import 'package:flutter/material.dart';

import '../../app_dependencies.dart';
import '../widgets/credits_text.dart';
import '../widgets/game_title.dart';
import '../widgets/table_scaffold.dart';
import '../widgets/train_progress_bar.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key, required this.dependencies});

  static const duration = Duration(seconds: 5);

  /// Passed on to the home screen.
  final AppDependencies dependencies;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  late final Animation<double> _titleScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: LoadingScreen.duration,
    );
    // Linear: the train runs at a constant speed across the whole bar.
    _progress = _controller;
    _titleScale = Tween(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.12, curve: Curves.easeOutBack),
      ),
    );
    _controller
      ..addStatusListener(_onStatus)
      ..forward();
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, _, _) => HomeScreen(dependencies: widget.dependencies),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TableScaffold(
      child: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ScaleTransition(
              scale: _titleScale,
              child: const GameTitle(),
            ),
          ),
          const SizedBox(height: 32),
          const CreditsText(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedBuilder(
              animation: _progress,
              builder: (context, _) =>
                  TrainProgressBar(progress: _progress.value),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
