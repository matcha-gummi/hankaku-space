#!/bin/zsh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MODE="${1:-developer-id}"
[[ "$MODE" == developer-id || "$MODE" == local ]] || { echo "Usage: $0 [developer-id|local]" >&2; exit 1; }
APP="${TMPDIR:-/tmp}/HankakuSpace-build/$MODE/DerivedData/Build/Products/Release/HankakuSpace.app"
STAGING="$(mktemp -d /tmp/HankakuSpace-dmg.XXXXXX)"
OUTPUT="$ROOT/build/HankakuSpace-signed.dmg"
[[ "$MODE" != local ]] || OUTPUT="$ROOT/build/HankakuSpace-local.dmg"
trap 'rm -rf "$STAGING"' EXIT

"$ROOT/scripts/build_release.sh" "$MODE"

mkdir -p "$ROOT/build"
ditto --noextattr "$APP" "$STAGING/HankakuSpace.app"
codesign --verify --deep --strict "$STAGING/HankakuSpace.app"
ln -s /Applications "$STAGING/Applications"

hdiutil create \
  -volname "Hankaku Space" \
  -srcfolder "$STAGING" \
  -ov \
  -format UDZO \
  "$OUTPUT"

if [[ "$MODE" == developer-id ]]; then
  codesign --force --timestamp --sign "$DEVELOPER_ID_APPLICATION" "$OUTPUT"
  codesign --verify --strict "$OUTPUT"
fi
hdiutil verify "$OUTPUT"
echo "Not ready for distribution: run scripts/notarize_dmg.sh after approving upload to Apple."
echo "$OUTPUT"
