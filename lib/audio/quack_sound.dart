import 'package:audioplayers/audioplayers.dart';

/// The duck's quack, kept loaded so it plays right on the tap.
class QuackSound {
  final _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

  static final _source = AssetSource('sounds/quack.mp3');

  /// Starts the quack from the beginning, cutting one still playing.
  Future<void> play() async {
    await _player.stop();
    await _player.play(_source, mode: PlayerMode.lowLatency);
  }
}
