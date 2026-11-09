import 'package:flutter/material.dart';

import 'app_dependencies.dart';
import 'l10n/l10n.dart';
import 'ui/screens/loading_screen.dart';
import 'ui/theme/app_colors.dart';
import 'ui/theme/table_theme.dart';

class NemAPatoApp extends StatelessWidget {
  const NemAPatoApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: dependencies.language,
      builder: (context, _) => MaterialApp(
        title: 'Nem a Pato! Bullet',
        debugShowCheckedModeBanner: false,
        locale: Locale(dependencies.language.code),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: AppColors.yellow,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.yellow),
          extensions: const [TableTheme.light],
        ),
        home: LoadingScreen(dependencies: dependencies),
      ),
    );
  }
}
