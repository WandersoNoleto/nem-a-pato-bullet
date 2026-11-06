import 'data/deck_files.dart';
import 'domain/deck.dart';
import 'state/seen_questions.dart';
import 'update/app_updates.dart';

/// Everything the screens need, created once in main.dart and passed down.
///
/// Tests build this with fakes and without [updates].
class AppDependencies {
  const AppDependencies({
    required this.loadDecks,
    required this.importDeck,
    required this.deckFiles,
    required this.seen,
    this.updates,
  });

  final Future<List<Deck>> Function() loadDecks;

  /// Stores a deck from its JSON text. Throws a [FormatException] if invalid.
  final Future<Deck> Function(String source) importDeck;
  final DeckFiles deckFiles;
  final SeenQuestions seen;

  /// Null hides the version line and skips update checks.
  final AppUpdates? updates;
}
