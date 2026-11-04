#!/usr/bin/env bash
# Builds a signed release APK, ready to attach to a GitHub release.
# The version comes from pubspec.yaml (`version: 1.0.0+1000000`).
#
#   tool/build_release.sh   -> tag v1.0.0
#
# versionCode = major*1000000 + minor*10000 + patch*100, so it always grows
# (Android refuses updates with a lower or equal versionCode).
set -euo pipefail

# --- Version from pubspec.yaml -------------------------------------------
pubspec_version=$(sed -n 's/^version:[[:space:]]*//p' pubspec.yaml)
[[ $pubspec_version =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+)$ ]] ||
  { echo "pubspec.yaml version must look like 1.0.0+1000000 (got '$pubspec_version')" >&2; exit 1; }
major=${BASH_REMATCH[1]}
minor=${BASH_REMATCH[2]}
patch=${BASH_REMATCH[3]}
pubspec_code=${BASH_REMATCH[4]}
version="$major.$minor.$patch"

version_code=$((major * 1000000 + minor * 10000 + patch * 100))
[[ $pubspec_code == "$version_code" ]] ||
  { echo "pubspec.yaml: version $version must be $version+$version_code (got +$pubspec_code)" >&2; exit 1; }

tag="v$version"

[[ -f android/key.properties ]] ||
  { echo "android/key.properties is missing (see android/key.properties.example)" >&2; exit 1; }

if [[ -n $(git status --porcelain) ]]; then
  echo "warning: uncommitted changes — this APK won't match any commit" >&2
fi

flutter build apk --release \
  --build-name="$version" \
  --build-number="$version_code"

mkdir -p build/release
apk="build/release/nem-a-pato-bullet-${tag#v}.apk"
cp build/app/outputs/flutter-apk/app-release.apk "$apk"

echo
echo "Tag:          $tag"
echo "versionCode:  $version_code"
echo "Commit:       $(git rev-parse --short HEAD)"
echo "APK:          $apk"
