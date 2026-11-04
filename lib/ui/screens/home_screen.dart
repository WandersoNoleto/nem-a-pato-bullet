import 'package:flutter/material.dart';

import '../../update/app_updates.dart';
import '../../update/update_checker.dart';
import '../../update/update_prompt.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/credits_text.dart';
import '../widgets/game_title.dart';
import '../widgets/play_button.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.updates});

  /// Null hides the version line and skips update checks (tests).
  final AppUpdates? updates;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOnStartup());
  }

  /// Silent check on startup: offline or GitHub errors are ignored here
  /// (the version line has a manual check that reports them).
  Future<void> _checkOnStartup() async {
    final updates = widget.updates;
    if (updates == null || !updates.checkOnStartup) return;
    try {
      final update = await updates.checker.check();
      if (update == null || !mounted) return;
      await showUpdateDialog(
        context,
        update: update,
        installer: updates.installer,
      );
    } on UpdateCheckException {
      return;
    }
  }

  void _play() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const GameScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final updates = widget.updates;
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
              const FractionallySizedBox(widthFactor: 0.75, child: GameTitle()),
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
              PlayButton(label: 'JOGAR', onPressed: _play),
              const Spacer(),
              const CreditsText(),
              if (updates != null) _VersionLine(updates: updates),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Installed version and the manual "procurar atualização".
class _VersionLine extends StatefulWidget {
  const _VersionLine({required this.updates});

  final AppUpdates updates;

  @override
  State<_VersionLine> createState() => _VersionLineState();
}

class _VersionLineState extends State<_VersionLine> {
  late final Future<InstalledVersion> _installed = widget.updates.checker
      .installedVersion();
  bool _checking = false;

  Future<void> _check() async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _checking = true);
    try {
      final update = await widget.updates.checker.check();
      if (!mounted) return;
      if (update == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Você já está na versão mais recente.')),
        );
      } else {
        await showUpdateDialog(
          context,
          update: update,
          installer: widget.updates.installer,
        );
      }
    } on UpdateCheckException catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InstalledVersion>(
      future: _installed,
      builder: (context, snapshot) {
        final version = snapshot.hasData ? 'v${snapshot.data!.name} · ' : '';
        return TextButton(
          onPressed: _checking ? null : _check,
          style: TextButton.styleFrom(foregroundColor: AppColors.ink),
          child: Text(
            _checking
                ? 'Procurando atualização…'
                : '${version}procurar atualização',
            style: AppTextStyles.credits.copyWith(fontSize: 11),
          ),
        );
      },
    );
  }
}
