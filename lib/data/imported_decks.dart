import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/deck.dart';
import '../domain/text_key.dart';

/// Decks the player imported, kept as JSON files in app-private storage.
class ImportedDecks {
  ImportedDecks({Future<Directory> Function()? directory})
    : _directory = directory ?? _defaultDirectory;

  final Future<Directory> Function() _directory;

  static Future<Directory> _defaultDirectory() async {
    final support = await getApplicationSupportDirectory();
    return Directory('${support.path}/decks');
  }

  /// Every stored deck. A file that can't be read is skipped, so one bad
  /// deck doesn't keep the others from loading.
  Future<List<Deck>> load() async {
    final folder = await _directory();
    if (!folder.existsSync()) return [];
    final decks = <Deck>[];
    for (final file in folder.listSync().whereType<File>()) {
      try {
        decks.add(Deck.fromJsonString(await file.readAsString()));
      } on FormatException catch (error) {
        debugPrint('Skipping deck ${file.path}: ${error.message}');
      }
    }
    return decks;
  }

  /// Validates [source] and stores it, replacing an imported deck with the
  /// same name. Throws a [FormatException] if it isn't a valid deck.
  Future<Deck> save(String source) async {
    final deck = Deck.fromJsonString(source);
    if (deck.questions.isEmpty) {
      throw const FormatException('Deck has no questions');
    }
    final folder = await _directory();
    await folder.create(recursive: true);
    await _file(folder, deck.name).writeAsString(deck.toJsonString());
    return deck;
  }

  /// Removes the imported deck called [name]. Returns false if there was
  /// none.
  Future<bool> delete(String name) async {
    final file = _file(await _directory(), name);
    if (!file.existsSync()) return false;
    await file.delete();
    return true;
  }

  /// One file per deck name, so saving the same name replaces it.
  static File _file(Directory folder, String deckName) {
    final name = sha1.convert(utf8.encode(textKey(deckName))).toString();
    return File('${folder.path}/$name.json');
  }
}
