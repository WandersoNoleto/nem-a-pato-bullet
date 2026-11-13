// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get back => 'Voltar';

  @override
  String get settingsTooltip => 'Configurações';

  @override
  String get rulesTooltip => 'Como jogar';

  @override
  String get rulesTitle => 'COMO JOGAR';

  @override
  String get rulesSetup =>
      'Escolha as rodadas, os baralhos e as categorias e toque em COMEÇAR.';

  @override
  String get rulesRead =>
      'Leia a carta em voz alta. Toda resposta é um número.';

  @override
  String get rulesGuess =>
      'Na roda, cada um fala um número maior que o anterior, tentando não passar da resposta.';

  @override
  String get rulesChallenge =>
      'Achou que o último chute passou? Grite \"Nem a Pato!\" e toque no botão para virar a carta.';

  @override
  String get rulesOut =>
      'Quem perde o desafio está fora do jogo. O último que sobrar vence.';

  @override
  String get rulesNote =>
      'O app só mostra as cartas: não guarda jogadores, eliminações nem placar. Isso fica com a mesa. Quer jogar no modo clássico? Quem perde o desafio pega uma carta, e quem tiver mais no fim é o pato da mesa.';

  @override
  String get rulesClose => 'ENTENDI';

  @override
  String get playButton => 'JOGAR';

  @override
  String get credits =>
      'Inspirado em \"Nem a Pato!\", de Rodrigo Rego · Grok Games';

  @override
  String get updateAvailable => 'Atualização disponível!';

  @override
  String get outOfQuestionsTitle => 'Acabaram as cartas!';

  @override
  String get outOfQuestionsBody =>
      'Todas as cartas escolhidas para esta partida já saíram. Devolva as cartas desta partida ao baralho para continuar jogando.';

  @override
  String get gameOverTitle => 'Fim da partida!';

  @override
  String gameOverBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rodadas jogadas',
      one: '1 rodada jogada',
    );
    return '$_temp0. Quem ainda está no jogo vence. Sobrou mais de um? Joguem de novo para desempatar.';
  }

  @override
  String get backButton => 'VOLTAR';

  @override
  String get revealHint => 'Gritou? Toque para revelar';

  @override
  String get nextButton => 'PRÓXIMA';

  @override
  String get nextHint => 'Errou? Tá fora do jogo!';

  @override
  String get playAgainButton => 'JOGAR DE NOVO';

  @override
  String get playAgainHint => 'Mesmas escolhas, perguntas novas';

  @override
  String round(int round) {
    return 'RODADA $round';
  }

  @override
  String roundOfTotal(int round, int total) {
    return 'RODADA $round DE $total';
  }

  @override
  String get answerLabel => 'RESPOSTA';

  @override
  String get factLabel => 'CURIOSIDADE';

  @override
  String get settingsTitle => 'CONFIGURAÇÕES';

  @override
  String get updatesSection => 'ATUALIZAÇÕES';

  @override
  String get languageSection => 'IDIOMA';

  @override
  String get decksSection => 'BARALHOS';

  @override
  String get checkForUpdates => 'Procurar atualização';

  @override
  String get checkingForUpdates => 'Procurando…';

  @override
  String versionLabel(String version) {
    return 'Versão $version';
  }

  @override
  String get upToDate => 'Você já está na versão mais recente.';

  @override
  String get updateCheckFailed =>
      'Não deu para procurar atualização. Verifique a internet e tente de novo.';

  @override
  String get importDeck => 'Importar baralho';

  @override
  String get importDeckHint => 'Adicionar de um arquivo JSON';

  @override
  String deckImported(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perguntas',
      one: '1 pergunta',
      zero: '0 perguntas',
    );
    return 'Baralho \"$name\" importado com $_temp0.';
  }

  @override
  String get invalidDeckFile => 'Esse arquivo não é um baralho válido.';

  @override
  String get importFailed => 'Não deu para importar esse arquivo.';

  @override
  String deckExported(String name) {
    return 'Baralho \"$name\" exportado.';
  }

  @override
  String get exportFailed => 'Não deu para exportar esse baralho.';

  @override
  String questionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perguntas',
      one: '1 pergunta',
      zero: '0 perguntas',
    );
    return '$_temp0';
  }

  @override
  String get setupTitle => 'PREPARAR PARTIDA';

  @override
  String get noCategoryChosen => 'Escolha pelo menos uma categoria.';

  @override
  String get decksLoadFailed => 'Não deu para carregar os baralhos.';

  @override
  String get roundsSection => 'RODADAS';

  @override
  String get categoriesSection => 'CATEGORIAS';

  @override
  String categoriesDetail(int selected, int total) {
    return '$selected de $total';
  }

  @override
  String get infiniteRounds => 'Infinitas';

  @override
  String get customRounds => 'Outra quantidade';

  @override
  String get customRoundsTitle => 'Quantas rodadas?';

  @override
  String customRoundsError(int max) {
    return 'Digite um número de 1 a $max';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String deckTileLabel(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perguntas',
      one: '1 pergunta',
      zero: '0 perguntas',
    );
    return 'Baralho $name, $_temp0';
  }

  @override
  String get noCategories => 'Nenhuma categoria escolhida';

  @override
  String get searchCategory => 'Buscar categoria para adicionar';

  @override
  String get allCategoriesInGame => 'Todas as categorias já estão na partida';

  @override
  String get noCategoryFound => 'Nenhuma categoria encontrada';

  @override
  String get selectAll => 'Selecionar todas';

  @override
  String removeCategory(String name) {
    return 'Remover $name';
  }

  @override
  String unseenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartas no baralho',
      one: '1 carta no baralho',
      zero: 'Nenhuma carta no baralho. Devolva as cartas nas configurações',
    );
    return '$_temp0';
  }

  @override
  String get startButton => 'COMEÇAR';

  @override
  String get updateDialogTitle => 'Nova versão disponível';

  @override
  String updateDialogBody(String version) {
    return 'A versão v$version do Nem a Pato! Bullet está disponível.\n\nToque em \"Atualizar\" para instalar as novidades.';
  }

  @override
  String get later => 'Depois';

  @override
  String get update => 'Atualizar';

  @override
  String get releaseNotes => 'Release notes';

  @override
  String get downloadingUpdate => 'Baixando atualização';

  @override
  String get startingDownload => 'Iniciando…';

  @override
  String get installPermissionNeeded =>
      'Permita que este app instale atualizações: Configurações do Android > Apps > Nem a Pato! Bullet > Instalar apps desconhecidos. Depois tente de novo.';

  @override
  String get updateDownloadFailed =>
      'Falha ao baixar a atualização. Verifique a internet e tente de novo.';

  @override
  String get updateCanceled => 'Atualização cancelada.';

  @override
  String get updateAlreadyRunning => 'Uma atualização já está em andamento.';

  @override
  String get updateInstallFailed => 'Erro ao instalar a atualização.';

  @override
  String get historySection => 'HISTÓRICO';

  @override
  String get resetHistory => 'Devolver todas as cartas ao baralho';

  @override
  String seenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartas usadas fora do baralho',
      one: '1 carta usada fora do baralho',
      zero: 'Nenhuma carta fora do baralho',
    );
    return '$_temp0';
  }

  @override
  String get resetHistoryTitle => 'Devolver todas as cartas ao baralho?';

  @override
  String resetHistoryBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'As $count cartas que já saíram voltam ao baralho e podem aparecer de novo, em todos os baralhos.',
      one: 'A carta que já saiu volta ao baralho e pode aparecer de novo, em qualquer baralho.',
    );
    return '$_temp0';
  }

  @override
  String get resetHistoryConfirm => 'Devolver';

  @override
  String get historyReset => 'Cartas devolvidas. Todas podem aparecer de novo.';

  @override
  String get historyEmpty => 'Nenhuma carta fora do baralho.';

  @override
  String get returnCardsButton => 'DEVOLVER CARTAS DA PARTIDA';

  @override
  String get returnCardsHint =>
      'Cartas de outros baralhos e categorias continuam fora';

  @override
  String get themeSection => 'TEMA';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';
}
