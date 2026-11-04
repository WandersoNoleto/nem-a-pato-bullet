import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';

void main() {
  group('Question.idFor', () {
    test('is stable for the same category and text', () {
      expect(
        Question.idFor(category: 'Oceano', text: 'Qual a maior onda?'),
        Question.idFor(category: 'Oceano', text: 'Qual a maior onda?'),
      );
    });

    test('ignores case and extra whitespace', () {
      expect(
        Question.idFor(category: ' oceano ', text: 'Qual a   maior onda?'),
        Question.idFor(category: 'Oceano', text: 'Qual a maior onda?'),
      );
    });

    test('changes when the question text changes', () {
      expect(
        Question.idFor(category: 'Oceano', text: 'Qual a maior onda?'),
        isNot(Question.idFor(category: 'Oceano', text: 'Qual a menor onda?')),
      );
    });

    test('changes when the category changes', () {
      expect(
        Question.idFor(category: 'Oceano', text: 'Qual a maior onda?'),
        isNot(Question.idFor(category: 'Surfe', text: 'Qual a maior onda?')),
      );
    });
  });

  group('Question.create', () {
    test('keeps the id when only the answer or fact changes', () {
      final original = Question.create(
        category: 'Oceano',
        text: 'Qual a maior onda?',
        answer: '24 m',
      );
      final fixed = Question.create(
        category: 'Oceano',
        text: 'Qual a maior onda?',
        answer: '26 m',
        fact: 'Nazaré, 2020.',
      );
      expect(fixed.id, original.id);
    });

    test('treats a blank fact as no fact', () {
      final question = Question.create(
        category: 'Oceano',
        text: 'Qual a maior onda?',
        answer: '24 m',
        fact: '   ',
      );
      expect(question.fact, isNull);
    });
  });
}
