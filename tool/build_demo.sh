#!/usr/bin/env bash
# Builds a signed demo APK that also ships the decks in decks/demo/, to show
# the app off. The decks are copied into assets/decks/ only for this build
# and removed afterwards, so regular releases never include them.
#
#   tool/build_demo.sh   -> build/release/nem-a-pato-bullet-demo.apk
set -euo pipefail

[[ -f android/key.properties ]] ||
  { echo "android/key.properties is missing (see android/key.properties.example)" >&2; exit 1; }

copied=()
cleanup() { rm -f "${copied[@]}"; }
trap cleanup EXIT

for deck in decks/demo/*.json; do
  target="assets/decks/demo-$(basename "$deck")"
  cp "$deck" "$target"
  copied+=("$target")
done

flutter build apk --release

mkdir -p build/release
apk=build/release/nem-a-pato-bullet-demo.apk
cp build/app/outputs/flutter-apk/app-release.apk "$apk"

echo
echo "Demo decks:   ${#copied[@]} (plus the bundled ones)"
echo "APK:          $apk"
