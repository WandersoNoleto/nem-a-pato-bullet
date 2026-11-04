import 'package:flutter/material.dart';

import 'ui/screens/loading_screen.dart';
import 'ui/theme/app_colors.dart';

class NemAPatoApp extends StatelessWidget {
  const NemAPatoApp({super.key});

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
      home: const LoadingScreen(),
    );
  }
}
