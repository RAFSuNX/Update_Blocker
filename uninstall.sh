#!/system/bin/sh
# Runs automatically when this module is removed via KernelSU Manager/Magisk.
# update_engine is restored automatically (systemless overlay, real /system
# untouched) — this only needs to undo the persistent pm disable-user state.

pm enable com.google.android.factoryota
