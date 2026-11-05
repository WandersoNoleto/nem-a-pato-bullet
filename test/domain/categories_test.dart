import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/domain/categories.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';

void main() {
  final shared = Question.create(
    category: 'Oceano',
    text: 'Qual a maior onda?',
    answer: '24 m',
  );
  final a = Deck(
    name: 'A',
    questions: [
      shared,
      Question.create(category: 'Itália', text: 'Pontes?', answer: '400'),
    ],
  );
  final b = Deck(
    name: 'B',
    questions: [
      shared,
      Question.create(category: ' OCEANO ', text: 'Fundo?', answer: '11 km'),
    ],
  );

  test('lists each category once, keeping the first spelling', () {
    expect(categoriesOf([a, b]), [
      (key: 'itália', label: 'Itália'),
      (key: 'oceano', label: 'Oceano'),
    ]);
  });

  test('filters questions by category and drops duplicates', () {
    final questions = questionsIn([a, b], {'oceano'});

    expect(questions.map((q) => q.text), ['Qual a maior onda?', 'Fundo?']);
  });

  test('search ignores case and extra spaces', () {
    const ocean = (key: 'oceano', label: 'Oceano');

    expect(categoryMatches(ocean, ' OCE '), isTrue);
    expect(categoryMatches(ocean, ''), isTrue);
    expect(categoryMatches(ocean, 'mar'), isFalse);
  });
}
