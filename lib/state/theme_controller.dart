import 'package:flutter/foundation.dart';

enum AppTheme { light, dark }

/// The app's color theme, kept across launches.
class ThemeController extends ChangeNotifier {
  ThemeController({
    required AppTheme theme,
    required Future<void> Function(AppTheme theme) save,
  }) : _theme = theme,
       _save = save;

  static const defaultTheme = AppTheme.light;

  final Future<void> Function(AppTheme theme) _save;
  AppTheme _theme;

  AppTheme get theme => _theme;

  Future<void> setTheme(AppTheme theme) async {
    if (theme == _theme) return;
    _theme = theme;
    notifyListeners();
    await _save(theme);
  }
}
