import 'dart:math';

import 'question.dart';

/// Picks a random question that has never been shown before.
///
/// Returns `null` when every question in [questions] is already in [seenIds].
Question? drawUnseenQuestion(
  List<Question> questions,
  Set<String> seenIds, {
  Random? random,
}) {
  final unseen = [
    for (final question in questions)
      if (!seenIds.contains(question.id)) question,
  ];
  if (unseen.isEmpty) return null;
  return unseen[(random ?? Random()).nextInt(unseen.length)];
}
