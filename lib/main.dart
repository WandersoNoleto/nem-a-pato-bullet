import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'app_dependencies.dart';
import 'data/all_decks.dart';
import 'data/deck_files.dart';
import 'data/imported_decks.dart';
import 'l10n/l10n.dart';
import 'state/language_controller.dart';
import 'state/seen_questions.dart';
import 'update/app_updates.dart';
import 'update/update_checker.dart';
import 'update/update_installer.dart';

const _languageKey = 'language';
const _seenKey = 'seen_questions';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final imported = ImportedDecks();
  final preferences = await SharedPreferences.getInstance();
  final savedLanguage = preferences.getString(_languageKey);
  final language = LanguageController(
    code:
        AppLocalizations.supportedLocales.any(
          (locale) => locale.languageCode == savedLanguage,
        )
        ? savedLanguage!
        : LanguageController.defaultCode,
    save: (code) => preferences.setString(_languageKey, code),
  );
  runApp(
    NemAPatoApp(
      dependencies: AppDependencies(
        loadDecks: () => loadAllDecks(imported),
        importDeck: imported.save,
        deckFiles: const DeckFiles(),
        language: language,
        seen: SeenQuestions(
          initial: preferences.getStringList(_seenKey) ?? const [],
          onChanged: (ids) => preferences.setStringList(_seenKey, ids.toList()),
        ),
        updates: AppUpdates(
          checker: UpdateChecker(),
          installer: UpdateInstaller(),
          // Debug builds take their version from pubspec.yaml and are often
          // behind the latest release, so the prompt would show on every
          // `flutter run`.
          checkOnStartup: !kDebugMode,
        ),
      ),
    ),
  );
}
