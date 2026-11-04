import 'package:flutter/material.dart';

import 'ui/screens/loading_screen.dart';
import 'ui/theme/app_colors.dart';
import 'update/app_updates.dart';

class NemAPatoApp extends StatelessWidget {
  const NemAPatoApp({super.key, this.updates});

  /// Null disables update checks (tests).
  final AppUpdates? updates;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nem a Pato! Bullet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColors.yellow,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.yellow),
      ),
      home: LoadingScreen(updates: updates),
    );
  }
}
