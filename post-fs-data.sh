#!/system/bin/sh
# Disable the standalone Factory OTA app at boot. Deliberately does NOT touch
# anything under com.google.android.gms or com.google.android.gsf — those are
# core Google Play Services components and disabling their update-related
# activities/providers risks breaking Play Integrity, account sync, and Play
# Store itself. update_engine itself is neutralized separately via the
# systemless system/bin overlay (see system/bin/update_engine, 0 bytes).

pm disable-user --user 0 com.google.android.factoryota
