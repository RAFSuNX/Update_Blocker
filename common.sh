#!/system/bin/sh
# Per-device, per-Android-version config (which packages to disable, which
# binaries to null out, which cache dirs to clear) lives in devices.json
# next to this script, keyed as "<codename>-<android release version>"
# (e.g. "panther-14"), since the right packages/paths can change across OS
# versions on the same hardware. Unlisted combinations are NOT supported —
# customize.sh aborts install rather than guessing. Add your device+version
# to devices.json and open a PR.

MODDIR="${MODPATH:-$(dirname "$(readlink -f "$0")")}"
DEVICES_JSON="$MODDIR/devices.json"
DEVICE=$(getprop ro.product.device 2>/dev/null)
ANDROID_VERSION=$(getprop ro.build.version.release 2>/dev/null)
DEVICE_KEY="${DEVICE}-${ANDROID_VERSION}"

# Minimal single-line JSON extractor: no jq on stock Android, and the file's
# shape is constrained to one flat "key": {"packages":[...],"binaries":[...]}
# per line, no nested brackets.
json_array_field() {
  # $1 = json line, $2 = field name
  echo "$1" | sed -n "s/.*\"$2\"[[:space:]]*:[[:space:]]*\[\([^]]*\)\].*/\1/p" | tr -d '"' | tr ',' ' '
}

device_line=$(grep "\"$DEVICE_KEY\":" "$DEVICES_JSON" 2>/dev/null)
if [ -n "$device_line" ]; then
  DEVICE_VERIFIED=1
  BLOCKED_PKGS=$(json_array_field "$device_line" packages)
  BLOCKED_BINARIES=$(json_array_field "$device_line" binaries)
  BLOCKED_CACHE_DIRS=$(json_array_field "$device_line" cache_dirs)
else
  DEVICE_VERIFIED=0
  BLOCKED_PKGS=""
  BLOCKED_BINARIES=""
  BLOCKED_CACHE_DIRS=""
fi

pkg_exists() {
  pm list packages 2>/dev/null | grep -q ":$1$"
}

pkg_disabled() {
  pm list packages -d 2>/dev/null | grep -q ":$1$"
}
