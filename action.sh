#!/system/bin/sh
# Runs from KernelSU Manager's "Action" button for this module.
# Resets update_engine state and clears any cached OTA payloads.

. "$(dirname "$(readlink -f "$0")")/common.sh"

update_engine_client --reset_status
rm -rf /data/ota_package/*
rm -rf /data/data/com.google.android.gms/app_dg_cache/*

if pm list packages 2>/dev/null | grep -q ":$FACTORYOTA_PKG$"; then
  pm disable-user --user 0 "$FACTORYOTA_PKG"
  echo "Update Blocker: update_engine reset, OTA cache cleared, factoryota disabled"
else
  echo "Update Blocker: update_engine reset, OTA cache cleared ($FACTORYOTA_PKG not found on this device, skipped)"
fi
