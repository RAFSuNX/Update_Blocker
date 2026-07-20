#!/system/bin/sh
# Runs automatically when this module is removed via KernelSU Manager/Magisk.
# update_engine is restored automatically (systemless overlay, real /system
# untouched) — this only needs to undo the persistent pm disable-user state.

. "$(dirname "$(readlink -f "$0")")/common.sh"

if ! factoryota_exists; then
  log -t UpdateBlocker "uninstall: $FACTORYOTA_PKG not found on this device, nothing to re-enable"
elif ! factoryota_disabled; then
  log -t UpdateBlocker "uninstall: $FACTORYOTA_PKG already enabled, nothing to do"
else
  log -t UpdateBlocker "uninstall: re-enabling $FACTORYOTA_PKG"
  pm enable "$FACTORYOTA_PKG"
fi
