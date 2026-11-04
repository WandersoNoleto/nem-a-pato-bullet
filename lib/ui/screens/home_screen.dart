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
  /// Set when a newer release was found; the version line then offers it.
  AvailableUpdate? _update;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOnStartup());
  }

  /// Silent check on startup: offline or GitHub errors are ignored.
  Future<void> _checkOnStartup() async {
    final updates = widget.updates;
    if (updates == null || !updates.checkOnStartup) return;
    try {
      final update = await updates.checker.check();
      if (update == null || !mounted) return;
      setState(() => _update = update);
      await _offerUpdate();
    } on UpdateCheckException {
      return;
    }
  }

  Future<void> _offerUpdate() async {
    final updates = widget.updates;
    final update = _update;
    if (updates == null || update == null) return;
    await showUpdateDialog(
      context,
      update: update,
      installer: updates.installer,
    );
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
              if (updates != null)
                _VersionLine(
                  updates: updates,
                  updateAvailable: _update != null,
                  onUpdate: _offerUpdate,
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Installed version, plus "Atualização disponível!" when a newer release
/// was found; tapping it opens the update dialog again.
class _VersionLine extends StatefulWidget {
  const _VersionLine({
    required this.updates,
    required this.updateAvailable,
    required this.onUpdate,
  });

  final AppUpdates updates;
  final bool updateAvailable;
  final VoidCallback onUpdate;

  @override
  State<_VersionLine> createState() => _VersionLineState();
}

class _VersionLineState extends State<_VersionLine> {
  late final Future<InstalledVersion> _installed = widget.updates.checker
      .installedVersion();

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.credits.copyWith(fontSize: 11);
    return FutureBuilder<InstalledVersion>(
      future: _installed,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox(height: 32);
        final version = 'v${snapshot.data!.name}';
        if (!widget.updateAvailable) {
          return SizedBox(
            height: 32,
            child: Center(child: Text(version, style: style)),
          );
        }
        return TextButton(
          onPressed: widget.onUpdate,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.ink,
            minimumSize: const Size(0, 32),
          ),
          child: Text.rich(
            TextSpan(
              text: '$version · ',
              children: const [
                TextSpan(
                  text: 'Atualização disponível!',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
            style: style,
          ),
        );
      },
    );
  }
}
