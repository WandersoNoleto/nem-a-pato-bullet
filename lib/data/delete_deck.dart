import '../domain/deck.dart';
import '../state/seen_questions.dart';
import 'imported_decks.dart';

/// Removes an imported [deck] and lets its cards come up again.
///
/// Cards that are also in a deck that stays, like the app's deck that an
/// imported one replaced, keep their history. [loadDecks] lists the decks
/// left after the removal.
Future<void> deleteDeck(
  Deck deck, {
  required ImportedDecks imported,
  required SeenQuestions seen,
  required Future<List<Deck>> Function() loadDecks,
}) async {
  if (deck.origin == DeckOrigin.app) {
    throw ArgumentError.value(deck.name, 'deck', 'ships with the app');
  }
  await imported.delete(deck.name);
  final remaining = {
    for (final other in await loadDecks())
      for (final question in other.questions) question.id,
  };
  seen.removeAll([
    for (final question in deck.questions)
      if (!remaining.contains(question.id)) question.id,
  ]);
}
