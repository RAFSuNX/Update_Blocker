#!/system/bin/sh
# service.sh does not reliably run after boot_completed on this KernelSU
# build (confirmed via device logcat: service.sh executed ~6s BEFORE
# on_boot_completed fired), so `pm disable-user` can race Package Manager
# not being ready yet. Retry with a bounded ceiling instead of assuming stage
# ordering. ponytail: bounded retry, 30 tries * 2s = 60s cap; if boot is ever
# slower than that, use the module's Action button as a manual fallback.

. "$(dirname "$(readlink -f "$0")")/common.sh"

if [ -z "$BLOCKED_PKGS" ]; then
  log -t UpdateBlocker "boot: no devices.json entry for '$DEVICE_KEY', nothing to disable"
  exit 0
fi

log -t UpdateBlocker "boot: attempting to disable [$BLOCKED_PKGS] (retrying up to 60s for Package Manager to come up)"

i=0
pending="$BLOCKED_PKGS"
while [ $i -lt 30 ] && [ -n "$pending" ]; do
  still_pending=""
  for pkg in $pending; do
    if pkg_disabled "$pkg"; then
      log -t UpdateBlocker "boot: $pkg already disabled"
      continue
    fi
    if pm disable-user --user 0 "$pkg" >/dev/null 2>&1; then
      log -t UpdateBlocker "boot: $pkg disabled after ${i}x2s retries"
    else
      still_pending="$still_pending $pkg"
    fi
  done
  pending="$still_pending"
  [ -z "$pending" ] && exit 0
  sleep 2
  i=$((i + 1))
done

# Loop exhausted: tell logcat whether it's a timeout (retry via Action
# button) or the package genuinely doesn't exist on this device.
for pkg in $pending; do
  if pkg_exists "$pkg"; then
    log -t UpdateBlocker "pm disable-user timed out after 60s for $pkg; use the module's Action button to retry manually"
  else
    log -t UpdateBlocker "$pkg not found on this device; skipping disable"
  fi
done
