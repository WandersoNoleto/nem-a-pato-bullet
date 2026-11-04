import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';
import 'package:nem_a_pato_bullet/domain/question_draw.dart';

void main() {
  final questions = [
    for (var i = 0; i < 5; i++)
      Question.create(category: 'Teste', text: 'Pergunta $i', answer: '$i'),
  ];

  test('never returns a question that was already seen', () {
    final seen = {questions[0].id, questions[1].id, questions[2].id};
    for (var seed = 0; seed < 50; seed++) {
      final drawn = drawUnseenQuestion(questions, seen, random: Random(seed));
      expect(seen, isNot(contains(drawn!.id)));
    }
  });

  test('draws every question once before running out', () {
    final seen = <String>{};
    final random = Random(42);
    for (var i = 0; i < questions.length; i++) {
      final drawn = drawUnseenQuestion(questions, seen, random: random)!;
      expect(seen.add(drawn.id), isTrue);
    }
    expect(drawUnseenQuestion(questions, seen, random: random), isNull);
  });

  test('returns null for an empty deck', () {
    expect(drawUnseenQuestion(const [], {}), isNull);
  });
}
