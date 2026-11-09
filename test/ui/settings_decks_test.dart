import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/app_dependencies.dart';
import 'package:nem_a_pato_bullet/data/deck_files.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';
import 'package:nem_a_pato_bullet/l10n/l10n.dart';
import 'package:nem_a_pato_bullet/state/language_controller.dart';
import 'package:nem_a_pato_bullet/state/seen_questions.dart';
import 'package:nem_a_pato_bullet/state/theme_controller.dart';
import 'package:nem_a_pato_bullet/ui/screens/settings_screen.dart';
import 'package:nem_a_pato_bullet/ui/theme/table_theme.dart';

class _FakeFiles extends DeckFiles {
  _FakeFiles({this.picked, this.saves = true});

  final String? picked;
  final bool saves;
  String? savedName;
  String? savedContent;

  @override
  Future<String?> pick() async => picked;

  @override
  Future<bool> save({required String fileName, required String content}) async {
    savedName = fileName;
    savedContent = content;
    return saves;
  }
}

const _validDeck =
    '{"name": "Novo", "questions": '
    '[{"category": "Teste", "text": "Quanto?", "answer": "1"}]}';

Future<void> _pumpSettings(
  WidgetTester tester,
  DeckFiles files, {
  List<Deck>? decks,
}) async {
  final library = decks ?? <Deck>[];
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(extensions: const [TableTheme.dark]),
      home: SettingsScreen(
        dependencies: AppDependencies(
          loadDecks: () async => List.of(library),
          importDeck: (source) async {
            final deck = Deck.fromJsonString(source);
            library.add(deck);
            return deck;
          },
          deckFiles: files,
          language: LanguageController(code: 'pt', save: (_) async {}),
          theme: ThemeController(theme: AppTheme.light, save: (_) async {}),
          seen: SeenQuestions(),
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('importing adds the deck to the list', (tester) async {
    await _pumpSettings(tester, _FakeFiles(picked: _validDeck));
    expect(find.text('Novo'), findsNothing);

    await tester.tap(find.text('Importar baralho'));
    await _settle(tester);

    expect(find.text('Novo'), findsOneWidget);
    expect(
      find.text('Baralho "Novo" importado com 1 pergunta.'),
      findsOneWidget,
    );
  });

  testWidgets('an invalid file shows a message', (tester) async {
    await _pumpSettings(tester, _FakeFiles(picked: 'not a deck'));

    await tester.tap(find.text('Importar baralho'));
    await _settle(tester);

    expect(find.text('Esse arquivo não é um baralho válido.'), findsOneWidget);
  });

  testWidgets('canceling the file choice does nothing', (tester) async {
    await _pumpSettings(tester, _FakeFiles());

    await tester.tap(find.text('Importar baralho'));
    await _settle(tester);

    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('tapping a deck exports it as JSON', (tester) async {
    final files = _FakeFiles();
    final deck = Deck(
      name: 'Espaço',
      questions: [
        Question.create(category: 'Luas', text: 'Quantas?', answer: '2'),
      ],
    );
    await _pumpSettings(tester, files, decks: [deck]);

    await tester.tap(find.text('Espaço'));
    await _settle(tester);

    expect(files.savedName, 'espaco.json');
    expect(
      Deck.fromJsonString(files.savedContent!).questions.single.answer,
      '2',
    );
    expect(find.text('Baralho "Espaço" exportado.'), findsOneWidget);
  });

  testWidgets('canceling the export shows no message', (tester) async {
    final deck = Deck(
      name: 'Espaço',
      questions: [
        Question.create(category: 'Luas', text: 'Quantas?', answer: '2'),
      ],
    );
    await _pumpSettings(tester, _FakeFiles(saves: false), decks: [deck]);

    await tester.tap(find.text('Espaço'));
    await _settle(tester);

    expect(find.byType(SnackBar), findsNothing);
  });
}
