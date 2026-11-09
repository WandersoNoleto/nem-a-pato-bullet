import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Colors of the table screens, by role, so each theme only swaps values.
///
/// The rules behind the roles: yellow is the brand, ink is the structure,
/// white is paper (cards and panels) and orange only appears as the lip under
/// pieces that can be tapped.
class TableTheme extends ThemeExtension<TableTheme> {
  const TableTheme({
    required this.background,
    required this.rays,
    required this.title,
    required this.onTable,
    required this.hint,
    required this.paperLip,
    required this.pieceShadow,
    required this.action,
    required this.onAction,
    required this.onSelected,
    required this.actionLip,
  });

  /// Near-black table, with yellow for actions and selection.
  static const dark = TableTheme(
    background: [Color(0xFF161616), Color(0xFF161616), Color(0xFF161616)],
    rays: Color(0x0FFDE004),
    title: AppColors.yellow,
    onTable: AppColors.white,
    hint: Color(0xFFB8B2A7),
    paperLip: Color(0xFF9A6B1F),
    pieceShadow: Color(0xB3000000),
    action: [Color(0xFFFFE964), Color(0xFFFDD500)],
    onAction: AppColors.ink,
    onSelected: AppColors.ink,
    actionLip: AppColors.orange,
  );

  /// Yellow table, with ink for actions and selection.
  static const light = TableTheme(
    background: [Color(0xFFFFE629), Color(0xFFFDD500), Color(0xFFEDB400)],
    rays: Color(0x26FFFFFF),
    title: AppColors.ink,
    onTable: AppColors.ink,
    hint: Color(0xFF5A4500),
    paperLip: AppColors.ink,
    pieceShadow: Color(0x525A2D00),
    action: [Color(0xFF2E2E2E), AppColors.ink],
    onAction: AppColors.white,
    onSelected: AppColors.yellow,
    actionLip: AppColors.orange,
  );

  static TableTheme of(BuildContext context) =>
      Theme.of(context).extension<TableTheme>()!;

  /// Top, middle and bottom colors of the screen background.
  final List<Color> background;

  /// The sunburst drawn over the background of the game screen.
  final Color rays;

  /// Screen titles and big messages on the background.
  final Color title;

  /// Section labels and other text on the background.
  final Color onTable;

  /// Secondary text on the background.
  final Color hint;

  /// The solid edge under paper pieces (cards, panels, unselected options).
  final Color paperLip;

  /// The soft shadow raised pieces cast on the background.
  final Color pieceShadow;

  /// Top and bottom colors of the main action button and selected options.
  final List<Color> action;

  /// Text on the main action button.
  final Color onAction;

  /// Text on selected options and the round counter.
  final Color onSelected;

  /// The solid edge under pieces that can be tapped to act.
  final Color actionLip;

  TextStyle get hintStyle => AppTextStyles.hint.copyWith(color: hint);

  @override
  TableTheme copyWith({
    List<Color>? background,
    Color? rays,
    Color? title,
    Color? onTable,
    Color? hint,
    Color? paperLip,
    Color? pieceShadow,
    List<Color>? action,
    Color? onAction,
    Color? onSelected,
    Color? actionLip,
  }) {
    return TableTheme(
      background: background ?? this.background,
      rays: rays ?? this.rays,
      title: title ?? this.title,
      onTable: onTable ?? this.onTable,
      hint: hint ?? this.hint,
      paperLip: paperLip ?? this.paperLip,
      pieceShadow: pieceShadow ?? this.pieceShadow,
      action: action ?? this.action,
      onAction: onAction ?? this.onAction,
      onSelected: onSelected ?? this.onSelected,
      actionLip: actionLip ?? this.actionLip,
    );
  }

  @override
  TableTheme lerp(TableTheme? other, double t) =>
      other == null || t < 0.5 ? this : other;
}
