import 'dart:math';

import 'package:flutter/foundation.dart';

import '../domain/deck.dart';
import '../domain/question.dart';
import '../domain/question_draw.dart';

enum GameStatus { loading, question, revealed, outOfQuestions, error }

/// Drives a game session: draws unseen questions, counts rounds and reveals
/// answers. Who takes the card is decided at the table, not here.
class GameController extends ChangeNotifier {
  GameController({required Future<Deck> Function() loadDeck, Random? random})
    : _loadDeck = loadDeck,
      _random = random ?? Random();

  final Future<Deck> Function() _loadDeck;
  final Random _random;

  // Kept in memory for now; persisted on the device in a later step.
  final Set<String> _seenIds = {};

  Deck? _deck;
  Question? _current;
  int _round = 0;
  GameStatus _status = GameStatus.loading;

  GameStatus get status => _status;
  Question? get current => _current;
  int get round => _round;

  Future<void> start() async {
    try {
      _deck = await _loadDeck();
    } on Exception catch (error) {
      debugPrint('Could not load deck: $error');
      _status = GameStatus.error;
      notifyListeners();
      return;
    }
    nextQuestion();
  }

  void reveal() {
    if (_status != GameStatus.question) return;
    _status = GameStatus.revealed;
    notifyListeners();
  }

  void nextQuestion() {
    final deck = _deck;
    if (deck == null) return;
    final question = drawUnseenQuestion(
      deck.questions,
      _seenIds,
      random: _random,
    );
    if (question == null) {
      _status = GameStatus.outOfQuestions;
    } else {
      _seenIds.add(question.id);
      _current = question;
      _round++;
      _status = GameStatus.question;
    }
    notifyListeners();
  }
}
