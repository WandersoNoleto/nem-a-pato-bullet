import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';
import 'package:nem_a_pato_bullet/state/game_controller.dart';
import 'package:nem_a_pato_bullet/state/seen_questions.dart';

List<Question> _questions(int count) => [
  for (var i = 0; i < count; i++)
    Question.create(category: 'Teste', text: 'Pergunta $i', answer: '$i'),
];

GameController _controllerWith(
  int questionCount, {
  int? rounds,
  SeenQuestions? seen,
}) => GameController(
  questions: _questions(questionCount),
  seen: seen ?? SeenQuestions(),
  rounds: rounds,
  random: Random(1),
);

void main() {
  test('starts on round 1 with a question', () {
    final controller = _controllerWith(3)..start();

    expect(controller.status, GameStatus.question);
    expect(controller.round, 1);
    expect(controller.current, isNotNull);
  });

  test('reveal shows the answer of the current question', () {
    final controller = _controllerWith(3)..start();
    final question = controller.current;

    controller.reveal();

    expect(controller.status, GameStatus.revealed);
    expect(controller.current, same(question));
  });

  test('next question advances the round without repeating', () {
    final controller = _controllerWith(3)..start();
    final seen = {controller.current!.id};

    controller
      ..reveal()
      ..nextQuestion();

    expect(controller.round, 2);
    expect(seen.add(controller.current!.id), isTrue);
  });

  test('runs out after every question was shown', () {
    final controller = _controllerWith(2)
      ..start()
      ..nextQuestion();

    controller.nextQuestion();

    expect(controller.status, GameStatus.outOfQuestions);
    expect(controller.round, 2);
  });

  test('finishes after the chosen number of rounds', () {
    final controller = _controllerWith(10, rounds: 2)
      ..start()
      ..nextQuestion();

    controller.nextQuestion();

    expect(controller.status, GameStatus.finished);
    expect(controller.round, 2);
  });

  test('playing again restarts the rounds with new questions', () {
    final seen = SeenQuestions();
    final controller = _controllerWith(10, rounds: 2, seen: seen)
      ..start()
      ..nextQuestion()
      ..nextQuestion();
    final firstGame = Set.of(seen.ids);

    controller.start();

    expect(controller.status, GameStatus.question);
    expect(controller.round, 1);
    expect(firstGame, isNot(contains(controller.current!.id)));
  });

  test('never repeats questions seen in an earlier game', () {
    final seen = SeenQuestions();
    _controllerWith(2, seen: seen)
      ..start()
      ..nextQuestion();

    final secondGame = _controllerWith(2, seen: seen)..start();

    expect(secondGame.status, GameStatus.outOfQuestions);
  });
}
