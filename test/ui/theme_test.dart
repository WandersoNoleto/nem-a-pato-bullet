import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/app.dart';
import 'package:nem_a_pato_bullet/app_dependencies.dart';
import 'package:nem_a_pato_bullet/data/deck_files.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/state/language_controller.dart';
import 'package:nem_a_pato_bullet/state/seen_questions.dart';
import 'package:nem_a_pato_bullet/state/theme_controller.dart';
import 'package:nem_a_pato_bullet/ui/screens/loading_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/settings_screen.dart';
import 'package:nem_a_pato_bullet/ui/theme/table_theme.dart';

const _transition = Duration(milliseconds: 500);

void main() {
  testWidgets('choosing a theme switches the app and is saved', (tester) async {
    final saved = <AppTheme>[];
    final theme = ThemeController(
      theme: AppTheme.light,
      save: (theme) async => saved.add(theme),
    );
    await tester.pumpWidget(
      NemAPatoApp(
        dependencies: AppDependencies(
          loadDecks: () async => const [],
          importDeck: (source) async => Deck.fromJsonString(source),
          deckFiles: const DeckFiles(),
          language: LanguageController(code: 'pt', save: (_) async {}),
          theme: theme,
          seen: SeenQuestions(),
        ),
      ),
    );
    // The play button pulses forever, so step frames instead of settling.
    for (
      var i = 0;
      i < 80 && find.byType(LoadingScreen).evaluate().isNotEmpty;
      i++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.tap(find.byTooltip('Configurações'));
    await tester.pump();
    await tester.pump(_transition);

    TableTheme current() =>
        TableTheme.of(tester.element(find.byType(SettingsScreen)));
    expect(current().brightness, Brightness.light);

    await tester.tap(find.text('Escuro'));
    await tester.pump();
    // The theme change animates.
    await tester.pump(_transition);

    expect(current().brightness, Brightness.dark);
    expect(saved, [AppTheme.dark]);
  });
}
