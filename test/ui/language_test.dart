import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/app.dart';
import 'package:nem_a_pato_bullet/app_dependencies.dart';
import 'package:nem_a_pato_bullet/data/deck_files.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';
import 'package:nem_a_pato_bullet/state/language_controller.dart';
import 'package:nem_a_pato_bullet/state/seen_questions.dart';
import 'package:nem_a_pato_bullet/ui/screens/loading_screen.dart';

const _transition = Duration(milliseconds: 500);

final _deck = Deck(
  name: 'Baralho em Português',
  questions: [
    Question.create(
      category: 'Oceano',
      text: 'Qual a altura da maior onda?',
      answer: '24 metros',
      fact: 'Surfada em Nazaré.',
    ),
  ],
);

Future<void> _openHome(WidgetTester tester, LanguageController language) async {
  await tester.pumpWidget(
    NemAPatoApp(
      dependencies: AppDependencies(
        loadDecks: () async => [_deck],
        importDeck: (source) async => Deck.fromJsonString(source),
        deckFiles: const DeckFiles(),
        language: language,
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
}

Future<void> _tapAndWait(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pump();
  await tester.pump(_transition);
  await tester.pump(_transition);
}

void main() {
  test('both languages have the same texts', () {
    Set<String> keys(String path) =>
        (jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>).keys
            .where((key) => !key.startsWith('@'))
            .toSet();

    expect(keys('lib/l10n/app_en.arb'), keys('lib/l10n/app_pt.arb'));
  });

  testWidgets('choosing a language changes the app and is saved', (
    tester,
  ) async {
    final saved = <String>[];
    final language = LanguageController(
      code: 'pt',
      save: (code) async => saved.add(code),
    );
    await _openHome(tester, language);
    expect(find.text('JOGAR'), findsOneWidget);

    await _tapAndWait(tester, find.byTooltip('Configurações'));
    expect(find.text('CONFIGURAÇÕES'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pump();

    expect(find.text('SETTINGS'), findsOneWidget);
    expect(find.text('CONFIGURAÇÕES'), findsNothing);
    expect(saved, ['en']);

    await _tapAndWait(tester, find.byTooltip('Back'));
    expect(find.text('PLAY'), findsOneWidget);
  });

  testWidgets('deck content stays exactly as written in any language', (
    tester,
  ) async {
    await _openHome(tester, LanguageController(code: 'en', save: (_) async {}));

    await _tapAndWait(tester, find.text('PLAY'));
    expect(find.text('GAME SETUP'), findsOneWidget);
    expect(find.text('Baralho em Português'), findsOneWidget);
    expect(find.text('Oceano'), findsOneWidget);

    await _tapAndWait(tester, find.text('START'));
    expect(find.text('ROUND 1'), findsOneWidget);
    expect(find.text('Qual a altura da maior onda?'), findsOneWidget);
    expect(find.text('OCEANO'), findsOneWidget);

    await _tapAndWait(tester, find.text('NEM A PATO!'));
    expect(find.text('ANSWER'), findsOneWidget);
    expect(find.text('24 metros'), findsOneWidget);
    expect(find.text('Surfada em Nazaré.'), findsOneWidget);
  });
}
