import 'package:flutter/material.dart';

/// Brand colors taken from the cover art.
abstract final class AppColors {
  static const yellow = Color(0xFFFDE004);
  static const ink = Color(0xFF111111);
  static const orange = Color(0xFFE8902A);
  static const white = Color(0xFFFFFFFF);

  /// Labels and dividers on paper (cards and panels).
  static const cardMuted = Color(0xFF7A6F55);
  static const cardDivider = Color(0xFFE6E1D6);

  /// Top and bottom colors of paper pieces: white like the duck.
  static const paperGradient = [Color(0xFFFFFFFF), Color(0xFFF3F0E9)];

  /// Top and bottom colors of yellow pieces (card headers, selected decks).
  static const headerGradient = [Color(0xFFFFE964), Color(0xFFFFC61A)];

  /// Secondary text on yellow pieces.
  static const mutedOnYellow = Color(0xFF5A4500);
}
