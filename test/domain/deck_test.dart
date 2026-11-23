import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';

void main() {
  group('Deck.fromJson', () {
    test('parses name and questions', () {
      final deck = Deck.fromJson({
        'name': 'Teste',
        'questions': [
          {
            'category': 'Oceano',
            'text': 'Qual a maior onda?',
            'answer': '24 m',
            'fact': 'Nazaré, 2020.',
          },
          {'category': 'Corpo', 'text': 'Quantos ossos?', 'answer': '206'},
        ],
      });

      expect(deck.name, 'Teste');
      expect(deck.questions, hasLength(2));
      expect(deck.questions.first.answer, '24 m');
      expect(deck.questions.first.fact, 'Nazaré, 2020.');
      expect(deck.questions.last.fact, isNull);
    });

    test('accepts a numeric answer as text', () {
      final deck = Deck.fromJson({
        'name': 'Teste',
        'questions': [
          {'category': 'Corpo', 'text': 'Quantos ossos?', 'answer': 206},
        ],
      });
      expect(deck.questions.single.answer, '206');
    });

    test('drops questions repeated in the same deck', () {
      final deck = Deck.fromJson({
        'name': 'Teste',
        'questions': [
          {'category': 'Corpo', 'text': 'Quantos ossos?', 'answer': '206'},
          {'category': 'corpo', 'text': 'Quantos  ossos?', 'answer': '207'},
        ],
      });
      expect(deck.questions.single.answer, '206');
    });

    test('reads an optional inline SVG icon', () {
      const svg = '<svg viewBox="0 0 24 24"><circle r="4"/></svg>';
      final withIcon = Deck.fromJson({
        'name': 'Teste',
        'icon': svg,
        'questions': [],
      });
      final withoutIcon = Deck.fromJson({'name': 'Teste', 'questions': []});

      expect(withIcon.iconSvg, svg);
      expect(withoutIcon.iconSvg, isNull);
    });

    test('rejects an icon that is not an SVG', () {
      expect(
        () => Deck.fromJson({
          'name': 'Teste',
          'icon': 'rocket.png',
          'questions': [],
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects a deck without a name', () {
      expect(
        () => Deck.fromJson({'questions': []}),
        throwsA(isA<FormatException>()),
      );
    });

    test('names the invalid question', () {
      expect(
        () => Deck.fromJson({
          'name': 'Teste',
          'questions': [
            {'category': 'Corpo', 'text': 'Quantos ossos?', 'answer': '206'},
            {'category': 'Corpo', 'text': 'Sem resposta'},
          ],
        }),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('Question 1 is missing "answer"'),
          ),
        ),
      );
    });
  });

  test('the bundled sample deck is valid', () {
    final source = File('assets/decks/sample.json').readAsStringSync();
    final deck = Deck.fromJsonString(source);
    expect(deck.questions, isNotEmpty);
  });

  test('the demo decks are valid and complete', () {
    final folders = Directory('decks/demo').listSync().whereType<Directory>();
    expect(folders, isNotEmpty);
    for (final folder in folders) {
      // One folder per demo, named after its language: decks/demo/pt-BR/.
      final locale = folder.path.split(Platform.pathSeparator).last;
      final files = folder.listSync().whereType<File>();
      expect(files, isNotEmpty, reason: '${folder.path} has no decks');
      for (final file in files) {
        final deck = Deck.fromJsonString(file.readAsStringSync());
        expect(deck.iconSvg, isNotNull, reason: '${file.path} has no icon');
        expect(deck.language, locale, reason: '${file.path} language');
        for (final question in deck.questions) {
          expect(question.fact, isNotNull, reason: question.text);
        }
      }
    }
  });

  test('origin is not saved in the JSON', () {
    final deck = Deck(
      name: 'Amostra',
      questions: [Question.create(category: 'A', text: 'q', answer: '1')],
    ).withOrigin(DeckOrigin.app);

    final copy = Deck.fromJsonString(deck.toJsonString());

    expect(deck.origin, DeckOrigin.app);
    expect(deck.questions, hasLength(1));
    expect(copy.origin, DeckOrigin.imported);
    expect(deck.toJsonString(), isNot(contains('origin')));
  });

  test('reads the language, writes it back and keeps it with the origin', () {
    final deck = Deck.fromJsonString(
      '{"name": "Mar", "language": "pt-br", "questions": '
      '[{"category": "A", "text": "q", "answer": "1"}]}',
    );

    expect(deck.language, 'pt-BR');
    expect(Deck.fromJsonString(deck.toJsonString()).language, 'pt-BR');
    expect(deck.withOrigin(DeckOrigin.app).language, 'pt-BR');
  });

  test('a deck without language has none', () {
    final deck = Deck.fromJsonString(
      '{"name": "Mar", "questions": '
      '[{"category": "A", "text": "q", "answer": "1"}]}',
    );

    expect(deck.language, isNull);
    expect(deck.toJsonString(), isNot(contains('language')));
  });

  test('rejects a language that is not a code', () {
    for (final language in ['"português"', '42', '""']) {
      expect(
        () => Deck.fromJsonString(
          '{"name": "Mar", "language": $language, "questions": '
          '[{"category": "A", "text": "q", "answer": "1"}]}',
        ),
        throwsFormatException,
        reason: language,
      );
    }
  });
}
