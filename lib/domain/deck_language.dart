/// Language codes in the BCP 47 style decks use: a language, then optional
/// subtags like a region (`pt`, `pt-BR`, `en-US`, `zh-Hant`).
final _languageCode = RegExp(r'^[a-zA-Z]{2,3}(-[a-zA-Z0-9]{2,8})*$');

/// [code] written the usual way: language in lowercase, region in uppercase,
/// script in title case (`PT-br` → `pt-BR`, `zh-hant` → `zh-Hant`).
///
/// Returns null if [code] isn't a language code.
String? normalizeLanguageCode(String code) {
  final trimmed = code.trim();
  if (!_languageCode.hasMatch(trimmed)) return null;
  final [language, ...subtags] = trimmed.split('-');
  return [
    language.toLowerCase(),
    for (final subtag in subtags)
      switch (subtag.length) {
        2 when !_isDigits(subtag) => subtag.toUpperCase(),
        4 => subtag[0].toUpperCase() + subtag.substring(1).toLowerCase(),
        _ => subtag.toLowerCase(),
      },
  ].join('-');
}

bool _isDigits(String text) => RegExp(r'^\d+$').hasMatch(text);
