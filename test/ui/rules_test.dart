import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/app.dart';
import 'package:nem_a_pato_bullet/app_dependencies.dart';
import 'package:nem_a_pato_bullet/data/deck_files.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/state/language_controller.dart';
import 'package:nem_a_pato_bullet/state/seen_questions.dart';
import 'package:nem_a_pato_bullet/state/theme_controller.dart';
import 'package:nem_a_pato_bullet/ui/screens/loading_screen.dart';
import 'package:nem_a_pato_bullet/ui/widgets/rules_dialog.dart';

const _transition = Duration(milliseconds: 500);

void main() {
  testWidgets('the info icon on the home screen shows the rules', (
    tester,
  ) async {
    await tester.pumpWidget(
      NemAPatoApp(
        dependencies: AppDependencies(
          loadDecks: () async => const [],
          importDeck: (source) async => Deck.fromJsonString(source),
          deckFiles: const DeckFiles(),
          language: LanguageController(code: 'pt', save: (_) async {}),
          theme: ThemeController(theme: AppTheme.light, save: (_) async {}),
          seen: SeenQuestions(),
        ),
      ),
    );
    // The play button pulses forever, so step frames instead of settling.
    for (
      var i = 0;
      i < 80 && find.byType(LoadingScreen).evaluate().isNotEmpty;
      i++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    await tester.tap(find.byTooltip('Como jogar'));
    await tester.pump();
    await tester.pump(_transition);

    expect(find.byType(RulesDialog), findsOneWidget);
    expect(
      find.text(
        'Quem perde o desafio está fora do jogo. O último que sobrar vence.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('não guarda jogadores'), findsOneWidget);

    // The panel scrolls on short screens.
    await tester.ensureVisible(find.text('ENTENDI'));
    await tester.tap(find.text('ENTENDI'));
    await tester.pump();
    await tester.pump(_transition);

    expect(find.byType(RulesDialog), findsNothing);
  });
}
