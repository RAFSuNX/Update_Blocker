#!/system/bin/sh
# Shared constant + package-status helpers, sourced by
# service.sh/action.sh/uninstall.sh so this logic lives in one place.

FACTORYOTA_PKG=com.google.android.factoryota

factoryota_exists() {
  pm list packages 2>/dev/null | grep -q ":$FACTORYOTA_PKG$"
}

factoryota_disabled() {
  pm list packages -d 2>/dev/null | grep -q ":$FACTORYOTA_PKG$"
}
