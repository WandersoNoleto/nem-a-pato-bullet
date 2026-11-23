import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/l10n/language_names.dart';

void main() {
  test('names known languages and regions in the app language', () {
    expect(languageName('pt-BR', 'pt'), 'Português (Brasil)');
    expect(languageName('pt-BR', 'en'), 'Portuguese (Brazil)');
    expect(languageName('es', 'pt'), 'Espanhol');
    expect(languageName('zh-Hant-TW', 'en'), 'Chinese (TW)');
  });

  test('shows codes it does not know', () {
    expect(languageName('pt-AO', 'pt'), 'Português (AO)');
    expect(languageName('sv-SE', 'pt'), 'SV-SE');
  });
}
