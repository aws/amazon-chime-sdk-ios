#!/bin/bash
# Compiles a translation unit that imports the SDK's generated Objective-C
# interface alongside a second framework declaring the same bare names
# (scripts/collision-probe/FakeVendorSDK.framework, standing in for Cisco
# WebexConnectCore v3.0.6). Objective-C classes, protocols and NS_ENUM types
# share one global namespace, so if any SDK symbol loses its AWSChime prefix
# Clang reports:
#
#   'Logger' has different definitions in different modules; first difference is
#   definition in module 'AmazonChimeSDK.Swift' found 0 referenced protocols
#
# The check is the compile: it passes only while the SDK and the fake vendor
# framework can coexist in one translation unit.
#
# Usage: scripts/check-objc-collision.sh <path-to-built-products-dir>
set -euo pipefail

PRODUCTS=${1:?usage: $0 <path-to-built-products-dir containing AmazonChimeSDK.framework>}
HERE="$(cd "$(dirname "$0")" && pwd)"
PROBE="$HERE/collision-probe"
[ -d "$PRODUCTS/AmazonChimeSDK.framework" ] || { echo "no AmazonChimeSDK.framework in $PRODUCTS"; exit 1; }

CACHE=$(mktemp -d "${TMPDIR:-/tmp}/objc-collision.XXXXXXXX")
trap 'rm -rf "$CACHE"' EXIT

if xcrun -sdk iphonesimulator clang \
      -fmodules -fsyntax-only -w \
      -target arm64-apple-ios15.0-simulator \
      -F "$PRODUCTS" -F "$PROBE" \
      -fmodules-cache-path="$CACHE/modules" \
      "$PROBE/main.m" > "$CACHE/out.log" 2>&1; then
  echo "OK: the SDK coexists with a framework declaring Logger, ConsoleLogger, Meeting, Attendee, VideoTileState and LogLevel."
  exit 0
fi

echo "FAIL: the SDK collides with another framework's Objective-C symbols."
echo
grep -E "different definitions|error:" "$CACHE/out.log" | head -20 | sed 's/^/  /'
echo
echo "An Objective-C-visible symbol is missing its AWSChime prefix. Add"
echo "@objc(AWSChime<Name>) to the Swift declaration, or NS_SWIFT_NAME for"
echo "hand-written Objective-C. See guides/objc_migration.md."
exit 1
