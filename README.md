# Update Blocker

KernelSU/Magisk module that blocks Android OTA updates at the root level — no network/hosts blocking, and no touching GMS/GSF.

Verified on Pixel 7 Pro (panther), Android 14, build AP2A.240905.003.

## What it does

- **Kills the executor**: at install time, nulls out the OTA-apply binary(s) listed for your device in `devices.json` (systemless, via KernelSU's OverlayFS MetaModule) — e.g. `/system/bin/update_engine` on Pixel. Even if an OTA payload were downloaded, nothing can apply it.
- **Kills the standalone updater(s)**: after boot completes (`service.sh`), disables the OTA app package(s) listed in `devices.json` for your device (e.g. `com.google.android.factoryota`) via `pm disable-user`.
- **Does not touch `com.google.android.gms` or `com.google.android.gsf`** — disabling their update-related components risks breaking Play Integrity, account sync, and Play Store.
- **On-demand cleanup**: tap "Action" for this module in KernelSU Manager to reset `update_engine`'s state and wipe any cached OTA payload files in `/data/ota_package`, listing each file found before deleting it.

## Multi-device support

Which packages to disable and which binaries to null out is per `<device codename>-<Android version>` (e.g. `panther-14`), looked up from [`devices.json`](devices.json) at install time. This is deliberately **not** a "best guess" fallback: if your exact codename+version combo isn't listed, `customize.sh` aborts the install instead of applying possibly-wrong assumptions to unfamiliar hardware.

To add support for your device:
1. Confirm the OTA-apply binary path(s) and OTA app package name(s) on your device/Android version.
2. Add an entry to `devices.json` keyed `"<codename>-<version>"`, e.g.:
   ```json
   "yourdevice-15": {"packages": ["com.example.ota"], "binaries": ["/system/bin/update_engine"]}
   ```
3. Open a PR.

Only Pixel 7 Pro on Android 14 is verified today. Other Pixel codenames very likely share the same package/binary, but haven't been confirmed on real hardware — send a PR once you have.

## Requirements

Modifying `/system` files requires KernelSU's **OverlayFS MetaModule** (`meta-overlayfs`) to be installed as well — install it from the KernelSU Manager module browser before flashing this module (or reflash this module afterward if you installed meta-overlayfs later).

## Install

Flash the zip via KernelSU Manager (or Magisk) → Modules → Install from storage → reboot.

## Uninstall / Reversibility

Remove the module via KernelSU Manager (or Magisk) → reboot.

- The nulled binary(s) are restored automatically — systemless modules only overlay `/system` at boot, the real files on disk are never touched.
- The disabled OTA app package(s) are re-enabled automatically via `uninstall.sh`, which runs on module removal.

No manual cleanup needed either way.

## Credits

The `update_engine` null-binary technique is adapted from [Badabing2005's Block Updates Magisk module](https://github.com/Badabing2005) — the systemless overlay approach for neutralizing the OTA-apply binary is theirs.

The idea of pairing this with `pm disable` for a standalone OTA app came from the "Pixel Systemupdate Block" module (TMW1996 + ChatGPT), though this project targets `factoryota` instead of GMS components to avoid touching Google Play Services.
