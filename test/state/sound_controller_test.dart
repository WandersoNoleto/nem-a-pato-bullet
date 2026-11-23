import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/state/sound_controller.dart';

void main() {
  test('quacks only while sound is on, and saves the choice', () async {
    var quacks = 0;
    final saved = <bool>[];
    final sound = SoundController(
      enabled: true,
      save: (enabled) async => saved.add(enabled),
      playQuack: () async => quacks++,
    );

    await sound.quack();
    await sound.setEnabled(false);
    await sound.quack();

    expect(quacks, 1);
    expect(sound.enabled, isFalse);
    expect(saved, [false]);
  });

  test('a quack that fails to play is ignored', () async {
    final sound = SoundController(
      enabled: true,
      save: (_) async {},
      playQuack: () async => throw Exception('no audio'),
    );

    await expectLater(sound.quack(), completes);
  });
}
