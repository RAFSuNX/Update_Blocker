#!/system/bin/sh
# This module modifies /system, which requires KernelSU's OverlayFS
# MetaModule to actually take effect. Without it, the system/ overlay
# silently never mounts. Refuse to install rather than fail silently.

if [ ! -d /data/adb/modules/meta-overlayfs ]; then
  abort "! OverlayFS MetaModule (meta-overlayfs) not installed. Install it from KernelSU Manager's module browser first, then flash this module again."
fi

. "$MODPATH/common.sh"

if [ "$DEVICE_VERIFIED" != "1" ]; then
  abort "! No devices.json entry for '$DEVICE_KEY'. This module doesn't guess at unlisted device/Android combos. Open a PR adding '$DEVICE_KEY' to devices.json (packages to disable, binaries to null out) once you've confirmed the right targets for your device."
fi

ui_print "- Update Blocker: device/version '$DEVICE_KEY' verified in devices.json"

for bin in $BLOCKED_BINARIES; do
  target="$MODPATH$bin"
  mkdir -p "$(dirname "$target")"
  : > "$target"
  chmod 644 "$target"
  ui_print "- Update Blocker: nulled $bin"
done
