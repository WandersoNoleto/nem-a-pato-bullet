import 'package:flutter/material.dart';

import '../../app_dependencies.dart';
import '../../domain/deck.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/choice_pill.dart';
import '../widgets/deck_icon.dart';
import '../widgets/screen_header.dart';
import '../widgets/raised_box.dart';
import '../widgets/section_label.dart';
import '../widgets/table_scaffold.dart';

/// App settings: updates, language and deck import/export.
///
/// For now only the layout is real: the actions show what they will do and
/// get wired up one feature at a time.
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

  late final Future<List<Deck>> _decks = widget.dependencies.loadDecks();
  String _language = 'pt';

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return TableScaffold(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: ScreenHeader(title: 'CONFIGURAÇÕES'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const SectionLabel('ATUALIZAÇÕES'),
                _Panel(
                  children: [
                    _ActionRow(
                      icon: Icons.system_update_outlined,
                      title: 'Procurar atualização',
                      subtitle: 'Versão 1.0.0',
                      onTap: () =>
                          _showMessage('Você já está na versão mais recente.'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const SectionLabel('IDIOMA'),
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
                        selected: _language == language.code,
                        onTap: () => setState(() => _language = language.code),
                      ),
                  ],
                ),
                const SizedBox(height: 28),
                const SectionLabel('BARALHOS'),
                _Panel(
                  children: [
                    _ActionRow(
                      icon: Icons.file_download_outlined,
                      title: 'Importar baralho',
                      subtitle: 'Adicionar de um arquivo JSON',
                      onTap: () => _showMessage('Baralho importado.'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _ExportPanel(
                  decks: _decks,
                  onExport: (deck) =>
                      _showMessage('Baralho "${deck.name}" exportado.'),
                ),
              ],
            ),
          ),
        ],
      ),
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
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Row(
      leading: Icon(icon, size: 28, color: AppColors.ink),
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.chevron_right, color: AppColors.ink),
      onTap: onTap,
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
  final VoidCallback onTap;

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
                subtitle: deck.questions.length == 1
                    ? '1 pergunta'
                    : '${deck.questions.length} perguntas',
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
