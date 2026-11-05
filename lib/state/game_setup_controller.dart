import 'package:flutter/foundation.dart';

import '../domain/categories.dart';
import '../domain/deck.dart';
import '../domain/question.dart';
import 'seen_questions.dart';

enum SetupStatus { loading, ready, error }

/// The "Preparar partida" choices: how many rounds, which decks and which
/// categories. Everything starts selected, with infinite rounds.
class GameSetupController extends ChangeNotifier {
  GameSetupController({
    required Future<List<Deck>> Function() loadDecks,
    required SeenQuestions seen,
  }) : _loadDecks = loadDecks,
       _seen = seen;

  static const roundPresets = [5, 10, 15, 20];

  final Future<List<Deck>> Function() _loadDecks;
  final SeenQuestions _seen;

  SetupStatus _status = SetupStatus.loading;
  List<Deck> _decks = const [];
  final Set<Deck> _selectedDecks = {};

  // Exclusions rather than selections, so categories of a newly selected
  // deck start selected.
  final Set<String> _excludedCategoryKeys = {};
  int? _rounds;

  SetupStatus get status => _status;
  List<Deck> get decks => _decks;

  /// Null means infinite.
  int? get rounds => _rounds;

  bool isSelected(Deck deck) => _selectedDecks.contains(deck);

  List<Deck> get _selectedInOrder => [
    for (final deck in _decks)
      if (_selectedDecks.contains(deck)) deck,
  ];

  /// Categories of the selected decks.
  List<DeckCategory> get categories => categoriesOf(_selectedInOrder);

  List<DeckCategory> get selectedCategories => [
    for (final category in categories)
      if (!_excludedCategoryKeys.contains(category.key)) category,
  ];

  List<DeckCategory> get removedCategories => [
    for (final category in categories)
      if (_excludedCategoryKeys.contains(category.key)) category,
  ];

  /// The questions a game with these choices can draw from.
  List<Question> get questions => questionsIn(_selectedInOrder, {
    for (final category in selectedCategories) category.key,
  });

  int get unseenCount =>
      questions.where((question) => !_seen.contains(question.id)).length;

  Future<void> load() async {
    try {
      _decks = await _loadDecks();
    } on Exception catch (error) {
      debugPrint('Could not load decks: $error');
      _status = SetupStatus.error;
      notifyListeners();
      return;
    }
    _selectedDecks.addAll(_decks);
    _status = SetupStatus.ready;
    notifyListeners();
  }

  void setRounds(int? rounds) {
    assert(rounds == null || rounds > 0);
    _rounds = rounds;
    notifyListeners();
  }

  void toggleDeck(Deck deck) {
    if (!_selectedDecks.remove(deck)) {
      _selectedDecks.add(deck);
      // A deck that comes back brings all of its categories with it.
      _excludedCategoryKeys.removeAll(
        categoriesOf([deck]).map((category) => category.key),
      );
    }
    notifyListeners();
  }

  void removeCategory(DeckCategory category) {
    _excludedCategoryKeys.add(category.key);
    notifyListeners();
  }

  void addCategory(DeckCategory category) {
    _excludedCategoryKeys.remove(category.key);
    notifyListeners();
  }

  void selectAllCategories() {
    _excludedCategoryKeys.clear();
    notifyListeners();
  }
}
