import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';
import 'package:nem_a_pato_bullet/state/game_controller.dart';

GameController _controllerWith(int questionCount) {
  final deck = Deck(
    name: 'Teste',
    questions: [
      for (var i = 0; i < questionCount; i++)
        Question.create(category: 'Teste', text: 'Pergunta $i', answer: '$i'),
    ],
  );
  return GameController(loadDeck: () async => deck, random: Random(1));
}

void main() {
  test('starts on round 1 with a question', () async {
    final controller = _controllerWith(3);
    await controller.start();

    expect(controller.status, GameStatus.question);
    expect(controller.round, 1);
    expect(controller.current, isNotNull);
  });

  test('reveal shows the answer of the current question', () async {
    final controller = _controllerWith(3);
    await controller.start();
    final question = controller.current;

    controller.reveal();

    expect(controller.status, GameStatus.revealed);
    expect(controller.current, same(question));
  });

  test('next question advances the round without repeating', () async {
    final controller = _controllerWith(3);
    await controller.start();
    final seen = {controller.current!.id};

    controller
      ..reveal()
      ..nextQuestion();

    expect(controller.round, 2);
    expect(seen.add(controller.current!.id), isTrue);
  });

  test('runs out after every question was shown', () async {
    final controller = _controllerWith(2);
    await controller.start();
    controller.nextQuestion();

    controller.nextQuestion();

    expect(controller.status, GameStatus.outOfQuestions);
    expect(controller.round, 2);
  });

  test('reports an error when the deck cannot be loaded', () async {
    final controller = GameController(
      loadDeck: () async => throw const FormatException('bad deck'),
    );
    await controller.start();

    expect(controller.status, GameStatus.error);
  });
}
