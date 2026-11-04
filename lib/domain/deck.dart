import 'dart:convert';

import 'question.dart';

/// A named list of questions loaded from a JSON deck file.
class Deck {
  const Deck({required this.name, required this.questions});

  /// Parses a deck in the format:
  ///
  /// ```json
  /// {
  ///   "name": "Sample deck",
  ///   "questions": [
  ///     { "category": "Oceano", "text": "...", "answer": "24 m", "fact": "..." }
  ///   ]
  /// }
  /// ```
  ///
  /// `fact` is optional. A numeric `answer` is accepted and shown as text.
  /// Questions with the same id as an earlier one are dropped.
  /// Throws a [FormatException] naming the first invalid question.
  factory Deck.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    if (name is! String || name.trim().isEmpty) {
      throw const FormatException('Deck is missing a "name"');
    }
    final rawQuestions = json['questions'];
    if (rawQuestions is! List) {
      throw const FormatException('Deck is missing a "questions" list');
    }

    final seenIds = <String>{};
    final questions = <Question>[];
    for (final (index, raw) in rawQuestions.indexed) {
      final question = _parseQuestion(raw, index);
      if (seenIds.add(question.id)) questions.add(question);
    }
    return Deck(name: name.trim(), questions: List.unmodifiable(questions));
  }

  factory Deck.fromJsonString(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Deck must be a JSON object');
    }
    return Deck.fromJson(decoded);
  }

  static Question _parseQuestion(Object? raw, int index) {
    if (raw is! Map<String, dynamic>) {
      throw FormatException('Question $index is not an object');
    }
    String requiredText(String field) {
      final value = raw[field];
      final text = value is num ? value.toString() : value;
      if (text is! String || text.trim().isEmpty) {
        throw FormatException('Question $index is missing "$field"');
      }
      return text;
    }

    final fact = raw['fact'];
    if (fact != null && fact is! String) {
      throw FormatException('Question $index has a "fact" that is not text');
    }
    return Question.create(
      category: requiredText('category'),
      text: requiredText('text'),
      answer: requiredText('answer'),
      fact: fact as String?,
    );
  }

  final String name;
  final List<Question> questions;
}
