import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/data/all_decks.dart';
import 'package:nem_a_pato_bullet/data/imported_decks.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';

Deck _appDeck(String name) => Deck(
  name: name,
  questions: [Question.create(category: 'App', text: 'q', answer: '1')],
  origin: DeckOrigin.app,
);

String _deckJson(String name) =>
    '{"name": "$name", "questions": '
    '[{"category": "Teste", "text": "Quanto?", "answer": "2"}]}';

void main() {
  late Directory folder;
  late ImportedDecks imported;

  setUp(() {
    folder = Directory.systemTemp.createTempSync('decks');
    imported = ImportedDecks(directory: () async => folder);
  });
  tearDown(() => folder.deleteSync(recursive: true));

  test('marks where each deck comes from, sorted by name', () async {
    await imported.save(_deckJson('Mar'));

    final decks = await loadAllDecks(
      imported,
      bundled: () async => [_appDeck('Amostra')],
    );

    expect(
      [for (final deck in decks) (deck.name, deck.origin)],
      [('Amostra', DeckOrigin.app), ('Mar', DeckOrigin.imported)],
    );
  });

  test('an imported deck with an app deck name replaces it', () async {
    await imported.save(_deckJson('amostra'));

    final decks = await loadAllDecks(
      imported,
      bundled: () async => [_appDeck('Amostra')],
    );

    expect(decks.single.origin, DeckOrigin.replacesApp);
    expect(decks.single.questions.single.answer, '2');
  });
}
