import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'update/app_updates.dart';
import 'update/update_checker.dart';
import 'update/update_installer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    NemAPatoApp(
      updates: AppUpdates(
        checker: UpdateChecker(),
        installer: UpdateInstaller(),
        // Debug builds take their version from pubspec.yaml and are often
        // behind the latest release, so the prompt would show on every
        // `flutter run`.
        checkOnStartup: !kDebugMode,
      ),
    ),
  );
}
