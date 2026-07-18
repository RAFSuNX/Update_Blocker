# Update Blocker

KernelSU/Magisk module that fully blocks Android OTA updates at the root level — no network/hosts blocking involved.

## What it does

- **Kills the executor**: overlays `/system/bin/update_engine` with a 0-byte file (systemless). Even if an OTA payload were downloaded, nothing can apply it.
- **Kills the trigger**: on every boot (`post-fs-data.sh`), disables the GMS/GSF update-check services and the `factoryota` app via `pm disable`.
- **On-demand cleanup**: tap "Action" for this module in KernelSU Manager to reset `update_engine`'s state and wipe any cached OTA payload files (`/data/ota_package`, GMS `app_dg_cache`).

## Install

Flash the zip via KernelSU Manager (or Magisk) → Modules → Install from storage → reboot.

## Notes

- Disabling the GMS update service may also disable Google Play system updates.
- Disabling the GSF services may affect Google account sync — remove those two lines from `post-fs-data.sh` if you rely on it.
