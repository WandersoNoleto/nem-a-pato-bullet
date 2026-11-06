import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Colors of the "table" screens (setup, game, settings) that change between
/// themes. A new theme only needs another instance of this class.
class TableTheme extends ThemeExtension<TableTheme> {
  const TableTheme({
    required this.background,
    required this.horizon,
    required this.onTable,
    required this.hint,
    required this.pieceLip,
    required this.pieceShadow,
    required this.pill,
    required this.onPill,
    required this.pillLip,
  });

  /// Plain near-black table; the one in use for now.
  static const dark = TableTheme(
    background: [Color(0xFF161616), Color(0xFF161616), Color(0xFF161616)],
    horizon: Color(0x00000000),
    onTable: AppColors.cream,
    hint: Color(0xFFB8B2A7),
    pieceLip: Color(0xFF9A6B1F),
    pieceShadow: Color(0xB3000000),
    pill: AppColors.headerGradient,
    onPill: AppColors.ink,
    pillLip: Color(0xFF8F6A00),
  );

  /// "Horizonte": yellow going down to orange, with a darker horizon at the
  /// bottom. Not in use yet; to be picked up again in the visual review.
  static const light = TableTheme(
    background: [Color(0xFFFFD84A), Color(0xFFFFAE2B), Color(0xFFEE6F1D)],
    horizon: Color(0x33963200),
    onTable: AppColors.ink,
    hint: Color(0xFF3A2400),
    pieceLip: AppColors.ink,
    pieceShadow: Color(0x525A2D00),
    pill: [Color(0xFF2D271B), Color(0xFF0F0C06)],
    onPill: Color(0xFFFFE45C),
    pillLip: Color(0x47000000),
  );

  static TableTheme of(BuildContext context) =>
      Theme.of(context).extension<TableTheme>()!;

  /// Top to bottom colors of the screen background.
  final List<Color> background;
  final Color horizon;

  /// Titles directly on the background.
  final Color onTable;

  /// Secondary text directly on the background.
  final Color hint;

  /// The solid edge under raised pieces.
  final Color pieceLip;

  /// The soft shadow raised pieces cast on the background.
  final Color pieceShadow;

  /// The round counter.
  final List<Color> pill;
  final Color onPill;
  final Color pillLip;

  TextStyle get hintStyle => AppTextStyles.hint.copyWith(color: hint);

  @override
  TableTheme copyWith({
    List<Color>? background,
    Color? horizon,
    Color? onTable,
    Color? hint,
    Color? pieceLip,
    Color? pieceShadow,
    List<Color>? pill,
    Color? onPill,
    Color? pillLip,
  }) {
    return TableTheme(
      background: background ?? this.background,
      horizon: horizon ?? this.horizon,
      onTable: onTable ?? this.onTable,
      hint: hint ?? this.hint,
      pieceLip: pieceLip ?? this.pieceLip,
      pieceShadow: pieceShadow ?? this.pieceShadow,
      pill: pill ?? this.pill,
      onPill: onPill ?? this.onPill,
      pillLip: pillLip ?? this.pillLip,
    );
  }

  @override
  TableTheme lerp(TableTheme? other, double t) =>
      other == null || t < 0.5 ? this : other;
}
