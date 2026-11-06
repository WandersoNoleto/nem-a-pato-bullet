import 'dart:convert';

import 'question.dart';

/// A named list of questions loaded from a JSON deck file.
class Deck {
  const Deck({required this.name, required this.questions, this.iconSvg});

  /// Parses a deck in the format:
  ///
  /// ```json
  /// {
  ///   "name": "Sample deck",
  ///   "icon": "<svg ...>...</svg>",
  ///   "questions": [
  ///     { "category": "Oceano", "text": "...", "answer": "24 m", "fact": "..." }
  ///   ]
  /// }
  /// ```
  ///
  /// `icon` (an inline SVG) and `fact` are optional. A numeric `answer` is
  /// accepted and shown as text.
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
    final icon = json['icon'];
    if (icon != null && (icon is! String || !icon.contains('<svg'))) {
      throw const FormatException('Deck "icon" must be an inline SVG');
    }

    final seenIds = <String>{};
    final questions = <Question>[];
    for (final (index, raw) in rawQuestions.indexed) {
      final question = _parseQuestion(raw, index);
      if (seenIds.add(question.id)) questions.add(question);
    }
    return Deck(
      name: name.trim(),
      questions: List.unmodifiable(questions),
      iconSvg: icon as String?,
    );
  }

  factory Deck.fromJsonString(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Deck must be a JSON object');
    }
    return Deck.fromJson(decoded);
  }

  /// The deck in the same format [Deck.fromJson] reads.
  String toJsonString() {
    return const JsonEncoder.withIndent('  ').convert({
      'name': name,
      if (iconSvg != null) 'icon': iconSvg,
      'questions': [
        for (final question in questions)
          {
            'category': question.category,
            'text': question.text,
            'answer': question.answer,
            if (question.fact != null) 'fact': question.fact,
          },
      ],
    });
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

  /// The deck's symbol as inline SVG; null shows the default card symbol.
  final String? iconSvg;
}
