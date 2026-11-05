import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'text_key.dart';

/// A single trivia question whose answer is shown as written in the deck.
class Question {
  const Question({
    required this.id,
    required this.category,
    required this.text,
    required this.answer,
    this.fact,
  });

  /// Builds a question and derives its [id] from [category] and [text].
  factory Question.create({
    required String category,
    required String text,
    required String answer,
    String? fact,
  }) {
    final trimmedFact = fact?.trim();
    return Question(
      id: idFor(category: category, text: text),
      category: category.trim(),
      text: text.trim(),
      answer: answer.trim(),
      fact: (trimmedFact == null || trimmedFact.isEmpty) ? null : trimmedFact,
    );
  }

  /// Stable id: the same category and text always give the same id, so
  /// re-importing a deck keeps the history of seen questions. Editing the
  /// answer or the fact keeps the id; editing the question text changes it.
  static String idFor({required String category, required String text}) {
    final key = '${textKey(category)}\n${textKey(text)}';
    return sha1.convert(utf8.encode(key)).toString().substring(0, 16);
  }

  final String id;
  final String category;

  /// [category] as a comparison key; see [textKey].
  String get categoryKey => textKey(category);
  final String text;

  /// Shown exactly as written in the deck, e.g. "24 m" or "1.200.000".
  final String answer;
  final String? fact;
}
