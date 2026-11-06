import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/data/deck_files.dart';
import 'package:nem_a_pato_bullet/data/imported_decks.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';

String _deckJson(String name, String answer) =>
    '{"name": "$name", "questions": '
    '[{"category": "Teste", "text": "Quanto?", "answer": "$answer"}]}';

void main() {
  late Directory folder;
  late ImportedDecks decks;

  setUp(() {
    folder = Directory.systemTemp.createTempSync('decks');
    decks = ImportedDecks(directory: () async => folder);
  });
  tearDown(() => folder.deleteSync(recursive: true));

  test('starts empty when nothing was imported', () async {
    folder.deleteSync(recursive: true);

    expect(await decks.load(), isEmpty);

    folder.createSync();
  });

  test('keeps imported decks', () async {
    await decks.save(_deckJson('Mar', '1'));
    await decks.save(_deckJson('Terra', '2'));

    final names = (await decks.load()).map((deck) => deck.name);

    expect(names, unorderedEquals(['Mar', 'Terra']));
  });

  test('a deck with the same name replaces the old one', () async {
    await decks.save(_deckJson('Mar', '1'));
    await decks.save(_deckJson(' MAR ', '2'));

    final loaded = await decks.load();

    expect(loaded.single.questions.single.answer, '2');
  });

  test('rejects invalid files without storing them', () async {
    await expectLater(decks.save('not json'), throwsFormatException);
    await expectLater(decks.save('{"name": "Sem"}'), throwsFormatException);
    await expectLater(
      decks.save('{"name": "Vazio", "questions": []}'),
      throwsFormatException,
    );

    expect(await decks.load(), isEmpty);
  });

  test('skips a stored file that became unreadable', () async {
    await decks.save(_deckJson('Mar', '1'));
    File('${folder.path}/broken.json').writeAsStringSync('oops');

    expect((await decks.load()).single.name, 'Mar');
  });

  test('an exported deck can be imported back unchanged', () {
    final original = Deck.fromJsonString(
      '{"name": "Mar", "icon": "<svg></svg>", "questions": ['
      '{"category": "Oceano", "text": "Fundo?", "answer": "11 km", '
      '"fact": "Marianas."}, '
      '{"category": "Peixes", "text": "Quantos?", "answer": "35 mil"}]}',
    );

    final copy = Deck.fromJsonString(original.toJsonString());

    expect(copy.name, 'Mar');
    expect(copy.iconSvg, '<svg></svg>');
    expect(copy.questions.first.fact, 'Marianas.');
    expect(copy.questions.last.fact, isNull);
    expect(copy.questions.first.id, original.questions.first.id);
  });

  test('builds plain file names from deck names', () {
    expect(deckFileName('Conhecimentos Gerais'), 'conhecimentos-gerais.json');
    expect(deckFileName('Espaço & Ciência!'), 'espaco-ciencia.json');
    expect(deckFileName('???'), 'baralho.json');
  });
}
