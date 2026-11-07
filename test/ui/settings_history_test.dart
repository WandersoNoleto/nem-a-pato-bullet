import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/app_dependencies.dart';
import 'package:nem_a_pato_bullet/data/deck_files.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/l10n/l10n.dart';
import 'package:nem_a_pato_bullet/state/language_controller.dart';
import 'package:nem_a_pato_bullet/state/seen_questions.dart';
import 'package:nem_a_pato_bullet/ui/screens/settings_screen.dart';
import 'package:nem_a_pato_bullet/ui/theme/table_theme.dart';

Future<void> _pumpSettings(WidgetTester tester, SeenQuestions seen) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(extensions: const [TableTheme.dark]),
      home: SettingsScreen(
        dependencies: AppDependencies(
          loadDecks: () async => const [],
          importDeck: (source) async => Deck.fromJsonString(source),
          deckFiles: const DeckFiles(),
          language: LanguageController(code: 'pt', save: (_) async {}),
          seen: seen,
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _tap(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  testWidgets('shows how many questions came up', (tester) async {
    await _pumpSettings(tester, SeenQuestions(initial: ['a', 'b', 'c']));

    expect(find.text('3 cartas fora do baralho por uso'), findsOneWidget);
  });

  testWidgets('resetting after confirming clears the history', (tester) async {
    final seen = SeenQuestions(initial: ['a', 'b']);
    await _pumpSettings(tester, seen);

    await _tap(tester, 'Devolver todas as cartas ao baralho');
    expect(find.text('Devolver todas as cartas ao baralho?'), findsOneWidget);
    await _tap(tester, 'Devolver');

    expect(seen.count, 0);
    expect(find.text('Nenhuma carta fora do baralho'), findsOneWidget);
    expect(
      find.text('Cartas devolvidas. Todas podem aparecer de novo.'),
      findsOneWidget,
    );
  });

  testWidgets('canceling keeps the history', (tester) async {
    final seen = SeenQuestions(initial: ['a', 'b']);
    await _pumpSettings(tester, seen);

    await _tap(tester, 'Devolver todas as cartas ao baralho');
    await _tap(tester, 'Cancelar');

    expect(seen.count, 2);
  });

  testWidgets('says so when nothing came up yet', (tester) async {
    await _pumpSettings(tester, SeenQuestions());

    await _tap(tester, 'Devolver todas as cartas ao baralho');

    expect(find.text('Devolver todas as cartas ao baralho?'), findsNothing);
    expect(find.text('Nenhuma carta fora do baralho.'), findsOneWidget);
  });
}
