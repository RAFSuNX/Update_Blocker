#!/system/bin/sh
# Runs from KernelSU Manager's "Action" button for this module.
# Resets update_engine state and clears any cached OTA payloads.
# Output here is shown live to the user in the Action dialog, so every
# step reports what it found and what it did about it.

. "$(dirname "$(readlink -f "$0")")/common.sh"

if command -v update_engine_client >/dev/null 2>&1; then
  echo "Update Blocker: resetting update_engine state..."
  if update_engine_client --reset_status; then
    echo "Update Blocker: update_engine state reset OK"
  else
    echo "Update Blocker: update_engine_client --reset_status failed (exit $?)"
  fi
else
  echo "Update Blocker: update_engine_client not present on this device, skipped"
fi

clean_dir() {
  dir="$1"
  if [ ! -d "$dir" ]; then
    echo "Update Blocker: $dir missing, nothing to delete"
    return
  fi
  entries=$(find "$dir" -mindepth 1 -maxdepth 1 2>/dev/null)
  if [ -z "$entries" ]; then
    echo "Update Blocker: $dir empty, nothing to delete"
    return
  fi
  echo "Update Blocker: found in $dir:"
  echo "$entries" | while IFS= read -r path; do
    echo "  - ${path#"$dir"/}"
  done
  find "${dir:?}" -mindepth 1 -delete
  echo "Update Blocker: deleted $(echo "$entries" | wc -l) item(s) from $dir"
}

clean_dir /data/ota_package

if [ -z "$BLOCKED_PKGS" ]; then
  echo "Update Blocker: no devices.json entry for '$DEVICE_KEY', nothing to disable"
fi

for pkg in $BLOCKED_PKGS; do
  if ! pkg_exists "$pkg"; then
    echo "Update Blocker: $pkg not found on this device, skipped"
  elif pkg_disabled "$pkg"; then
    echo "Update Blocker: $pkg already disabled, nothing to do"
  else
    echo "Update Blocker: $pkg enabled, disabling..."
    if pm disable-user --user 0 "$pkg" >/dev/null 2>&1; then
      echo "Update Blocker: $pkg disabled"
    else
      echo "Update Blocker: failed to disable $pkg"
    fi
  fi
done

echo "Update Blocker: done"
