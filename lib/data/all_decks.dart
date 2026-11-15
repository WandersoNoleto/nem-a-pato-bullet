import '../domain/deck.dart';
import '../domain/text_key.dart';
import 'bundled_decks.dart';
import 'imported_decks.dart';

/// Bundled and imported decks together, sorted by name. An imported deck
/// replaces a bundled one with the same name, and is marked so.
///
/// [bundled] defaults to the decks shipped in the app.
Future<List<Deck>> loadAllDecks(
  ImportedDecks imported, {
  Future<List<Deck>> Function()? bundled,
}) async {
  final byName = {
    for (final deck in await (bundled ?? loadBundledDecks)())
      textKey(deck.name): deck,
  };
  for (final deck in await imported.load()) {
    final key = textKey(deck.name);
    byName[key] = byName.containsKey(key)
        ? deck.withOrigin(DeckOrigin.replacesApp)
        : deck;
  }
  return byName.values.toList()..sort((a, b) => a.name.compareTo(b.name));
}
