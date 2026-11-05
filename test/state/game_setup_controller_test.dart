import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';
import 'package:nem_a_pato_bullet/state/game_setup_controller.dart';
import 'package:nem_a_pato_bullet/state/seen_questions.dart';

final _space = Deck(
  name: 'Espaço',
  questions: [
    Question.create(category: 'Planetas', text: 'Quantos?', answer: '8'),
    Question.create(category: 'Oceano', text: 'Água em Europa?', answer: 'Sim'),
  ],
);
final _sea = Deck(
  name: 'Mar',
  questions: [
    Question.create(category: 'oceano', text: 'Qual onda?', answer: '24 m'),
    Question.create(category: 'Peixes', text: 'Quantos?', answer: '35 mil'),
  ],
);

Future<GameSetupController> _loaded({SeenQuestions? seen}) async {
  final controller = GameSetupController(
    loadDecks: () async => [_space, _sea],
    seen: seen ?? SeenQuestions(),
  );
  await controller.load();
  return controller;
}

List<String> _labels(GameSetupController controller) => [
  for (final category in controller.selectedCategories) category.label,
];

void main() {
  test('starts with infinite rounds and everything selected', () async {
    final controller = await _loaded();

    expect(controller.status, SetupStatus.ready);
    expect(controller.rounds, isNull);
    expect(controller.isSelected(_space), isTrue);
    expect(controller.isSelected(_sea), isTrue);
    expect(_labels(controller), ['Oceano', 'Peixes', 'Planetas']);
    expect(controller.questions, hasLength(4));
  });

  test('merges categories with the same name across decks', () async {
    final controller = await _loaded();

    expect(
      controller.categories.where((category) => category.key == 'oceano'),
      hasLength(1),
    );
  });

  test('deselecting a deck hides its categories and questions', () async {
    final controller = await _loaded();

    controller.toggleDeck(_sea);

    expect(_labels(controller), ['Oceano', 'Planetas']);
    expect(controller.questions, hasLength(2));
  });

  test('removing a category drops its questions', () async {
    final controller = await _loaded();
    final ocean = controller.categories.firstWhere((c) => c.key == 'oceano');

    controller.removeCategory(ocean);

    expect(_labels(controller), ['Peixes', 'Planetas']);
    expect(controller.removedCategories, [ocean]);
    expect(controller.questions, hasLength(2));
  });

  test('a deck selected again brings back all of its categories', () async {
    final controller = await _loaded();
    final fish = controller.categories.firstWhere((c) => c.key == 'peixes');
    controller
      ..removeCategory(fish)
      ..toggleDeck(_sea);

    controller.toggleDeck(_sea);

    expect(_labels(controller), contains('Peixes'));
  });

  test('categories can be added back one by one or all at once', () async {
    final controller = await _loaded();
    final fish = controller.categories.firstWhere((c) => c.key == 'peixes');
    final ocean = controller.categories.firstWhere((c) => c.key == 'oceano');
    controller
      ..removeCategory(fish)
      ..removeCategory(ocean);

    controller.addCategory(fish);
    expect(_labels(controller), ['Peixes', 'Planetas']);

    controller.selectAllCategories();
    expect(controller.removedCategories, isEmpty);
  });

  test('counts only questions that were never shown', () async {
    final seen = SeenQuestions()..add(_space.questions.first.id);
    final controller = await _loaded(seen: seen);

    expect(controller.unseenCount, 3);
  });

  test('reports an error when the decks cannot be loaded', () async {
    final controller = GameSetupController(
      loadDecks: () async => throw const FormatException('bad deck'),
      seen: SeenQuestions(),
    );

    await controller.load();

    expect(controller.status, SetupStatus.error);
  });
}
