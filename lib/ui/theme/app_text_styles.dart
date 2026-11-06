import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const _display = 'ArchivoBlack';
  static const _body = 'Poppins';

  /// Outlines light text on orange pieces.
  static const raisedTextShadow = [
    Shadow(color: AppColors.ink, offset: Offset(0, 2)),
  ];

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

  static const button = TextStyle(
    fontFamily: _display,
    fontSize: 32,
    height: 1,
    letterSpacing: 2,
    color: AppColors.white,
  );

  static const credits = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    color: AppColors.ink,
  );

  static const pill = TextStyle(
    fontFamily: _display,
    fontSize: 14,
    height: 1,
    letterSpacing: 1,
    color: AppColors.ink,
  );

  static const category = TextStyle(
    fontFamily: _display,
    fontSize: 18,
    height: 1,
    letterSpacing: 1,
    color: AppColors.ink,
  );

  static const question = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w700,
    fontSize: 22,
    height: 1.35,
    color: AppColors.ink,
  );

  static const cardLabel = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    letterSpacing: 1.5,
    color: AppColors.cardMuted,
  );

  static const answer = TextStyle(
    fontFamily: _display,
    fontSize: 48,
    height: 1.1,
    color: AppColors.ink,
  );

  static const fact = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w700,
    fontSize: 15,
    height: 1.45,
    color: AppColors.ink,
  );

  static const hint = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    color: AppColors.ink,
  );
}
