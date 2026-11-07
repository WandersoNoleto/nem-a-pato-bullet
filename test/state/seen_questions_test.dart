import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/state/seen_questions.dart';

void main() {
  test('starts from the stored ids', () {
    final seen = SeenQuestions(initial: ['a', 'b']);

    expect(seen.contains('a'), isTrue);
    expect(seen.count, 2);
  });

  test('reports each new id so it can be stored', () {
    final stored = <Set<String>>[];
    final seen = SeenQuestions(onChanged: stored.add);

    seen
      ..add('a')
      ..add('a')
      ..add('b');

    expect(stored, [
      {'a'},
      {'a', 'b'},
    ]);
  });

  test('clearing lets every question come back and is stored', () {
    final stored = <Set<String>>[];
    final seen = SeenQuestions(initial: ['a'], onChanged: stored.add);

    seen.clear();

    expect(seen.count, 0);
    expect(seen.contains('a'), isFalse);
    expect(stored, [<String>{}]);
  });

  test('clearing an empty history stores nothing', () {
    final stored = <Set<String>>[];

    SeenQuestions(onChanged: stored.add).clear();

    expect(stored, isEmpty);
  });
}
