#!/system/bin/sh
# Runs automatically when this module is removed via KernelSU Manager/Magisk.
# update_engine is restored automatically (systemless overlay, real /system
# untouched) — this only needs to undo the persistent pm disable-user state.

. "$(dirname "$(readlink -f "$0")")/common.sh"

for pkg in $BLOCKED_PKGS; do
  if ! pkg_exists "$pkg"; then
    log -t UpdateBlocker "uninstall: $pkg not found on this device, nothing to re-enable"
  elif ! pkg_disabled "$pkg"; then
    log -t UpdateBlocker "uninstall: $pkg already enabled, nothing to do"
  else
    log -t UpdateBlocker "uninstall: re-enabling $pkg"
    pm enable "$pkg"
  fi
done
