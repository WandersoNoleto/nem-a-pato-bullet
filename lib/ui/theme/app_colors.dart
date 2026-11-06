import 'package:flutter/material.dart';

/// Brand colors taken from the cover art.
abstract final class AppColors {
  static const yellow = Color(0xFFFDE004);
  static const ink = Color(0xFF111111);
  static const orange = Color(0xFFE8902A);
  static const white = Color(0xFFFFFFFF);

  /// Card face, like paper on the table.
  static const cream = Color(0xFFFFF6E0);

  /// Labels and dividers on the cream card.
  static const cardMuted = Color(0xFF8A7A55);
  static const cardDivider = Color(0xFFE3D3AA);

  /// Top and bottom colors of raised pieces.
  static const paperGradient = [Color(0xFFFFFDF4), Color(0xFFFFF0CC)];
  static const actionGradient = [Color(0xFFFF9B3D), Color(0xFFE8590F)];
  static const headerGradient = [Color(0xFFFFE964), Color(0xFFFFC61A)];

  /// Secondary text on a selected (orange) piece.
  static const mutedOnAction = Color(0xFFFFE9D0);
}
