import 'dart:convert';

import 'package:file_picker/file_picker.dart';

/// Reads and writes deck files the player chooses on the device.
class DeckFiles {
  const DeckFiles();

  /// The text of the chosen file, or null if the player canceled.
  ///
  /// Any file type can be chosen because Android often doesn't recognize
  /// `.json` files; the content is validated when importing.
  Future<String?> pick() async {
    final file = await FilePicker.pickFile();
    if (file == null) return null;
    return utf8.decode(await file.readAsBytes());
  }

  /// Saves [content] where the player chooses. False if they canceled.
  Future<bool> save({required String fileName, required String content}) async {
    final uri = await FilePicker.saveFile(
      fileName: fileName,
      bytes: utf8.encode(content),
      mimeType: 'application/json',
    );
    return uri != null;
  }
}

/// A file name for a deck, like "conhecimentos-gerais.json".
String deckFileName(String deckName) {
  const accents = {
    'á': 'a',
    'à': 'a',
    'â': 'a',
    'ã': 'a',
    'é': 'e',
    'ê': 'e',
    'í': 'i',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ú': 'u',
    'ü': 'u',
    'ç': 'c',
  };
  final plain = deckName.toLowerCase().split('').map((c) => accents[c] ?? c);
  final slug = plain
      .join()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
  return '${slug.isEmpty ? 'baralho' : slug}.json';
}
