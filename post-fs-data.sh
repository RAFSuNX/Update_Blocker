#!/system/bin/sh
# Disable the OTA trigger/check services at boot. Root-level pm disable only —
# no hosts/network changes. update_engine itself is neutralized via the
# systemless system/bin overlay (see system/bin/update_engine, 0 bytes).

pm disable com.google.android.gms/.update.SystemUpdateService
pm disable "com.google.android.gms/.update.SystemUpdateService\$ActiveService"
pm disable "com.google.android.gms/.update.SystemUpdateService\$Receiver"
pm disable "com.google.android.gms/.update.SystemUpdateService\$SecretCodeReceiver"
pm disable com.google.android.gsf/.update.SystemUpdateService
pm disable "com.google.android.gsf/.update.SystemUpdateService\$Receiver"
pm disable-user --user 0 com.google.android.factoryota
