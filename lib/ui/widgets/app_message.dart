import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'raised_box.dart';

/// Shows a short message at the bottom as a yellow piece, like the card
/// headers, replacing any message still on screen.
///
/// [bottom] lifts it above controls fixed at the bottom of the screen.
void showAppMessage(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 4),
  double bottom = 20,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.fromLTRB(20, 0, 20, bottom),
        // Yellow stands out on both the white panels and the dark table.
        content: RaisedBox(
          colors: AppColors.headerGradient,
          lipColor: AppColors.ink,
          radius: 14,
          lipHeight: 4,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.ink, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.fact.copyWith(
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
}
