#!/system/bin/sh
# service.sh does not reliably run after boot_completed on this KernelSU
# build (confirmed via device logcat: service.sh executed ~6s BEFORE
# on_boot_completed fired), so `pm disable-user` can race Package Manager
# not being ready yet. Retry with a bounded ceiling instead of assuming stage
# ordering. ponytail: bounded retry, 30 tries * 2s = 60s cap; if boot is ever
# slower than that, use the module's Action button as a manual fallback.

. "$(dirname "$(readlink -f "$0")")/common.sh"

log -t UpdateBlocker "boot: attempting to disable $FACTORYOTA_PKG (retrying up to 60s for Package Manager to come up)"

i=0
while [ $i -lt 30 ]; do
  if factoryota_disabled; then
    log -t UpdateBlocker "boot: $FACTORYOTA_PKG already disabled"
    exit 0
  fi
  if pm disable-user --user 0 "$FACTORYOTA_PKG" >/dev/null 2>&1; then
    log -t UpdateBlocker "boot: $FACTORYOTA_PKG disabled after ${i}x2s retries"
    exit 0
  fi
  sleep 2
  i=$((i + 1))
done

# Loop exhausted: tell logcat whether it's a timeout (retry via Action
# button) or the package genuinely doesn't exist on this device.
if factoryota_exists; then
  log -t UpdateBlocker "pm disable-user timed out after 60s; use the module's Action button to retry manually"
else
  log -t UpdateBlocker "$FACTORYOTA_PKG not found on this device; skipping disable"
fi
