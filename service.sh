#!/system/bin/sh
# service.sh does not reliably run after boot_completed on this KernelSU
# build (confirmed via device logcat: service.sh executed ~6s BEFORE
# on_boot_completed fired), so `pm disable-user` can race Package Manager
# not being ready yet. Retry with a bounded ceiling instead of assuming stage
# ordering. ponytail: bounded retry, 30 tries * 2s = 60s cap; if boot is ever
# slower than that, use the module's Action button as a manual fallback.

i=0
while [ $i -lt 30 ]; do
  pm disable-user --user 0 com.google.android.factoryota >/dev/null 2>&1 && break
  sleep 2
  i=$((i + 1))
done
