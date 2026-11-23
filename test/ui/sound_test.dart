import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/app_dependencies.dart';
import 'package:nem_a_pato_bullet/data/deck_files.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';
import 'package:nem_a_pato_bullet/l10n/l10n.dart';
import 'package:nem_a_pato_bullet/state/language_controller.dart';
import 'package:nem_a_pato_bullet/state/seen_questions.dart';
import 'package:nem_a_pato_bullet/state/sound_controller.dart';
import 'package:nem_a_pato_bullet/state/theme_controller.dart';
import 'package:nem_a_pato_bullet/ui/screens/game_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/settings_screen.dart';
import 'package:nem_a_pato_bullet/ui/theme/table_theme.dart';

Widget _host(Widget screen) => MaterialApp(
  locale: const Locale('pt'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: ThemeData(extensions: const [TableTheme.light]),
  home: screen,
);

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  late int quacks;
  late List<bool> saved;
  late SoundController sound;

  setUp(() {
    quacks = 0;
    saved = [];
    sound = SoundController(
      enabled: true,
      save: (enabled) async => saved.add(enabled),
      playQuack: () async => quacks++,
    );
  });

  testWidgets('revealing the card quacks', (tester) async {
    await tester.pumpWidget(
      _host(
        GameScreen(
          questions: [
            Question.create(category: 'Mar', text: 'Fundo?', answer: '11 km'),
          ],
          seen: SeenQuestions(),
          sound: sound,
        ),
      ),
    );
    await _settle(tester);
    expect(quacks, 0);

    await tester.tap(find.text('NEM A PATO!'));
    await _settle(tester);

    expect(quacks, 1);
  });

  testWidgets('the sound can be turned off in the settings', (tester) async {
    await tester.pumpWidget(
      _host(
        SettingsScreen(
          dependencies: AppDependencies(
            loadDecks: () async => const [],
            importDeck: (source) async => Deck.fromJsonString(source),
            deckFiles: const DeckFiles(),
            language: LanguageController(code: 'pt', save: (_) async {}),
            theme: ThemeController(theme: AppTheme.light, save: (_) async {}),
            seen: SeenQuestions(),
            sound: sound,
          ),
        ),
      ),
    );
    await _settle(tester);
    expect(find.text('SOM'), findsOneWidget);

    await tester.ensureVisible(find.text('Desligado'));
    await tester.tap(find.text('Desligado'));
    await _settle(tester);

    expect(sound.enabled, isFalse);
    expect(saved, [false]);
  });
}
