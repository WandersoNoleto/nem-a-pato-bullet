#!/usr/bin/env bash
# Builds signed demo APKs: separate apps ("Nem a Pato! Demo PT/EN") that
# install next to the regular one, start in their language, never check for
# updates and ship only the decks in decks/demo/<locale>/. The decks are
# copied into assets/decks/ only for the build and the bundled sample deck is
# set aside, so regular releases never change.
#
#   tool/build_demo.sh          -> both demos
#   tool/build_demo.sh pt-BR    -> build/release/nem-a-pato-bullet-demo-pt-BR.apk
#   tool/build_demo.sh en-US    -> build/release/nem-a-pato-bullet-demo-en-US.apk
#
# The file names carry no version, so the README can link to
# releases/latest/download/<name> and the link never goes stale.
set -euo pipefail

[[ -f android/key.properties ]] ||
  { echo "android/key.properties is missing (see android/key.properties.example)" >&2; exit 1; }

locales=("$@")
[[ ${#locales[@]} -gt 0 ]] || locales=(pt-BR en-US)

version=$(sed -n 's/^version:[[:space:]]*\([0-9.]*\)+.*/\1/p' pubspec.yaml)
code=$(sed -n 's/^version:[[:space:]]*[0-9.]*+\([0-9]*\).*/\1/p' pubspec.yaml)

copied=()
sample_aside=""
cleanup() {
  rm -f "${copied[@]}"
  [[ -z $sample_aside ]] || mv "$sample_aside" assets/decks/sample.json
}
trap cleanup EXIT

# The sample deck is in Portuguese and only a placeholder; demos show their
# own decks.
sample_aside=$(mktemp)
mv assets/decks/sample.json "$sample_aside"

mkdir -p build/release
for locale in "${locales[@]}"; do
  case $locale in
    pt-BR) language=pt ;;
    en-US) language=en ;;
    *) echo "Unknown locale '$locale' (use pt-BR or en-US)" >&2; exit 1 ;;
  esac
  decks=(decks/demo/"$locale"/*.json)
  [[ -e ${decks[0]} ]] || { echo "No decks in decks/demo/$locale/" >&2; exit 1; }

  rm -f "${copied[@]}"
  copied=()
  for deck in "${decks[@]}"; do
    target="assets/decks/demo-$(basename "$deck")"
    cp "$deck" "$target"
    copied+=("$target")
  done

  flutter build apk --release \
    --build-name="$version" \
    --build-number="$code" \
    --dart-define=DEMO_LANGUAGE="$language" \
    --android-project-arg=demo="$language"

  apk="build/release/nem-a-pato-bullet-demo-$locale.apk"
  cp build/app/outputs/flutter-apk/app-release.apk "$apk"
  echo
  echo "Demo $locale: ${#copied[@]} decks"
  echo "APK:          $apk"
done
