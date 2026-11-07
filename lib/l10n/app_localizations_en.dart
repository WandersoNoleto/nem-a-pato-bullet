// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get back => 'Back';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get playButton => 'PLAY';

  @override
  String get credits =>
      'Inspired by \"Nem a Pato!\" by Rodrigo Rego · Grok Games';

  @override
  String get updateAvailable => 'Update available!';

  @override
  String get outOfQuestionsTitle => 'Out of cards!';

  @override
  String get outOfQuestionsBody =>
      'Every card chosen for this game has already come up. Return the cards to the deck to keep playing.';

  @override
  String get gameOverTitle => 'Game over!';

  @override
  String gameOverBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rounds played',
      one: '1 round played',
    );
    return '$_temp0. Whoever has the most cards is the duck of the table.';
  }

  @override
  String get backButton => 'BACK';

  @override
  String get revealHint => 'Shouted? Tap to reveal';

  @override
  String get nextButton => 'NEXT';

  @override
  String get nextHint => 'Whoever was wrong takes the card';

  @override
  String get playAgainButton => 'PLAY AGAIN';

  @override
  String get playAgainHint => 'Same choices, new questions';

  @override
  String round(int round) {
    return 'ROUND $round';
  }

  @override
  String roundOfTotal(int round, int total) {
    return 'ROUND $round OF $total';
  }

  @override
  String get answerLabel => 'ANSWER';

  @override
  String get factLabel => 'FUN FACT';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get updatesSection => 'UPDATES';

  @override
  String get languageSection => 'LANGUAGE';

  @override
  String get decksSection => 'DECKS';

  @override
  String get checkForUpdates => 'Check for updates';

  @override
  String get checkingForUpdates => 'Checking…';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get upToDate => 'You already have the latest version.';

  @override
  String get updateCheckFailed =>
      'Could not check for updates. Check your connection and try again.';

  @override
  String get importDeck => 'Import deck';

  @override
  String get importDeckHint => 'Add from a JSON file';

  @override
  String deckImported(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
      zero: '0 questions',
    );
    return 'Deck \"$name\" imported with $_temp0.';
  }

  @override
  String get invalidDeckFile => 'This file is not a valid deck.';

  @override
  String get importFailed => 'Could not import this file.';

  @override
  String deckExported(String name) {
    return 'Deck \"$name\" exported.';
  }

  @override
  String get exportFailed => 'Could not export this deck.';

  @override
  String questionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
      zero: '0 questions',
    );
    return '$_temp0';
  }

  @override
  String get setupTitle => 'GAME SETUP';

  @override
  String get noCategoryChosen => 'Choose at least one category.';

  @override
  String get decksLoadFailed => 'Could not load the decks.';

  @override
  String get roundsSection => 'ROUNDS';

  @override
  String get categoriesSection => 'CATEGORIES';

  @override
  String categoriesDetail(int selected, int total) {
    return '$selected of $total';
  }

  @override
  String get infiniteRounds => 'Infinite';

  @override
  String get customRounds => 'Other amount';

  @override
  String get customRoundsTitle => 'How many rounds?';

  @override
  String customRoundsError(int max) {
    return 'Enter a number from 1 to $max';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String deckTileLabel(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
      zero: '0 questions',
    );
    return 'Deck $name, $_temp0';
  }

  @override
  String get noCategories => 'No category chosen';

  @override
  String get searchCategory => 'Search for a category to add';

  @override
  String get allCategoriesInGame => 'All categories are already in the game';

  @override
  String get noCategoryFound => 'No category found';

  @override
  String get selectAll => 'Select all';

  @override
  String removeCategory(String name) {
    return 'Remove $name';
  }

  @override
  String unseenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards in the deck',
      one: '1 card in the deck',
      zero: 'No cards in the deck. Return the cards in settings',
    );
    return '$_temp0';
  }

  @override
  String get startButton => 'START';

  @override
  String get updateDialogTitle => 'New version available';

  @override
  String updateDialogBody(String version) {
    return 'Version v$version of Nem a Pato! Bullet is available.\n\nTap \"Update\" to install what\'s new.';
  }

  @override
  String get later => 'Later';

  @override
  String get update => 'Update';

  @override
  String get releaseNotes => 'Release notes';

  @override
  String get downloadingUpdate => 'Downloading update';

  @override
  String get startingDownload => 'Starting…';

  @override
  String get installPermissionNeeded =>
      'Allow this app to install updates: Android Settings > Apps > Nem a Pato! Bullet > Install unknown apps. Then try again.';

  @override
  String get updateDownloadFailed =>
      'Could not download the update. Check your connection and try again.';

  @override
  String get updateCanceled => 'Update canceled.';

  @override
  String get updateAlreadyRunning => 'An update is already in progress.';

  @override
  String get updateInstallFailed => 'Could not install the update.';

  @override
  String get historySection => 'HISTORY';

  @override
  String get resetHistory => 'Return cards to the deck';

  @override
  String seenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards out of the deck from use',
      one: '1 card out of the deck from use',
      zero: 'No cards out of the deck',
    );
    return '$_temp0';
  }

  @override
  String get resetHistoryTitle => 'Return cards to the deck?';

  @override
  String resetHistoryBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'The $count cards that came up go back to the deck and can appear again.',
      one: 'The card that came up goes back to the deck and can appear again.',
    );
    return '$_temp0';
  }

  @override
  String get resetHistoryConfirm => 'Return';

  @override
  String get historyReset => 'Cards returned. Every card can come up again.';

  @override
  String get historyEmpty => 'No cards are out of the deck.';

  @override
  String get returnCardsButton => 'RETURN CARDS';

  @override
  String get returnCardsHint =>
      'Only the cards from this game go back to the deck';
}
