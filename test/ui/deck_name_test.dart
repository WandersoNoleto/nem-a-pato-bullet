import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/app_dependencies.dart';
import 'package:nem_a_pato_bullet/data/deck_files.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/domain/question.dart';
import 'package:nem_a_pato_bullet/l10n/l10n.dart';
import 'package:nem_a_pato_bullet/state/language_controller.dart';
import 'package:nem_a_pato_bullet/state/seen_questions.dart';
import 'package:nem_a_pato_bullet/state/theme_controller.dart';
import 'package:nem_a_pato_bullet/ui/screens/game_setup_screen.dart';
import 'package:nem_a_pato_bullet/ui/theme/table_theme.dart';

const _names = [
  'Conhecimentos Gerais',
  'Curiosidades Extraordinárias',
  'Entretenimento',
  'General Knowledge',
];

Deck _deck(String name) => Deck(
  name: name,
  questions: [Question.create(category: 'Geral', text: name, answer: '1')],
);

Future<void> _loadFont(String family, String path) async {
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.sublistView(File(path).readAsBytesSync())));
  await loader.load();
}

void main() {
  testWidgets('deck names never break in the middle of a word', (tester) async {
    // Line breaks depend on the real font's widths.
    await tester.runAsync(
      () => _loadFont('Poppins', 'assets/fonts/Poppins-Bold.ttf'),
    );
    addTearDown(tester.view.reset);

    for (var width = 340.0; width <= 430; width += 10) {
      tester.view
        ..physicalSize = Size(width, 800)
        ..devicePixelRatio = 1;
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(width),
          locale: const Locale('pt'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            fontFamily: 'Poppins',
            extensions: const [TableTheme.light],
          ),
          home: GameSetupScreen(
            dependencies: AppDependencies(
              loadDecks: () async => [for (final name in _names) _deck(name)],
              importDeck: (source) async => Deck.fromJsonString(source),
              deckFiles: const DeckFiles(),
              language: LanguageController(code: 'pt', save: (_) async {}),
              theme: ThemeController(theme: AppTheme.light, save: (_) async {}),
              seen: SeenQuestions(),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      for (final name in _names) {
        final paragraph = tester.renderObject<RenderParagraph>(find.text(name));
        var start = 0;
        for (final word in name.split(' ')) {
          final boxes = paragraph.getBoxesForSelection(
            TextSelection(baseOffset: start, extentOffset: start + word.length),
          );
          expect(
            {for (final box in boxes) box.top.round()},
            hasLength(1),
            reason: '"$word" is split on a $width-wide screen',
          );
          start += word.length + 1;
        }
      }
    }
  });
}
