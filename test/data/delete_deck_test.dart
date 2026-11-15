import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/data/all_decks.dart';
import 'package:nem_a_pato_bullet/data/delete_deck.dart';
import 'package:nem_a_pato_bullet/data/imported_decks.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';
import 'package:nem_a_pato_bullet/state/seen_questions.dart';

final _shared = Question.create(category: 'Mar', text: 'Fundo?', answer: '1');
final _own = Question.create(category: 'Mar', text: 'Peixes?', answer: '2');

final _appDeck = Deck(
  name: 'Oceano',
  questions: [_shared],
  origin: DeckOrigin.app,
);

void main() {
  late Directory folder;
  late ImportedDecks imported;
  late SeenQuestions seen;

  Future<List<Deck>> loadDecks() =>
      loadAllDecks(imported, bundled: () async => [_appDeck]);

  Future<Deck> import(String name) async {
    await imported.save(
      Deck(name: name, questions: [_shared, _own]).toJsonString(),
    );
    return (await loadDecks()).firstWhere((deck) => deck.name == name);
  }

  setUp(() {
    folder = Directory.systemTemp.createTempSync('decks');
    imported = ImportedDecks(directory: () async => folder);
    seen = SeenQuestions(initial: [_shared.id, _own.id, 'other']);
  });
  tearDown(() => folder.deleteSync(recursive: true));

  test('removes the deck and lets its cards come up again', () async {
    final deck = await import('Meu');

    await deleteDeck(
      deck,
      imported: imported,
      seen: seen,
      loadDecks: loadDecks,
    );

    expect((await loadDecks()).map((deck) => deck.name), ['Oceano']);
    // The shared card is still in the app's deck, so it stays out.
    expect(seen.ids, {_shared.id, 'other'});
  });

  test('removing a replacing deck brings the app deck back', () async {
    final deck = await import('oceano');
    expect(deck.origin, DeckOrigin.replacesApp);

    await deleteDeck(
      deck,
      imported: imported,
      seen: seen,
      loadDecks: loadDecks,
    );

    final decks = await loadDecks();
    expect(decks.single.origin, DeckOrigin.app);
    expect(seen.ids, {_shared.id, 'other'});
  });

  test('refuses decks shipped in the app', () async {
    await expectLater(
      deleteDeck(
        _appDeck,
        imported: imported,
        seen: seen,
        loadDecks: loadDecks,
      ),
      throwsArgumentError,
    );

    expect(seen.count, 3);
  });
}
