import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const _display = 'ArchivoBlack';
  static const _body = 'Poppins';

  static const titleLarge = TextStyle(
    fontFamily: _display,
    fontSize: 96,
    height: 1,
    color: AppColors.ink,
  );

  static const titleSmall = TextStyle(
    fontFamily: _display,
    fontSize: 40,
    height: 1,
    color: AppColors.ink,
  );

  static const tag = TextStyle(
    fontFamily: _display,
    fontSize: 36,
    height: 1,
    color: AppColors.white,
  );

  static const credits = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    color: AppColors.ink,
  );
}
