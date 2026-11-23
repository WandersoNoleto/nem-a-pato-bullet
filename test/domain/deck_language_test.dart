import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/domain/deck_language.dart';

void main() {
  test('writes codes the usual way', () {
    expect(normalizeLanguageCode('pt'), 'pt');
    expect(normalizeLanguageCode(' PT-br '), 'pt-BR');
    expect(normalizeLanguageCode('en-us'), 'en-US');
    expect(normalizeLanguageCode('zh-hant'), 'zh-Hant');
    expect(normalizeLanguageCode('es-419'), 'es-419');
  });

  test('rejects text that is not a language code', () {
    for (final code in ['', 'português', '123', 'p', 'pt_BR', 'pt-']) {
      expect(normalizeLanguageCode(code), isNull, reason: code);
    }
  });
}
