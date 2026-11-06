import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/app.dart';
import 'package:nem_a_pato_bullet/app_dependencies.dart';
import 'package:nem_a_pato_bullet/data/deck_files.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';
import 'package:nem_a_pato_bullet/state/seen_questions.dart';
import 'package:nem_a_pato_bullet/ui/screens/game_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/game_setup_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/home_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/loading_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/settings_screen.dart';
import 'package:nem_a_pato_bullet/ui/widgets/choice_pill.dart';

// The home screen's play button pulses forever, so these tests step frames
// instead of using pumpAndSettle, which would never settle.
const _frame = Duration(milliseconds: 100);
const _transition = Duration(milliseconds: 500);

final _decks = [
  Deck(
    name: 'Espaço',
    questions: [
      Question.create(category: 'Planetas', text: 'Quantos?', answer: '8'),
      Question.create(category: 'Luas', text: 'Quantas?', answer: '2'),
    ],
  ),
  Deck(
    name: 'Mar',
    questions: [
      Question.create(category: 'Oceano', text: 'Qual onda?', answer: '24 m'),
    ],
  ),
];

AppDependencies _dependencies() => AppDependencies(
  loadDecks: () async => _decks,
  importDeck: (source) async => Deck.fromJsonString(source),
  deckFiles: const DeckFiles(),
  seen: SeenQuestions(),
);

/// Steps frames until the loading screen is gone, failing if that takes
/// noticeably longer than its duration plus the fade to home.
Future<void> _pastLoading(WidgetTester tester) async {
  await tester.pumpWidget(NemAPatoApp(dependencies: _dependencies()));
  final limit = LoadingScreen.duration + const Duration(seconds: 1);
  var elapsed = Duration.zero;
  while (find.byType(LoadingScreen).evaluate().isNotEmpty) {
    expect(elapsed, lessThan(limit), reason: 'loading screen never finished');
    await tester.pump(_frame);
    elapsed += _frame;
  }
}

Future<void> _openSetup(WidgetTester tester) async {
  await _pastLoading(tester);
  await tester.tap(find.text('JOGAR'));
  await tester.pump();
  await tester.pump(_transition);
}

void main() {
  testWidgets('loading screen shows the title and credits', (tester) async {
    await tester.pumpWidget(NemAPatoApp(dependencies: _dependencies()));

    expect(find.byType(LoadingScreen), findsOneWidget);
    expect(find.text('BULLET'), findsOneWidget);
    expect(find.textContaining('Rodrigo Rego'), findsOneWidget);
  });

  testWidgets('loading screen goes to home after its duration', (tester) async {
    await _pastLoading(tester);

    expect(find.byType(LoadingScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('JOGAR'), findsOneWidget);
  });

  testWidgets('JOGAR opens the setup with every deck and category', (
    tester,
  ) async {
    await _openSetup(tester);

    expect(find.byType(GameSetupScreen), findsOneWidget);
    expect(find.text('Espaço'), findsOneWidget);
    expect(find.text('Mar'), findsOneWidget);
    for (final category in ['Luas', 'Oceano', 'Planetas']) {
      expect(find.text(category), findsOneWidget);
    }
    expect(find.text('3 perguntas inéditas'), findsOneWidget);
  });

  testWidgets('removing a category updates the available questions', (
    tester,
  ) async {
    await _openSetup(tester);

    await tester.tap(find.text('Oceano'));
    await tester.pump();

    expect(find.text('2 perguntas inéditas'), findsOneWidget);
    expect(find.text('Selecionar todas'), findsOneWidget);
  });

  testWidgets('a custom number of rounds can be typed', (tester) async {
    await _openSetup(tester);

    await tester.tap(find.text('+'));
    await tester.pump();
    await tester.pump(_transition);
    await tester.enterText(find.byType(TextField).last, '25');
    await tester.tap(find.text('OK'));
    await tester.pump();
    await tester.pump(_transition);

    expect(find.text('25'), findsOneWidget);
  });

  testWidgets('COMEÇAR opens the game', (tester) async {
    await _openSetup(tester);

    await tester.tap(find.text('COMEÇAR'));
    await tester.pump();
    await tester.pump(_transition);

    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.text('RODADA 1'), findsOneWidget);
  });

  testWidgets('the gear on home opens the settings', (tester) async {
    await _pastLoading(tester);

    await tester.tap(find.byTooltip('Configurações'));
    await tester.pump();
    await tester.pump(_transition);

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Importar baralho'), findsOneWidget);
    expect(find.text('Espaço'), findsOneWidget);
    expect(find.text('Mar'), findsOneWidget);
  });

  testWidgets('choosing a language marks it as selected', (tester) async {
    await _pastLoading(tester);
    await tester.tap(find.byTooltip('Configurações'));
    await tester.pump();
    await tester.pump(_transition);

    await tester.tap(find.text('English'));
    await tester.pump();

    final pill = tester.widget<ChoicePill>(
      find.widgetWithText(ChoicePill, 'English'),
    );
    expect(pill.selected, isTrue);
  });
}
