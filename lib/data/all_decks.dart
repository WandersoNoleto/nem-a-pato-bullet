import '../domain/deck.dart';
import '../domain/text_key.dart';
import 'bundled_decks.dart';
import 'imported_decks.dart';

/// Bundled and imported decks together, sorted by name. An imported deck
/// replaces a bundled one with the same name.
Future<List<Deck>> loadAllDecks(ImportedDecks imported) async {
  final byName = {
    for (final deck in await loadBundledDecks()) textKey(deck.name): deck,
    for (final deck in await imported.load()) textKey(deck.name): deck,
  };
  return byName.values.toList()..sort((a, b) => a.name.compareTo(b.name));
}
