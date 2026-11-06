import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10nContext on BuildContext {
  /// The app's own texts in the current language. Deck content never goes
  /// through here: it is always shown exactly as the deck wrote it.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
