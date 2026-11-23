import 'data/deck_files.dart';
import 'domain/deck.dart';
import 'state/language_controller.dart';
import 'state/seen_questions.dart';
import 'state/sound_controller.dart';
import 'state/theme_controller.dart';
import 'update/app_updates.dart';

/// Everything the screens need, created once in main.dart and passed down.
///
/// Tests build this with fakes and without [updates].
class AppDependencies {
  const AppDependencies({
    required this.loadDecks,
    required this.importDeck,
    required this.deckFiles,
    required this.language,
    required this.theme,
    required this.seen,
    this.deleteDeck,
    this.sound,
    this.updates,
  });

  final Future<List<Deck>> Function() loadDecks;

  /// Stores a deck from its JSON text. Throws a [FormatException] if invalid.
  final Future<Deck> Function(String source) importDeck;

  /// Removes an imported deck and its cards from the history. Null hides
  /// deleting, e.g. in tests that don't need it.
  final Future<void> Function(Deck deck)? deleteDeck;
  final DeckFiles deckFiles;
  final LanguageController language;
  final ThemeController theme;
  final SeenQuestions seen;

  /// Null keeps the game silent and hides the sound setting.
  final SoundController? sound;

  /// Null hides the version line and skips update checks.
  final AppUpdates? updates;
}
