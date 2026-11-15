import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/l10n/l10n.dart';
import 'package:nem_a_pato_bullet/ui/theme/table_theme.dart';
import 'package:nem_a_pato_bullet/update/app_version.dart';
import 'package:nem_a_pato_bullet/update/update_checker.dart';
import 'package:nem_a_pato_bullet/update/update_installer.dart';
import 'package:nem_a_pato_bullet/update/update_prompt.dart';

class _FakeInstaller extends UpdateInstaller {
  final progress = StreamController<InstallProgress>();

  @override
  Stream<InstallProgress> install(AvailableUpdate update) => progress.stream;
}

final _update = AvailableUpdate(
  version: AppVersion.parseTag('v9.9.9')!,
  tag: 'v9.9.9',
  notes: 'Bug fixes',
  apkUrl: Uri.parse('https://example.com/app.apk'),
);

Future<void> _settle(WidgetTester tester) async {
  // The stream event, then the dialog transition.
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _open(WidgetTester tester, UpdateInstaller installer) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(extensions: const [TableTheme.light]),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showUpdateDialog(
              context,
              update: _update,
              installer: installer,
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await _settle(tester);
}

void main() {
  testWidgets('accepting shows the download until the installer opens', (
    tester,
  ) async {
    final installer = _FakeInstaller();
    await _open(tester, installer);

    expect(find.text('Nova versão disponível'), findsOneWidget);
    await tester.tap(find.text('RELEASE NOTES'));
    await _settle(tester);
    expect(find.text('Bug fixes'), findsOneWidget);

    await tester.tap(find.text('ATUALIZAR'));
    await _settle(tester);
    expect(find.text('Baixando atualização'), findsOneWidget);
    expect(find.text('Iniciando…'), findsOneWidget);

    installer.progress.add(const Downloading(42));
    await _settle(tester);
    expect(find.text('42%'), findsOneWidget);

    installer.progress.add(const InstallerOpened());
    await _settle(tester);
    expect(find.text('Baixando atualização'), findsNothing);
  });

  testWidgets('DEPOIS closes without downloading', (tester) async {
    final installer = _FakeInstaller();
    await _open(tester, installer);

    await tester.tap(find.text('DEPOIS'));
    await _settle(tester);

    expect(find.text('Nova versão disponível'), findsNothing);
    expect(installer.progress.hasListener, isFalse);
  });
}
