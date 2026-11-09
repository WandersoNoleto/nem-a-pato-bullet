// Renders the README screenshots from the real screens, in English.
//
//   UPDATE_SCREENSHOTS=1 flutter test test/screenshots
//
// Skipped in normal test runs. Writes PNGs to .github/assets/, or to
// SCREENSHOT_DIR when set.
import 'dart:io';
import 'dart:ui' as ui;

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
import 'package:nem_a_pato_bullet/ui/screens/game_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/game_setup_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/home_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/settings_screen.dart';
import 'package:nem_a_pato_bullet/ui/theme/app_colors.dart';
import 'package:nem_a_pato_bullet/ui/theme/table_theme.dart';
import 'package:nem_a_pato_bullet/update/app_updates.dart';
import 'package:nem_a_pato_bullet/update/update_checker.dart';
import 'package:nem_a_pato_bullet/update/update_installer.dart';

final _outDir = Platform.environment['SCREENSHOT_DIR'] ?? '.github/assets';
const _screenSize = Size(390, 844);
const _emojiFont = '/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf';

const _bulb =
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><path d='M12 2a7 7 0 0 0-4 12.7V17a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1v-2.3A7 7 0 0 0 12 2z'/><rect x='9' y='19' width='6' height='3' rx='1'/></svg>";
const _globe =
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#000' stroke-width='2'><circle cx='12' cy='12' r='10'/><ellipse cx='12' cy='12' rx='4' ry='10'/><path d='M2 12h20'/></svg>";

final _wave = Question.create(
  category: 'Ocean',
  text: 'How tall was the biggest wave ever surfed?',
  answer: '24 m',
  fact: 'It was surfed in Nazaré, Portugal, in 2020.',
);

final _decks = [
  Deck(
    name: 'General Knowledge',
    iconSvg: _bulb,
    questions: [
      Question.create(category: 'Animals', text: 'a', answer: '1'),
      Question.create(category: 'Human body', text: 'b', answer: '1'),
      Question.create(category: 'Science', text: 'c', answer: '1'),
    ],
  ),
  Deck(
    name: 'Around the World',
    iconSvg: _globe,
    questions: [
      _wave,
      Question.create(category: 'Landmarks', text: 'd', answer: '1'),
      Question.create(category: 'Sports', text: 'e', answer: '1'),
    ],
  ),
  Deck(
    name: 'Sample deck',
    questions: [Question.create(category: 'Space', text: 'f', answer: '1')],
  ),
];

final _skip = Platform.environment['UPDATE_SCREENSHOTS'] != '1';

/// The app version from pubspec.yaml, e.g. "1.1.1".
final _version = RegExp(
  r'^version:\s*([\d.]+)',
  multiLine: true,
).firstMatch(File('pubspec.yaml').readAsStringSync())!.group(1)!;

AppDependencies _dependencies(TableTheme table) => AppDependencies(
  loadDecks: () async => _decks,
  importDeck: (source) async => Deck.fromJsonString(source),
  deckFiles: const DeckFiles(),
  language: LanguageController(code: 'en', save: (_) async {}),
  theme: ThemeController(
    theme: table == TableTheme.dark ? AppTheme.dark : AppTheme.light,
    save: (_) async {},
  ),
  seen: SeenQuestions(initial: ['x1', 'x2', 'x3', 'x4', 'x5']),
  // Shows the version without ever reaching GitHub.
  updates: AppUpdates(
    checker: UpdateChecker(
      installedVersion: () async => (name: _version, code: 0),
    ),
    installer: UpdateInstaller(),
    checkOnStartup: false,
  ),
);

Widget _host(Widget screen, TableTheme table) {
  final base = ThemeData(
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: AppColors.yellow,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.yellow),
    extensions: [table],
  );
  return RepaintBoundary(
    key: const Key('screenshot'),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: base.copyWith(
        textTheme: base.textTheme.apply(fontFamilyFallback: ['NotoColorEmoji']),
      ),
      home: screen,
    ),
  );
}

Future<void> _loadFont(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.sublistView(file.readAsBytesSync())));
  await loader.load();
}

/// The Material icons font ships with the Flutter SDK next to the tester.
String _materialIconsPath() {
  var dir = File(Platform.resolvedExecutable).parent;
  while (dir.path != dir.parent.path) {
    final font = File('${dir.path}/material_fonts/MaterialIcons-Regular.otf');
    if (font.existsSync()) return font.path;
    dir = dir.parent;
  }
  return '';
}

Future<void> _show(WidgetTester tester, Widget screen, TableTheme table) async {
  await tester.pumpWidget(_host(screen, table));
  await tester.runAsync(() async {
    final context = tester.element(find.byType(Scaffold).first);
    await precacheImage(const AssetImage('assets/images/mascot.png'), context);
  });
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _capture(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const Key('screenshot')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    File('$_outDir/$name.png').writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}

void main() {
  testWidgets('README screenshots', skip: _skip, (tester) async {
    await tester.runAsync(() async {
      await _loadFont('ArchivoBlack', 'assets/fonts/ArchivoBlack-Regular.ttf');
      await _loadFont('Poppins', 'assets/fonts/Poppins-Bold.ttf');
      await _loadFont('MaterialIcons', _materialIconsPath());
      await _loadFont('NotoColorEmoji', _emojiFont);
    });
    tester.view
      ..physicalSize = _screenSize
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    Directory(_outDir).createSync(recursive: true);

    for (final (table, suffix) in [
      (TableTheme.light, ''),
      (TableTheme.dark, '-dark'),
    ]) {
      await _show(
        tester,
        HomeScreen(dependencies: _dependencies(table)),
        table,
      );
      await _capture(tester, 'home$suffix');

      await _show(
        tester,
        GameSetupScreen(dependencies: _dependencies(table)),
        table,
      );
      await _capture(tester, 'setup$suffix');

      await _show(
        tester,
        GameScreen(questions: [_wave], seen: SeenQuestions(), rounds: 10),
        table,
      );
      await _capture(tester, 'question$suffix');
      await tester.tap(find.text('NEM A PATO!'));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      await _capture(tester, 'answer$suffix');

      await _show(
        tester,
        SettingsScreen(dependencies: _dependencies(table)),
        table,
      );
      await _capture(tester, 'settings$suffix');
    }
  });
}
