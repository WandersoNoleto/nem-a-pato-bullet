import 'dart:math';

import 'package:flutter/foundation.dart';

import '../domain/question.dart';
import '../domain/question_draw.dart';
import 'seen_questions.dart';

enum GameStatus { question, revealed, outOfQuestions, finished }

/// Drives a game session: draws unseen questions, counts rounds and reveals
/// answers. Who takes the card is decided at the table, not here.
class GameController extends ChangeNotifier {
  GameController({
    required List<Question> questions,
    required SeenQuestions seen,
    this.rounds,
    Random? random,
  }) : _questions = questions,
       _seen = seen,
       _random = random ?? Random();

  final List<Question> _questions;
  final SeenQuestions _seen;
  final Random _random;

  /// Number of rounds in the game; null means infinite.
  final int? rounds;

  Question? _current;
  int _round = 0;
  GameStatus _status = GameStatus.question;

  GameStatus get status => _status;
  Question? get current => _current;
  int get round => _round;

  void start() {
    _round = 0;
    nextQuestion();
  }

  void reveal() {
    if (_status != GameStatus.question) return;
    _status = GameStatus.revealed;
    notifyListeners();
  }

  void nextQuestion() {
    final limit = rounds;
    if (limit != null && _round >= limit) {
      _status = GameStatus.finished;
      notifyListeners();
      return;
    }
    final question = drawUnseenQuestion(_questions, _seen.ids, random: _random);
    if (question == null) {
      _status = GameStatus.outOfQuestions;
    } else {
      _seen.add(question.id);
      _current = question;
      _round++;
      _status = GameStatus.question;
    }
    notifyListeners();
  }
}
