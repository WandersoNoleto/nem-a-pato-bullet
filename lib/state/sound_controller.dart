import 'package:flutter/foundation.dart';

/// Whether the game plays sounds, kept across launches, and the duck's
/// quack when someone shouts "Nem a Pato!".
class SoundController extends ChangeNotifier {
  SoundController({
    required bool enabled,
    required Future<void> Function(bool enabled) save,
    required Future<void> Function() playQuack,
  }) : _enabled = enabled,
       _save = save,
       _playQuack = playQuack;

  static const defaultEnabled = true;

  final Future<void> Function(bool enabled) _save;
  final Future<void> Function() _playQuack;
  bool _enabled;

  bool get enabled => _enabled;

  Future<void> setEnabled(bool enabled) async {
    if (enabled == _enabled) return;
    _enabled = enabled;
    notifyListeners();
    await _save(enabled);
  }

  /// Plays the quack, unless sound is off. A sound that fails to play is
  /// ignored: the game goes on without it.
  Future<void> quack() async {
    if (!_enabled) return;
    try {
      await _playQuack();
    } on Exception catch (error) {
      debugPrint('Could not play the quack: $error');
    }
  }
}
