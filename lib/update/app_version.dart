/// A release version as published on GitHub, tagged `v1.2.3`.
///
/// [code] follows the same formula as tool/build_release.sh, so it can be
/// compared with the installed app's versionCode.
class AppVersion implements Comparable<AppVersion> {
  const AppVersion(this.major, this.minor, this.patch);

  final int major;
  final int minor;
  final int patch;

  int get code => major * 1000000 + minor * 10000 + patch * 100;

  /// "1.2.3".
  String get label => '$major.$minor.$patch';

  static final _tagPattern = RegExp(r'^v(\d+)\.(\d+)\.(\d+)$');

  /// Parses a `v1.2.3` tag; anything else gives null.
  static AppVersion? parseTag(String tag) {
    final match = _tagPattern.firstMatch(tag);
    if (match == null) return null;
    return AppVersion(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    );
  }

  @override
  int compareTo(AppVersion other) => code.compareTo(other.code);
}
