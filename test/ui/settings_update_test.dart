import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nem_a_pato_bullet/app_dependencies.dart';
import 'package:nem_a_pato_bullet/data/deck_files.dart';
import 'package:nem_a_pato_bullet/domain/deck.dart';
import 'package:nem_a_pato_bullet/l10n/l10n.dart';
import 'package:nem_a_pato_bullet/state/language_controller.dart';
import 'package:nem_a_pato_bullet/state/seen_questions.dart';
import 'package:nem_a_pato_bullet/state/theme_controller.dart';
import 'package:nem_a_pato_bullet/ui/screens/settings_screen.dart';
import 'package:nem_a_pato_bullet/ui/theme/table_theme.dart';
import 'package:nem_a_pato_bullet/update/app_updates.dart';
import 'package:nem_a_pato_bullet/update/update_checker.dart';
import 'package:nem_a_pato_bullet/update/update_installer.dart';

Map<String, Object?> _release(String tag) => {
  'tag_name': tag,
  'draft': false,
  'body': '',
  'assets': [
    {'name': 'app.apk', 'browser_download_url': 'https://example.com/$tag.apk'},
  ],
};

Widget _settings(http.Client client) {
  return MaterialApp(
    locale: const Locale('pt'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(extensions: const [TableTheme.dark]),
    home: SettingsScreen(
      dependencies: AppDependencies(
        loadDecks: () async => const [],
        importDeck: (source) async => Deck.fromJsonString(source),
        deckFiles: const DeckFiles(),
        language: LanguageController(code: 'pt', save: (_) async {}),
        theme: ThemeController(theme: AppTheme.light, save: (_) async {}),
        seen: SeenQuestions(),
        updates: AppUpdates(
          checker: UpdateChecker(
            client: client,
            installedVersion: () async => (name: '1.0.0', code: 1000000),
          ),
          installer: UpdateInstaller(),
          checkOnStartup: false,
        ),
      ),
    ),
  );
}

Future<void> _tapCheck(WidgetTester tester) async {
  await tester.pump();
  await tester.tap(find.text('Procurar atualização'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('shows the installed version', (tester) async {
    await tester.pumpWidget(
      _settings(MockClient((_) async => http.Response('[]', 200))),
    );
    await tester.pump();

    expect(find.text('Versão 1.0.0'), findsOneWidget);
  });

  testWidgets('says so when already on the newest version', (tester) async {
    await tester.pumpWidget(
      _settings(
        MockClient(
          (_) async => http.Response(jsonEncode([_release('v1.0.0')]), 200),
        ),
      ),
    );

    await _tapCheck(tester);

    expect(find.text('Você já está na versão mais recente.'), findsOneWidget);
    expect(find.text('Nova versão disponível'), findsNothing);
  });

  testWidgets('offers a newer release', (tester) async {
    await tester.pumpWidget(
      _settings(
        MockClient(
          (_) async => http.Response(jsonEncode([_release('v1.0.1')]), 200),
        ),
      ),
    );

    await _tapCheck(tester);

    expect(find.text('Nova versão disponível'), findsOneWidget);
    expect(find.textContaining('v1.0.1'), findsOneWidget);
  });

  testWidgets('reports a failed check', (tester) async {
    await tester.pumpWidget(
      _settings(MockClient((_) async => http.Response('', 500))),
    );

    await _tapCheck(tester);

    expect(find.textContaining('Não deu para procurar'), findsOneWidget);
  });
}
