#!/system/bin/sh
# Runs from KernelSU Manager's "Action" button for this module.
# Resets update_engine state and clears any cached OTA payloads.

update_engine_client --reset_status
rm -rf /data/ota_package/*
rm -rf /data/data/com.google.android.gms/app_dg_cache/*
pm disable-user --user 0 com.google.android.factoryota
echo "Update Blocker: update_engine reset, OTA cache cleared, factoryota disabled"
