#!/system/bin/sh
# Runs automatically when this module is removed via KernelSU Manager/Magisk.
# update_engine is restored automatically (systemless overlay, real /system
# untouched) — this only needs to undo the persistent pm disable-user state.

. "$(dirname "$(readlink -f "$0")")/common.sh"

pm enable "$FACTORYOTA_PKG"
