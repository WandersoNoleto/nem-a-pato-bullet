import 'package:flutter/material.dart';

import '../../app_dependencies.dart';
import '../../data/deck_files.dart';
import '../../domain/deck.dart';
import '../../l10n/l10n.dart';
import '../../update/app_updates.dart';
import '../../update/update_checker.dart';
import '../../update/update_prompt.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/choice_pill.dart';
import '../widgets/deck_icon.dart';
import '../widgets/screen_header.dart';
import '../widgets/raised_box.dart';
import '../widgets/section_label.dart';
import '../widgets/table_scaffold.dart';

/// App settings: updates, language and deck import/export.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _languages = [
    (code: 'pt', name: 'Português', flag: '🇧🇷'),
    (code: 'en', name: 'English', flag: '🇺🇸'),
  ];

  late Future<List<Deck>> _decks = widget.dependencies.loadDecks();
  bool _importing = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _importDeck() async {
    setState(() => _importing = true);
    try {
      final source = await widget.dependencies.deckFiles.pick();
      if (source == null) return;
      final deck = await widget.dependencies.importDeck(source);
      if (!mounted) return;
      _showMessage(context.l10n.deckImported(deck.name, deck.questions.length));
      setState(() {
        _decks = widget.dependencies.loadDecks();
      });
    } on FormatException catch (error) {
      debugPrint('Invalid deck file: ${error.message}');
      if (mounted) _showMessage(context.l10n.invalidDeckFile);
    } on Exception catch (error) {
      debugPrint('Could not import deck: $error');
      if (mounted) _showMessage(context.l10n.importFailed);
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Future<void> _exportDeck(Deck deck) async {
    try {
      final saved = await widget.dependencies.deckFiles.save(
        fileName: deckFileName(deck.name),
        content: deck.toJsonString(),
      );
      if (saved && mounted) _showMessage(context.l10n.deckExported(deck.name));
    } on Exception catch (error) {
      debugPrint('Could not export deck: $error');
      if (mounted) _showMessage(context.l10n.exportFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final updates = widget.dependencies.updates;
    final selectedLanguage = Localizations.localeOf(context).languageCode;
    return TableScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: ScreenHeader(title: context.l10n.settingsTitle),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                if (updates != null) ...[
                  SectionLabel(context.l10n.updatesSection),
                  _UpdatePanel(updates: updates, onMessage: _showMessage),
                  const SizedBox(height: 28),
                ],
                SectionLabel(context.l10n.languageSection),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final language in _languages)
                      ChoicePill(
                        label: language.name,
                        leading: Text(
                          language.flag,
                          style: const TextStyle(fontSize: 18, height: 1),
                        ),
                        selected: selectedLanguage == language.code,
                        onTap: () =>
                            widget.dependencies.language.setCode(language.code),
                      ),
                  ],
                ),
                const SizedBox(height: 28),
                SectionLabel(context.l10n.decksSection),
                _Panel(
                  children: [
                    _ActionRow(
                      icon: Icons.file_download_outlined,
                      title: context.l10n.importDeck,
                      subtitle: context.l10n.importDeckHint,
                      busy: _importing,
                      onTap: _importDeck,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _ExportPanel(decks: _decks, onExport: _exportDeck),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Installed version and the manual check for a newer release.
class _UpdatePanel extends StatefulWidget {
  const _UpdatePanel({required this.updates, required this.onMessage});

  final AppUpdates updates;
  final ValueChanged<String> onMessage;

  @override
  State<_UpdatePanel> createState() => _UpdatePanelState();
}

class _UpdatePanelState extends State<_UpdatePanel> {
  late final Future<InstalledVersion> _installed = widget.updates.checker
      .installedVersion();
  bool _checking = false;

  Future<void> _check() async {
    setState(() => _checking = true);
    try {
      final update = await widget.updates.checker.check();
      if (!mounted) return;
      if (update == null) {
        widget.onMessage(context.l10n.upToDate);
      } else {
        await showUpdateDialog(
          context,
          update: update,
          installer: widget.updates.installer,
        );
      }
    } on UpdateCheckException {
      if (mounted) {
        widget.onMessage(context.l10n.updateCheckFailed);
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InstalledVersion>(
      future: _installed,
      builder: (context, snapshot) {
        final version = snapshot.data?.name;
        return _Panel(
          children: [
            _ActionRow(
              icon: Icons.system_update_outlined,
              title: context.l10n.checkForUpdates,
              subtitle: _checking
                  ? context.l10n.checkingForUpdates
                  : version == null
                  ? null
                  : context.l10n.versionLabel(version),
              busy: _checking,
              onTap: _check,
            ),
          ],
        );
      },
    );
  }
}

/// Cream box that groups rows, like a card on the table.
class _Panel extends StatelessWidget {
  const _Panel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RaisedBox(
      colors: AppColors.paperGradient,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, child) in children.indexed) ...[
                if (index > 0)
                  const Divider(
                    height: 1.5,
                    thickness: 1.5,
                    color: AppColors.cardDivider,
                  ),
                child,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.busy = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  /// Shows a spinner and ignores taps while the action runs.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return _Row(
      leading: Icon(icon, size: 28, color: AppColors.ink),
      title: title,
      subtitle: subtitle,
      trailing: busy
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.ink,
              ),
            )
          : const Icon(Icons.chevron_right, color: AppColors.ink),
      onTap: busy ? null : onTap,
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.leading,
    required this.title,
    required this.trailing,
    required this.onTap,
    this.subtitle,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.credits.copyWith(fontSize: 15),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: AppTextStyles.credits.copyWith(
                        color: AppColors.cardMuted,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }
}

/// One export row per deck.
class _ExportPanel extends StatelessWidget {
  const _ExportPanel({required this.decks, required this.onExport});

  final Future<List<Deck>> decks;
  final ValueChanged<Deck> onExport;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Deck>>(
      future: decks,
      builder: (context, snapshot) {
        final decks = snapshot.data;
        if (decks == null || decks.isEmpty) return const SizedBox.shrink();
        return _Panel(
          children: [
            for (final deck in decks)
              _Row(
                leading: DeckIcon(deck: deck, size: 28),
                title: deck.name,
                subtitle: context.l10n.questionCount(deck.questions.length),
                trailing: const Icon(
                  Icons.ios_share,
                  size: 22,
                  color: AppColors.ink,
                ),
                onTap: () => onExport(deck),
              ),
          ],
        );
      },
    );
  }
}
