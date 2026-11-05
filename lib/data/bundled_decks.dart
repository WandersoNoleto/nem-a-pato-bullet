import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../domain/deck.dart';

const _decksFolder = 'assets/decks/';

/// Every deck shipped inside the app (`assets/decks/*.json`), sorted by
/// name. A deck file that can't be parsed is skipped, so one bad deck
/// doesn't keep the others from loading.
Future<List<Deck>> loadBundledDecks([AssetBundle? bundle]) async {
  final assets = bundle ?? rootBundle;
  final manifest = await AssetManifest.loadFromAssetBundle(assets);
  final paths = manifest
      .listAssets()
      .where((path) => path.startsWith(_decksFolder) && path.endsWith('.json'))
      .toList();

  final decks = <Deck>[];
  for (final path in paths) {
    try {
      decks.add(Deck.fromJsonString(await assets.loadString(path)));
    } on FormatException catch (error) {
      debugPrint('Skipping deck $path: ${error.message}');
    }
  }
  return decks..sort((a, b) => a.name.compareTo(b.name));
}
