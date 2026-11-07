import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @back.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get back;

  /// No description provided for @settingsTooltip.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settingsTooltip;

  /// No description provided for @playButton.
  ///
  /// In pt, this message translates to:
  /// **'JOGAR'**
  String get playButton;

  /// No description provided for @credits.
  ///
  /// In pt, this message translates to:
  /// **'Inspirado em \"Nem a Pato!\", de Rodrigo Rego · Grok Games'**
  String get credits;

  /// No description provided for @updateAvailable.
  ///
  /// In pt, this message translates to:
  /// **'Atualização disponível!'**
  String get updateAvailable;

  /// No description provided for @outOfQuestionsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Acabaram as cartas!'**
  String get outOfQuestionsTitle;

  /// No description provided for @outOfQuestionsBody.
  ///
  /// In pt, this message translates to:
  /// **'Todas as cartas escolhidas para esta partida já saíram. Devolva as cartas ao baralho para continuar jogando.'**
  String get outOfQuestionsBody;

  /// No description provided for @gameOverTitle.
  ///
  /// In pt, this message translates to:
  /// **'Fim da partida!'**
  String get gameOverTitle;

  /// No description provided for @gameOverBody.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 rodada jogada} other{{count} rodadas jogadas}}. Quem ficou com mais cartas é o pato da mesa.'**
  String gameOverBody(int count);

  /// No description provided for @backButton.
  ///
  /// In pt, this message translates to:
  /// **'VOLTAR'**
  String get backButton;

  /// No description provided for @revealHint.
  ///
  /// In pt, this message translates to:
  /// **'Gritou? Toque para revelar'**
  String get revealHint;

  /// No description provided for @nextButton.
  ///
  /// In pt, this message translates to:
  /// **'PRÓXIMA'**
  String get nextButton;

  /// No description provided for @nextHint.
  ///
  /// In pt, this message translates to:
  /// **'Quem errou fica com a carta'**
  String get nextHint;

  /// No description provided for @playAgainButton.
  ///
  /// In pt, this message translates to:
  /// **'JOGAR DE NOVO'**
  String get playAgainButton;

  /// No description provided for @playAgainHint.
  ///
  /// In pt, this message translates to:
  /// **'Mesmas escolhas, perguntas novas'**
  String get playAgainHint;

  /// No description provided for @round.
  ///
  /// In pt, this message translates to:
  /// **'RODADA {round}'**
  String round(int round);

  /// No description provided for @roundOfTotal.
  ///
  /// In pt, this message translates to:
  /// **'RODADA {round} DE {total}'**
  String roundOfTotal(int round, int total);

  /// No description provided for @answerLabel.
  ///
  /// In pt, this message translates to:
  /// **'RESPOSTA'**
  String get answerLabel;

  /// No description provided for @factLabel.
  ///
  /// In pt, this message translates to:
  /// **'CURIOSIDADE'**
  String get factLabel;

  /// No description provided for @settingsTitle.
  ///
  /// In pt, this message translates to:
  /// **'CONFIGURAÇÕES'**
  String get settingsTitle;

  /// No description provided for @updatesSection.
  ///
  /// In pt, this message translates to:
  /// **'ATUALIZAÇÕES'**
  String get updatesSection;

  /// No description provided for @languageSection.
  ///
  /// In pt, this message translates to:
  /// **'IDIOMA'**
  String get languageSection;

  /// No description provided for @decksSection.
  ///
  /// In pt, this message translates to:
  /// **'BARALHOS'**
  String get decksSection;

  /// No description provided for @checkForUpdates.
  ///
  /// In pt, this message translates to:
  /// **'Procurar atualização'**
  String get checkForUpdates;

  /// No description provided for @checkingForUpdates.
  ///
  /// In pt, this message translates to:
  /// **'Procurando…'**
  String get checkingForUpdates;

  /// No description provided for @versionLabel.
  ///
  /// In pt, this message translates to:
  /// **'Versão {version}'**
  String versionLabel(String version);

  /// No description provided for @upToDate.
  ///
  /// In pt, this message translates to:
  /// **'Você já está na versão mais recente.'**
  String get upToDate;

  /// No description provided for @updateCheckFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não deu para procurar atualização. Verifique a internet e tente de novo.'**
  String get updateCheckFailed;

  /// No description provided for @importDeck.
  ///
  /// In pt, this message translates to:
  /// **'Importar baralho'**
  String get importDeck;

  /// No description provided for @importDeckHint.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar de um arquivo JSON'**
  String get importDeckHint;

  /// No description provided for @deckImported.
  ///
  /// In pt, this message translates to:
  /// **'Baralho \"{name}\" importado com {count, plural, =0{0 perguntas} =1{1 pergunta} other{{count} perguntas}}.'**
  String deckImported(String name, int count);

  /// No description provided for @invalidDeckFile.
  ///
  /// In pt, this message translates to:
  /// **'Esse arquivo não é um baralho válido.'**
  String get invalidDeckFile;

  /// No description provided for @importFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não deu para importar esse arquivo.'**
  String get importFailed;

  /// No description provided for @deckExported.
  ///
  /// In pt, this message translates to:
  /// **'Baralho \"{name}\" exportado.'**
  String deckExported(String name);

  /// No description provided for @exportFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não deu para exportar esse baralho.'**
  String get exportFailed;

  /// No description provided for @questionCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{0 perguntas} =1{1 pergunta} other{{count} perguntas}}'**
  String questionCount(int count);

  /// No description provided for @setupTitle.
  ///
  /// In pt, this message translates to:
  /// **'PREPARAR PARTIDA'**
  String get setupTitle;

  /// No description provided for @noCategoryChosen.
  ///
  /// In pt, this message translates to:
  /// **'Escolha pelo menos uma categoria.'**
  String get noCategoryChosen;

  /// No description provided for @decksLoadFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não deu para carregar os baralhos.'**
  String get decksLoadFailed;

  /// No description provided for @roundsSection.
  ///
  /// In pt, this message translates to:
  /// **'RODADAS'**
  String get roundsSection;

  /// No description provided for @categoriesSection.
  ///
  /// In pt, this message translates to:
  /// **'CATEGORIAS'**
  String get categoriesSection;

  /// No description provided for @categoriesDetail.
  ///
  /// In pt, this message translates to:
  /// **'{selected} de {total}'**
  String categoriesDetail(int selected, int total);

  /// No description provided for @infiniteRounds.
  ///
  /// In pt, this message translates to:
  /// **'Infinitas'**
  String get infiniteRounds;

  /// No description provided for @customRounds.
  ///
  /// In pt, this message translates to:
  /// **'Outra quantidade'**
  String get customRounds;

  /// No description provided for @customRoundsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Quantas rodadas?'**
  String get customRoundsTitle;

  /// No description provided for @customRoundsError.
  ///
  /// In pt, this message translates to:
  /// **'Digite um número de 1 a {max}'**
  String customRoundsError(int max);

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @deckTileLabel.
  ///
  /// In pt, this message translates to:
  /// **'Baralho {name}, {count, plural, =0{0 perguntas} =1{1 pergunta} other{{count} perguntas}}'**
  String deckTileLabel(String name, int count);

  /// No description provided for @noCategories.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma categoria escolhida'**
  String get noCategories;

  /// No description provided for @searchCategory.
  ///
  /// In pt, this message translates to:
  /// **'Buscar categoria para adicionar'**
  String get searchCategory;

  /// No description provided for @allCategoriesInGame.
  ///
  /// In pt, this message translates to:
  /// **'Todas as categorias já estão na partida'**
  String get allCategoriesInGame;

  /// No description provided for @noCategoryFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma categoria encontrada'**
  String get noCategoryFound;

  /// No description provided for @selectAll.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar todas'**
  String get selectAll;

  /// No description provided for @removeCategory.
  ///
  /// In pt, this message translates to:
  /// **'Remover {name}'**
  String removeCategory(String name);

  /// No description provided for @unseenCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{Nenhuma carta no baralho. Devolva as cartas nas configurações} =1{1 carta no baralho} other{{count} cartas no baralho}}'**
  String unseenCount(int count);

  /// No description provided for @startButton.
  ///
  /// In pt, this message translates to:
  /// **'COMEÇAR'**
  String get startButton;

  /// No description provided for @updateDialogTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nova versão disponível'**
  String get updateDialogTitle;

  /// No description provided for @updateDialogBody.
  ///
  /// In pt, this message translates to:
  /// **'A versão v{version} do Nem a Pato! Bullet está disponível.\n\nToque em \"Atualizar\" para instalar as novidades.'**
  String updateDialogBody(String version);

  /// No description provided for @later.
  ///
  /// In pt, this message translates to:
  /// **'Depois'**
  String get later;

  /// No description provided for @update.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar'**
  String get update;

  /// No description provided for @releaseNotes.
  ///
  /// In pt, this message translates to:
  /// **'Release notes'**
  String get releaseNotes;

  /// No description provided for @downloadingUpdate.
  ///
  /// In pt, this message translates to:
  /// **'Baixando atualização'**
  String get downloadingUpdate;

  /// No description provided for @startingDownload.
  ///
  /// In pt, this message translates to:
  /// **'Iniciando…'**
  String get startingDownload;

  /// No description provided for @installPermissionNeeded.
  ///
  /// In pt, this message translates to:
  /// **'Permita que este app instale atualizações: Configurações do Android > Apps > Nem a Pato! Bullet > Instalar apps desconhecidos. Depois tente de novo.'**
  String get installPermissionNeeded;

  /// No description provided for @updateDownloadFailed.
  ///
  /// In pt, this message translates to:
  /// **'Falha ao baixar a atualização. Verifique a internet e tente de novo.'**
  String get updateDownloadFailed;

  /// No description provided for @updateCanceled.
  ///
  /// In pt, this message translates to:
  /// **'Atualização cancelada.'**
  String get updateCanceled;

  /// No description provided for @updateAlreadyRunning.
  ///
  /// In pt, this message translates to:
  /// **'Uma atualização já está em andamento.'**
  String get updateAlreadyRunning;

  /// No description provided for @updateInstallFailed.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao instalar a atualização.'**
  String get updateInstallFailed;

  /// No description provided for @historySection.
  ///
  /// In pt, this message translates to:
  /// **'HISTÓRICO'**
  String get historySection;

  /// No description provided for @resetHistory.
  ///
  /// In pt, this message translates to:
  /// **'Devolver cartas ao baralho'**
  String get resetHistory;

  /// No description provided for @seenCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{Nenhuma carta fora do baralho} =1{1 carta fora do baralho por uso} other{{count} cartas fora do baralho por uso}}'**
  String seenCount(int count);

  /// No description provided for @resetHistoryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Devolver cartas ao baralho?'**
  String get resetHistoryTitle;

  /// No description provided for @resetHistoryBody.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{A carta que já saiu volta ao baralho e pode aparecer de novo.} other{As {count} cartas que já saíram voltam ao baralho e podem aparecer de novo.}}'**
  String resetHistoryBody(int count);

  /// No description provided for @resetHistoryConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Devolver'**
  String get resetHistoryConfirm;

  /// No description provided for @historyReset.
  ///
  /// In pt, this message translates to:
  /// **'Cartas devolvidas. Todas podem aparecer de novo.'**
  String get historyReset;

  /// No description provided for @historyEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma carta fora do baralho.'**
  String get historyEmpty;

  /// No description provided for @returnCardsButton.
  ///
  /// In pt, this message translates to:
  /// **'DEVOLVER CARTAS'**
  String get returnCardsButton;

  /// No description provided for @returnCardsHint.
  ///
  /// In pt, this message translates to:
  /// **'Só as cartas desta partida voltam ao baralho'**
  String get returnCardsHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
