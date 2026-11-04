import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nem_a_pato_bullet/update/app_version.dart';
import 'package:nem_a_pato_bullet/update/update_checker.dart';

Map<String, Object?> _release(
  String tag, {
  bool draft = false,
  bool withApk = true,
  String body = '',
}) => {
  'tag_name': tag,
  'draft': draft,
  'body': body,
  'assets': [
    if (withApk)
      {
        'name': 'nem-a-pato-bullet-${tag.substring(1)}.apk',
        'browser_download_url': 'https://example.com/$tag.apk',
      },
    {'name': 'notes.txt', 'browser_download_url': 'https://example.com/x'},
  ],
};

UpdateChecker _checker(
  List<Map<String, Object?>> releases, {
  int installedCode = 1000000,
  int status = 200,
}) {
  return UpdateChecker(
    client: MockClient(
      (request) async => http.Response(jsonEncode(releases), status),
    ),
    installedVersion: () async => (name: 'x', code: installedCode),
  );
}

void main() {
  group('AppVersion', () {
    test('parses release tags', () {
      final version = AppVersion.parseTag('v1.2.3')!;
      expect(version.code, 1020300);
      expect(version.label, '1.2.3');
    });

    test('ignores other tags', () {
      expect(AppVersion.parseTag('1.2.3'), isNull);
      expect(AppVersion.parseTag('v1.2'), isNull);
      expect(AppVersion.parseTag('v1.2.3-beta.1'), isNull);
    });

    test('codes keep growing across releases', () {
      final versions = [
        'v1.0.0',
        'v1.0.1',
        'v1.1.0',
        'v2.0.0',
      ].map((tag) => AppVersion.parseTag(tag)!.code).toList();
      expect(versions, orderedEquals([...versions]..sort()));
    });
  });

  group('UpdateChecker', () {
    test('returns the newest release', () async {
      final update = await _checker([
        _release('v1.0.1', body: 'Fixes'),
        _release('v1.0.2', body: 'New card'),
      ]).check();

      expect(update!.tag, 'v1.0.2');
      expect(update.notes, 'New card');
      expect(update.apkUrl.toString(), 'https://example.com/v1.0.2.apk');
    });

    test('null when the installed version is the newest', () async {
      final update = await _checker([_release('v1.0.0')]).check();
      expect(update, isNull);
    });

    test('skips drafts and releases without an APK', () async {
      final update = await _checker([
        _release('v1.0.5', draft: true),
        _release('v1.0.4', withApk: false),
        _release('v1.0.3'),
      ]).check();

      expect(update!.tag, 'v1.0.3');
    });

    test('throws when GitHub answers with an error', () async {
      expect(
        _checker([], status: 403).check(),
        throwsA(isA<UpdateCheckException>()),
      );
    });
  });
}
