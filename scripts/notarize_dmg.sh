#!/bin/zsh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# This command explicitly uploads the signed DMG to Apple.
[[ "${1:-}" == --submit-to-apple && $# == 1 ]] || { echo "Usage: $0 --submit-to-apple (uploads signed DMG to Apple)" >&2; exit 1; }
: "${NOTARYTOOL_PROFILE:?Set NOTARYTOOL_PROFILE to an existing Keychain profile}"
SOURCE="$ROOT/build/HankakuSpace-signed.dmg"
test -f "$SOURCE"
codesign --verify --strict "$SOURCE"
codesign --verify --test-requirement='=anchor apple generic and certificate leaf[field.1.2.840.113635.100.6.1.13] exists' "$SOURCE"
WORK="$(mktemp -d "$ROOT/build/notarize.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
DMG="$WORK/HankakuSpace.dmg"
ditto "$SOURCE" "$DMG"
# A failed/rejected submission never replaces the distributable artifact.
xcrun notarytool submit "$DMG" --keychain-profile "$NOTARYTOOL_PROFILE" --wait --output-format plist > "$WORK/result.plist"
[[ "$(/usr/libexec/PlistBuddy -c 'Print :status' "$WORK/result.plist")" == Accepted ]] || { cat "$WORK/result.plist" >&2; exit 1; }
xcrun stapler staple "$DMG"
xcrun stapler validate "$DMG"
codesign --verify --strict "$DMG"
spctl --assess --type open --context context:primary-signature --verbose=2 "$DMG"
hdiutil verify "$DMG"
mkdir -p "$ROOT/dist"
mv -f "$DMG" "$ROOT/dist/HankakuSpace.dmg"
(cd "$ROOT/dist" && shasum -a 256 HankakuSpace.dmg > HankakuSpace.dmg.sha256)
echo "Verified distribution artifact: $ROOT/dist/HankakuSpace.dmg"
