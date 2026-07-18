#!/system/bin/sh
# This module modifies /system, which requires KernelSU's OverlayFS
# MetaModule to actually take effect. Without it, the system/ overlay
# silently never mounts. Refuse to install rather than fail silently.

if [ ! -d /data/adb/modules/meta-overlayfs ]; then
  abort "! OverlayFS MetaModule (meta-overlayfs) not installed. Install it from KernelSU Manager's module browser first, then flash this module again."
fi
