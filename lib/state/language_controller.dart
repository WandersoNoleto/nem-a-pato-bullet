import 'package:flutter/foundation.dart';

/// The language of the app's own texts, kept across launches.
class LanguageController extends ChangeNotifier {
  LanguageController({
    required String code,
    required Future<void> Function(String code) save,
  }) : _code = code,
       _save = save;

  static const defaultCode = 'pt';

  final Future<void> Function(String code) _save;
  String _code;

  String get code => _code;

  Future<void> setCode(String code) async {
    if (code == _code) return;
    _code = code;
    notifyListeners();
    await _save(code);
  }
}
