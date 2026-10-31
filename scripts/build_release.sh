#!/bin/zsh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MODE="${1:-developer-id}"
case "$MODE" in
  developer-id)
    : "${DEVELOPER_ID_APPLICATION:?Set DEVELOPER_ID_APPLICATION to a Developer ID Application certificate name}"
    [[ "$DEVELOPER_ID_APPLICATION" == "Developer ID Application: "* ]] || { echo "Developer ID Application certificate required" >&2; exit 1; }
    security find-identity -v -p codesigning | grep -F -- "\"$DEVELOPER_ID_APPLICATION\"" >/dev/null || { echo "Signing identity unavailable" >&2; exit 1; }
    ;;
  local) ;;
  *) echo "Usage: $0 [developer-id|local]" >&2; exit 1 ;;
esac
DERIVED_DATA="${TMPDIR:-/tmp}/HankakuSpace-build/$MODE/DerivedData"

xcodebuild \
  -project "$ROOT/HankakuSpace.xcodeproj" \
  -scheme HankakuSpace \
  -configuration Release \
  -destination "platform=macOS,arch=arm64" \
  -derivedDataPath "$DERIVED_DATA" \
  CODE_SIGNING_ALLOWED=NO \
  clean build

APP="$DERIVED_DATA/Build/Products/Release/HankakuSpace.app"
test -d "$APP"
xattr -cr "$APP"
if [[ "$MODE" == local ]]; then
  codesign --force --options runtime --sign - "$APP"
else
  codesign --force --options runtime --timestamp --sign "$DEVELOPER_ID_APPLICATION" "$APP"
fi
codesign --verify --deep --strict "$APP"

echo "$APP"
