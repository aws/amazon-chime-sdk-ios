#!/bin/bash
# Fails if any Objective-C entity in the generated interface lacks the AWSChime
# prefix. The generated header is what collides with other frameworks, so it is
# what this checks -- a grep over the Swift sources also matches internal @objc
# types that never reach the header.
#
# Usage: scripts/check-objc-namespace.sh <path-to-AmazonChimeSDK.framework>
set -euo pipefail

FRAMEWORK=${1:?usage: $0 <path-to-AmazonChimeSDK.framework>}
HEADER="$FRAMEWORK/Headers/AmazonChimeSDK-Swift.h"
SNAPSHOT="$(dirname "$0")/objc-surface.txt"
CACHE_DIR=$(mktemp -d "${TMPDIR:-/tmp}/objc-surface.XXXXXXXX")
trap 'rm -rf "$CACHE_DIR"' EXIT
[ -f "$HEADER" ] || { echo "no generated header at $HEADER"; exit 1; }

extract() {
  # The enum's ObjC underlying type may contain digits or underscores (uint32_t),
  # so the character class must allow them or that enum is silently skipped.
  # @protocol may carry an inheritance clause, so the alternation is required:
  # anchoring to end-of-line silently drops every inheriting protocol.
  {
    grep -oE '^@interface [A-Za-z_0-9]+[[:space:]]*:'    "$1" | awk '{print $2}' | tr -d ':'
    grep -oE '^@protocol [A-Za-z_0-9]+[[:space:]]*(<|$)' "$1" | awk '{print $2}' | tr -d '<'
    # grep -v '^#' drops the SWIFT_ENUM_NAMED macro *definition*, whose
    # parameter list (_type, _name) otherwise matches as a bogus entity.
    grep -v '^#' "$1" | grep -oE 'SWIFT_ENUM(_NAMED)?\([A-Za-z_0-9 ]+, [A-Za-z_0-9]+' | sed 's/.*, //'
  } | sort -u
}

# --self-test proves the extractor can still see the kinds of declaration it is
# meant to police. It regressed once: the SWIFT_ENUM character class lacked
# digits, so a uint32_t-backed enum was silently skipped and one unprefixed
# symbol shipped. Each probe below must be reported as unprefixed.
if [ "${2:-}" = "--self-test" ]; then
  PROBE="$CACHE_DIR/probe.h"
  cat "$HEADER" > "$PROBE"
  cat >> "$PROBE" <<'PROBE_EOF'
@interface SelfTestClass : NSObject
@end
@protocol SelfTestProtocol <NSObject>
@end
typedef SWIFT_ENUM(NSInteger, SelfTestEnumInt, open) { SelfTestEnumIntA = 0 };
typedef SWIFT_ENUM(uint32_t, SelfTestEnumU32, open) { SelfTestEnumU32A = 0 };
PROBE_EOF
  MISSED=""
  FOUND=$(extract "$PROBE")
  for want in SelfTestClass SelfTestProtocol SelfTestEnumInt SelfTestEnumU32; do
    echo "$FOUND" | grep -qx "$want" || MISSED="$MISSED $want"
  done
  if [ -n "$MISSED" ]; then
    echo "SELF-TEST FAIL: the extractor cannot see:$MISSED"
    exit 1
  fi
  echo "SELF-TEST OK: extractor sees classes, inheriting protocols, and both NSInteger- and uint32_t-backed enums."
fi

extract "$HEADER" > "$CACHE_DIR/objc-surface-actual.txt"

# The framework ships hand-written headers alongside the generated one, and they
# are equally reachable from `@import AmazonChimeSDK;`. Report the ones that are
# still unprefixed rather than silently ignoring them: CwtEnum.h is a documented
# exception (its declarations are identical to the copy that ships in the
# prebuilt AmazonChimeSDKMachineLearning), so it is known rather than a failure.
# Hand-written Objective-C declares enums with NS_ENUM or a plain `typedef enum`,
# never the SWIFT_ENUM macros extract() looks for, so it needs its own extractor.
extract_handwritten() {
  {
    grep -oE '^@interface [A-Za-z_0-9]+[[:space:]]*:'    "$1" | awk '{print $2}' | tr -d ':'
    grep -oE '^@protocol [A-Za-z_0-9]+[[:space:]]*(<|$)' "$1" | awk '{print $2}' | tr -d '<'
    grep -oE 'NS_(ENUM|OPTIONS)\([A-Za-z_0-9 ]+, [A-Za-z_0-9]+' "$1" | sed 's/.*, //'
    # plain `typedef enum { ... } Name;` and `typedef struct { ... } Name;`
    grep -oE '^\}[[:space:]]*[A-Za-z_][A-Za-z_0-9]*[[:space:]]*;' "$1" | tr -d '};' | tr -d '[:space:]'
  } | grep -vE '^$' | sort -u
}

UMBRELLA_UNPREFIXED=""
for h in "$FRAMEWORK/Headers"/*.h; do
  case "$(basename "$h")" in AmazonChimeSDK-Swift.h|CwtEnum.h) continue ;; esac
  found=$(extract_handwritten "$h" | grep -v '^AWSChime' || true)
  [ -n "$found" ] && UMBRELLA_UNPREFIXED="$UMBRELLA_UNPREFIXED $(basename "$h"):$(echo "$found" | tr '\n' ',')"
done
# A Swift `@objc public extension` on a SYSTEM class emits an Objective-C
# category, and its selectors are global to that class regardless of any type
# prefix; toJsonString had to be renamed by hand for exactly that reason. Only
# system classes are checked: extensions on our own or on the media framework's
# classes implement delegate protocols, whose selectors are fixed by the protocol.
BAD_SELECTORS=$(awk '
  /^@interface (NS|UI|AV|CA|CG)[A-Za-z_0-9]*(<[^>]*>)?[[:space:]]*\(SWIFT_EXTENSION\(/ { inext=1; next }
  /^@interface/ { inext=0 }
  /^@end/ { inext=0 }
  inext && /^[-+] \(/ {
    if (match($0, /\)[A-Za-z_][A-Za-z_0-9]*/)) {
      sel=substr($0, RSTART+1, RLENGTH-1)
      if (sel !~ /^awsChime/) print sel
    }
  }' "$HEADER" | sort -u || true)
if [ -n "$BAD_SELECTORS" ]; then
  echo "FAIL: category selectors on a system class without an awsChime prefix:"
  echo "$BAD_SELECTORS" | sed 's/^/  /'
  echo "A category method collides on that class by selector, so a type prefix cannot fix it."
  exit 1
fi

if [ -n "$UMBRELLA_UNPREFIXED" ]; then
  echo "FAIL: unprefixed Objective-C entities in hand-written framework headers:$UMBRELLA_UNPREFIXED"
  echo "These are not reached by @objc(...); rename them and add NS_SWIFT_NAME to pin the Swift name."
  exit 1
fi
UNPREFIXED=$(grep -vc '^AWSChime' "$CACHE_DIR/objc-surface-actual.txt" || true)
if [ "$UNPREFIXED" != "0" ]; then
  echo "FAIL: $UNPREFIXED Objective-C entities are missing the AWSChime prefix:"
  grep -v '^AWSChime' "$CACHE_DIR/objc-surface-actual.txt" | sed 's/^/  /'
  echo "Add @objc(AWSChime<Name>) to the declaration, or NS_SWIFT_NAME for hand-written Objective-C."
  exit 1
fi

# --update-snapshot writes the snapshot with THIS extractor and THIS sort, so the
# snapshot and the check cannot drift apart (a hand-generated snapshot differed
# only in collation order and made the check fail on an identical symbol set).
if [ "${2:-}" = "--update-snapshot" ] || [ "${3:-}" = "--update-snapshot" ]; then
  cp "$CACHE_DIR/objc-surface-actual.txt" "$SNAPSHOT"
  echo "Updated $SNAPSHOT with $(wc -l < "$SNAPSHOT" | tr -d ' ') entities."
  exit 0
fi

if ! diff -u "$SNAPSHOT" "$CACHE_DIR/objc-surface-actual.txt"; then
  echo "FAIL: the Objective-C surface changed. If intended, update $SNAPSHOT"
  echo "and add the new symbols to guides/objc_migration.md."
  exit 1
fi

echo "OK: $(wc -l < "$CACHE_DIR/objc-surface-actual.txt") Objective-C entities, all AWSChime-prefixed, snapshot matches."
