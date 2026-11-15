![Nem a Pato! Bullet](docs/banner.webp)

# Nem a Pato! Bullet

[![Latest release](https://img.shields.io/github/v/release/WandersoNoleto/nem-a-pato-bullet?color=E8590F)](https://github.com/WandersoNoleto/nem-a-pato-bullet/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/WandersoNoleto/nem-a-pato-bullet/total?color=FFC61A)](https://github.com/WandersoNoleto/nem-a-pato-bullet/releases)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Android](https://img.shields.io/badge/Android-3DDC84?logo=android&logoColor=white)](https://github.com/WandersoNoleto/nem-a-pato-bullet/releases/latest)
[![Languages](https://img.shields.io/badge/languages-PT%20%7C%20EN-111111)](#features)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A fan-made, **offline** card deck for playing the trivia party game *Nem a Pato!* at the table. Everyone guesses a number, each guess higher than the last, without going over the real answer. Think the last guess went too far? Shout **"Nem a Pato!"**, flip the card and see who was wrong.

> [!NOTE]
> Unofficial fan project based on the board game *Nem a Pato!*. See the [credits](#credits).

**[Download the APK](https://github.com/WandersoNoleto/nem-a-pato-bullet/releases/latest)** · **[How to play](#how-to-play)** · **[Features](#features)** · **[Screens](#screens)** · **[Decks](#decks)** · **[Build from source](#build-from-source)** · **[Credits](#credits)**

<p align="center">
  <img src=".github/assets/home.png" width="200" alt="Home screen with the duck mascot riding a bullet train and the PLAY button">
  <img src=".github/assets/setup.png" width="200" alt="Game setup with rounds, decks and categories">
  <img src=".github/assets/question.png" width="200" alt="A question card in the Ocean category with the NEM A PATO! button">
  <img src=".github/assets/answer.png" width="200" alt="The card flipped, showing the answer and a fun fact">
</p>

## How to play

The app is the deck; the game happens at the table.

1. **Set up the game:** pick the number of rounds, the decks and the categories, then tap **START**.
2. **Read the card** out loud. Every answer is a number.
3. **Guess around the table:** each player says a number higher than the last one, trying not to go over the answer.
4. **Challenge:** when someone thinks the last guess went too far, they shout "Nem a Pato!" and tap the button to flip the card.
5. **Whoever loses the challenge is out of the game.** The last player standing wins.

> [!NOTE]
> The app only shows the cards: it doesn't track players, eliminations or how many cards each one has. That part stays at the table. If you'd rather play the classic way, keep score yourselves: whoever loses a challenge takes a card, and the player with the most cards at the end is the duck of the table.

## Features

### Playing

- **Rules at hand:** the info button on the home screen opens how to play, step by step, with a reminder that the score stays at the table.
- **3D card flip:** tap "Nem a Pato!" to flip the card and reveal the answer and a fun fact. A short vibration marks the moment.
- **No repeats:** cards that came up stay out of the deck, even after closing the app. When a game runs out of cards, return only that game's cards and keep playing; return every card from the settings.
- **Round counter:** the top of the game shows the current round, and the total when the game has a limit.

### Game setup

- **Rounds:** infinite (the default), 5, 10, 15, 20 or a custom number up to 999.
- **Decks:** pick one or more decks from a grid that fits the screen, three per row on a typical phone.
- **Categories:** every category of the chosen decks starts selected. Remove one with a tap, search to add it back, or select all again.
- **Cards left:** the setup shows how many unused cards the choices leave in the deck.

### Decks

- **Deck details:** tap a deck in the settings to see its categories and questions. Answers stay hidden until you tap a question, so you can browse without spoiling the game.
- **Your own decks:** import decks from JSON files, export any deck to share it, and delete the ones you imported. Deleting a deck also lets its cards come up again if you import it later.
- **Comes with the app:** decks shipped with the app are labeled and can't be deleted. Importing a deck with the same name replaces it until you delete the imported one.
- **Deck symbols:** each deck can have its own SVG symbol, shown in the setup, the settings and the deck page.

### App

- **Light and dark themes:** a yellow theme and a dark one, switched in the settings and remembered on the device.
- **Portuguese and English:** the app's texts switch language; deck content always stays exactly as written.
- **Fits any screen:** small phones, large phones and tablets, and larger system font sizes. On tablets the game keeps a phone-like width.
- **Auto-update:** the app checks GitHub Releases when it opens and offers new versions; the download shows the mascot train on its way. You can also check by hand in the settings.
- **Fully offline**, portrait, made for Android.

## Screens

<table>
  <tr>
    <td align="center" width="25%"><img src=".github/assets/home.png" alt="Home screen with the duck mascot riding a bullet train, the PLAY button and the info and settings buttons"><br><sub><b>Home</b><br>Play, rules and settings</sub></td>
    <td align="center" width="25%"><img src=".github/assets/rules.png" alt="How to play dialog with five numbered steps and a note that the app doesn't keep score"><br><sub><b>How to play</b><br>The rules, one tap away</sub></td>
    <td align="center" width="25%"><img src=".github/assets/setup.png" alt="Game setup with the rounds options, three deck tiles per row and the categories as removable tags"><br><sub><b>Game setup</b><br>Rounds, decks and categories</sub></td>
    <td align="center" width="25%"><img src=".github/assets/question.png" alt="A question card in the Ocean category with the NEM A PATO! button"><br><sub><b>Question</b><br>Read it out loud and guess</sub></td>
  </tr>
  <tr>
    <td align="center"><img src=".github/assets/answer.png" alt="The card flipped, showing the answer and a fun fact, with the NEXT button"><br><sub><b>Answer</b><br>The card flips to reveal it</sub></td>
    <td align="center"><img src=".github/assets/settings.png" alt="Settings with updates, theme, language, card history and the list of decks"><br><sub><b>Settings</b><br>Theme, language, history and decks</sub></td>
    <td align="center"><img src=".github/assets/deck.png" alt="Deck page with the deck name, export and delete buttons, and its questions by category with one answer shown"><br><sub><b>Deck</b><br>Questions by category, answers on tap</sub></td>
    <td align="center"><img src=".github/assets/question-dark.png" alt="A question card in the dark theme, over a subtle sunburst"><br><sub><b>Dark theme</b><br>Every screen, switched in the settings</sub></td>
  </tr>
</table>

<details>
<summary>More screens in the dark theme</summary>

<p align="center">
  <img src=".github/assets/home-dark.png" width="200" alt="Home screen in the dark theme, with the yellow title and PLAY button">
  <img src=".github/assets/rules-dark.png" width="200" alt="How to play dialog in the dark theme">
  <img src=".github/assets/setup-dark.png" width="200" alt="Game setup in the dark theme">
  <img src=".github/assets/answer-dark.png" width="200" alt="The flipped card in the dark theme">
  <img src=".github/assets/settings-dark.png" width="200" alt="Settings in the dark theme with the Dark option selected">
  <img src=".github/assets/deck-dark.png" width="200" alt="Deck page in the dark theme">
</p>

</details>

## Install

Download `nem-a-pato-bullet-<version>.apk` from the **[latest release](https://github.com/WandersoNoleto/nem-a-pato-bullet/releases/latest)** and open it on your Android phone. Android will ask you to allow installs from this source.

After that, the app offers new versions by itself when it opens.

## Decks

The app does not ship the original game's questions. Questions live in JSON decks, kept separate from the code:

- `assets/decks/sample.json`: a sample deck with original questions, bundled with the app.
- `decks/demo/`: extra decks with original questions, used for demo builds.
- `decks/private/`: personal decks; ignored by Git and never published.

Players can also import decks from the settings screen. A deck with the same name as an existing one replaces it. Imported decks can be exported or deleted from their page in the settings; decks bundled with the app can only be exported.

| Field | Required | Notes |
| --- | --- | --- |
| `name` | yes | Deck name shown in the game setup |
| `icon` | no | Deck symbol as inline SVG, painted in the app's ink color; a playing-card symbol is shown when missing |
| `questions` | yes | List of questions, fields below |
| `category` | yes | Shown above the question |
| `text` | yes | The question |
| `answer` | yes | Shown exactly as written |
| `fact` | no | Shown with the answer when present |

<details>
<summary>Example deck</summary>

```json
{
  "name": "Sample deck",
  "icon": "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\">...</svg>",
  "questions": [
    {
      "category": "Espaço",
      "text": "Quantos planetas tem o Sistema Solar?",
      "answer": "8 planetas",
      "fact": "Plutão foi reclassificado como planeta-anão em 2006."
    }
  ]
}
```

</details>

Question ids are not part of the file: the app derives each one from the category and text, so a question is never repeated, even after re-importing its deck. Deck content can be in any language; the sample deck is in Brazilian Portuguese.

## Build from source

Requires Flutter (stable).

```bash
flutter pub get
flutter run
```

<details>
<summary>Tests, screenshots and releases</summary>

**Tests**

```bash
flutter analyze
flutter test
```

**README screenshots**, rendered from the real screens in English:

```bash
UPDATE_SCREENSHOTS=1 flutter test test/screenshots
```

**Signed release APK.** Needs `android/key.properties` (see `android/key.properties.example`). The version comes from `pubspec.yaml`, as `X.Y.Z+code` with code = X×1000000 + Y×10000 + Z×100:

```bash
tool/build_release.sh
```

Then publish a GitHub release tagged `vX.Y.Z` with the APK attached, so the auto-update finds it.

**Demo APK** with the decks in `decks/demo/`:

```bash
tool/build_demo.sh
```

</details>

## Credits

Inspired by [*Nem a Pato!*](https://loja.grokgames.com.br/nem-a-pato), designed by **Rodrigo Rego** and published in Brazil by **Grok Games** (original edition: *How Dare You?*, Alion). This is a non-profit study project, not affiliated with or endorsed by Grok Games or the designer.

## License

The source code is licensed under [MIT](LICENSE). The *Nem a Pato!* name and the mascot derived from Grok Games' character are **not** covered by this license.
