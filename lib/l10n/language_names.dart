/// Names of common languages and regions, in the app's languages, to show a
/// deck's language code (`pt-BR`) as "Português (Brasil)".
const _languages = {
  'pt': {
    'ar': 'Árabe',
    'de': 'Alemão',
    'en': 'Inglês',
    'es': 'Espanhol',
    'fr': 'Francês',
    'hi': 'Hindi',
    'it': 'Italiano',
    'ja': 'Japonês',
    'ko': 'Coreano',
    'nl': 'Holandês',
    'pt': 'Português',
    'ru': 'Russo',
    'zh': 'Chinês',
  },
  'en': {
    'ar': 'Arabic',
    'de': 'German',
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'hi': 'Hindi',
    'it': 'Italian',
    'ja': 'Japanese',
    'ko': 'Korean',
    'nl': 'Dutch',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'zh': 'Chinese',
  },
};

const _regions = {
  'pt': {
    'AR': 'Argentina',
    'BR': 'Brasil',
    'CA': 'Canadá',
    'ES': 'Espanha',
    'FR': 'França',
    'GB': 'Reino Unido',
    'MX': 'México',
    'PT': 'Portugal',
    'US': 'EUA',
  },
  'en': {
    'AR': 'Argentina',
    'BR': 'Brazil',
    'CA': 'Canada',
    'ES': 'Spain',
    'FR': 'France',
    'GB': 'UK',
    'MX': 'Mexico',
    'PT': 'Portugal',
    'US': 'US',
  },
};

/// [code] as a name in the app's [appLanguage]: "Português (Brasil)" for
/// `pt-BR`, "Português" for `pt`. A region the app doesn't know is shown as
/// its code ("Português (AO)"); a language it doesn't know shows the whole
/// code in capitals ("SV-SE").
String languageName(String code, String appLanguage) {
  final [language, ...subtags] = code.split('-');
  final name = (_languages[appLanguage] ?? _languages['en']!)[language];
  if (name == null) return code.toUpperCase();
  final region = subtags.where((subtag) => subtag.length == 2).firstOrNull;
  if (region == null) return name;
  final regionName =
      (_regions[appLanguage] ?? _regions['en']!)[region] ?? region;
  return '$name ($regionName)';
}
