# Nem a Pato! Bullet

A simplified, fan-made digital version of the *Nem a Pato!* mechanic: everyone guesses a number, each guess higher than the last, without going over the real answer. If you think the last guess went too far, shout **"Nem a Pato!"** to challenge it, and whoever was wrong takes the card.

A non-profit study project built with Flutter, made to play with friends.

## Credits

Inspired by [*Nem a Pato!*](https://loja.grokgames.com.br/nem-a-pato), designed by **Rodrigo Rego** and published in Brazil by **Grok Games** (original edition: *How Dare You?*, Alion). This project is not affiliated with or endorsed by Grok Games or the designer.

## Decks

The app does not ship the original game's questions. Questions live in JSON decks, kept separate from the code:

- `assets/decks/sample.json`: a sample deck with original questions.
- `decks/private/`: personal decks; ignored by Git and never published.

Deck format:

```json
{
  "id": "sample",
  "name": "Sample deck",
  "version": 1,
  "cards": [
    {
      "theme": "Espaço",
      "ducks": 2,
      "questions": [
        { "n": 1, "text": "Quantos planetas tem o Sistema Solar?", "answer": 8, "unit": "planetas", "fact": "Plutão virou planeta-anão em 2006." }
      ]
    }
  ]
}
```

Each card has a theme, a duck value (used as a tiebreaker) and 6 questions numbered 1 to 6, all with numeric answers. Deck content can be in any language; the sample deck is in Brazilian Portuguese.

## Running

```bash
flutter pub get
flutter run
```

## License

The source code is licensed under [MIT](LICENSE). The *Nem a Pato!* name and the mascot derived from Grok Games' character are **not** covered by this license.
