import 'deck.dart';
import 'question.dart';
import 'text_key.dart';

/// A category as shown to players, merged across decks by its [key].
typedef DeckCategory = ({String key, String label});

/// Every category in [decks], once each, sorted by name.
///
/// Categories with the same name in different decks are merged; the first
/// spelling found is the one shown.
List<DeckCategory> categoriesOf(Iterable<Deck> decks) {
  final byKey = <String, DeckCategory>{};
  for (final deck in decks) {
    for (final question in deck.questions) {
      byKey.putIfAbsent(
        question.categoryKey,
        () => (key: question.categoryKey, label: question.category),
      );
    }
  }
  return byKey.values.toList()..sort((a, b) => a.key.compareTo(b.key));
}

/// The questions of [decks] whose category key is in [categoryKeys].
///
/// A question present in more than one deck is returned once.
List<Question> questionsIn(Iterable<Deck> decks, Set<String> categoryKeys) {
  final ids = <String>{};
  return [
    for (final deck in decks)
      for (final question in deck.questions)
        if (categoryKeys.contains(question.categoryKey) && ids.add(question.id))
          question,
  ];
}

/// Whether [category] matches what the player typed in the search box.
bool categoryMatches(DeckCategory category, String query) =>
    category.key.contains(textKey(query));
