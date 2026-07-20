#!/system/bin/sh
# Runs from KernelSU Manager's "Action" button for this module.
# Resets update_engine state and clears any cached OTA payloads.
# Output here is shown live to the user in the Action dialog, so every
# step reports what it found and what it did about it.

. "$(dirname "$(readlink -f "$0")")/common.sh"

echo "Update Blocker: resetting update_engine state..."
if update_engine_client --reset_status; then
  echo "Update Blocker: update_engine state reset OK"
else
  echo "Update Blocker: update_engine_client --reset_status failed (exit $?)"
fi

ota_dir=/data/ota_package
ota_count=0
[ -d "$ota_dir" ] && ota_count=$(ls -A "$ota_dir" 2>/dev/null | wc -l)
if [ "$ota_count" -gt 0 ]; then
  echo "Update Blocker: found $ota_count file(s) in $ota_dir, deleting"
  rm -rf "${ota_dir:?}"/*
else
  echo "Update Blocker: $ota_dir empty or missing, nothing to delete"
fi

gms_cache_dir=/data/data/com.google.android.gms/app_dg_cache
gms_count=0
[ -d "$gms_cache_dir" ] && gms_count=$(ls -A "$gms_cache_dir" 2>/dev/null | wc -l)
if [ "$gms_count" -gt 0 ]; then
  echo "Update Blocker: found $gms_count file(s) in $gms_cache_dir, deleting"
  rm -rf "${gms_cache_dir:?}"/*
else
  echo "Update Blocker: $gms_cache_dir empty or missing, nothing to delete"
fi

if pm list packages 2>/dev/null | grep -q ":$FACTORYOTA_PKG$"; then
  echo "Update Blocker: $FACTORYOTA_PKG present, disabling..."
  if pm disable-user --user 0 "$FACTORYOTA_PKG" >/dev/null 2>&1; then
    echo "Update Blocker: $FACTORYOTA_PKG disabled"
  else
    echo "Update Blocker: failed to disable $FACTORYOTA_PKG"
  fi
else
  echo "Update Blocker: $FACTORYOTA_PKG not found on this device, skipped"
fi

echo "Update Blocker: done"
