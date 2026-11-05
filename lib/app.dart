import 'package:flutter/material.dart';

import 'app_dependencies.dart';
import 'ui/screens/loading_screen.dart';
import 'ui/theme/app_colors.dart';

class NemAPatoApp extends StatelessWidget {
  const NemAPatoApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

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
      home: LoadingScreen(dependencies: dependencies),
    );
  }
}
