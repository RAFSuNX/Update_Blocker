# Update Blocker

KernelSU/Magisk module that blocks Android OTA updates at the root level — no network/hosts blocking, and no touching GMS/GSF.

Verified on Pixel 6 Pro (panther), Android 14, build AP2A.240905.003.

## What it does

- **Kills the executor**: overlays `/system/bin/update_engine` with a 0-byte file (systemless). Even if an OTA payload were downloaded, nothing can apply it.
- **Kills the standalone updater**: after boot completes (`service.sh`), disables `com.google.android.factoryota` via `pm disable-user`.
- **Does not touch `com.google.android.gms` or `com.google.android.gsf`** — disabling their update-related components risks breaking Play Integrity, account sync, and Play Store.
- **On-demand cleanup**: tap "Action" for this module in KernelSU Manager to reset `update_engine`'s state and wipe any cached OTA payload files (`/data/ota_package`, GMS `app_dg_cache`).

## Requirements

Modifying `/system` files requires KernelSU's **OverlayFS MetaModule** (`meta-overlayfs`) to be installed as well — install it from the KernelSU Manager module browser before flashing this module (or reflash this module afterward if you installed meta-overlayfs later).

## Install

Flash the zip via KernelSU Manager (or Magisk) → Modules → Install from storage → reboot.

## Uninstall / Reversibility

Remove the module via KernelSU Manager (or Magisk) → reboot.

- `update_engine` is restored automatically — systemless modules only overlay `/system` at boot, the real binary on disk is never touched.
- `factoryota` is re-enabled automatically via `uninstall.sh`, which runs on module removal.

No manual cleanup needed either way.

## Credits

The `update_engine` null-binary technique is adapted from [Badabing2005's Block Updates Magisk module](https://github.com/Badabing2005) — the systemless overlay approach for neutralizing the OTA-apply binary is theirs.

The idea of pairing this with `pm disable` for a standalone OTA app came from the "Pixel Systemupdate Block" module (TMW1996 + ChatGPT), though this project targets `factoryota` instead of GMS components to avoid touching Google Play Services.
