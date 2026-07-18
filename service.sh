#!/system/bin/sh
# Runs after boot_completed, once Package Manager is actually available
# (unlike post-fs-data, which runs too early for `pm` commands to work).

pm disable-user --user 0 com.google.android.factoryota
