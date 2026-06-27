# TWRP Device Tree - Realme 11 (chongqing) - Android 15

## Device Information
- **Device**: Realme 11 5G
- **Codename**: chongqing (formerly RE5C6CL1)
- **Model**: RMX3780 / RMX3781 / RMX3782 / RMX3783 / RMX3785
- **SoC**: MediaTek Dimensity 6100+ (MT6835)
- **Android**: 15 (SDK 35)
- **Kernel**: 5.15.180-android13-8
- **Build Date**: June 2026

---

## Key Changes from A14 → A15 Device Tree

### 1. fstab & twrp.flags Changes (CRITICAL)
| Partition / Flag | A14 | A15 |
|------------------|-----|-----|
| `odm` partition AVB | no avb_keys | `avb_keys=/vendor/etc/oplus_avb.pubkey` |
| `my_*` partitions AVB | no avb_keys | `avb_keys=/vendor/etc/oplus_avb.pubkey` |
| `userdata` options | `v2+inlinecrypt_optimized,fsverity` | Added **`fscompress`** |
| `sspm` / `dpm` / `mcupm` / `lk` | Legacy single/double partition names | Kept stock dual slot layout (e.g. `sspm_1`, `sspm_2`) for bootability |
| `/sdcard` mount entry | Mapped raw device block in `twrp.flags` | **REMOVED** mapping to let TWRP's built-in `datamedia` engine bind-mount `/data/media/0` to `/sdcard` after decryption. Resolves the 0MB folder encryption lag and enables USB MTP. |
| `/persist_image` mount point | `/persist_image` | Renamed entry to `/mnt/vendor/persist` in `twrp.flags` to match init. Removes the `Device or resource busy` mount warning during boot. |
| New partitions | — | `ccu_a/b`, `vcp_a/b`, `connsys_wifi_a/b`, `connsys_bt_a/b`, `connsys_gnss_a/b`, `init_boot` |

### 2. Security HAL Changes (CRITICAL)
| Component | A14 | A15 |
|-----------|-----|-----|
| KeyMaster/KeyMint | `android.hardware.keymaster@4.1` | **`android.hardware.security.keymint@2.0`** |
| KeyMint binary | `/system/bin/android.hardware.security.keymint-service.trustonic` | `/vendor/bin/hw/android.hardware.security.keymint@2.0-service.trustonic` |
| Gatekeeper binary | `/system/bin/android.hardware.gatekeeper@1.0-service` | `/vendor/bin/hw/android.hardware.gatekeeper@1.0-service` |
| MobiCore Daemon | `/system/bin/mcDriverDaemon` | `/vendor/bin/mcDriverDaemon` |

### 3. Vibration & Haptics Optimization (FIXED)
* **The Problem**: The stock Oppo vibrator AIDL HAL service (`vendor.oplus.vibrator-default`) failed to initialize because the recovery kernel doesn't expose the advanced sysfs control files (`oplus_activate`, `activate`, `duration`), causing process crash loops and severe touchscreen lag. If it starts, it registers a broken binder interface that blocks TWRP from using the direct path.
* **The Solution**: Redefined `vendor.oplus.vibrator-default` in `init.recovery.mt6835.rc` as a dummy instant-exit service mapping to `/system/bin/toybox` and removed the custom `vibrator-default.rc` and A15 binary. This stops the AIDL HAL from registering, forcing TWRP to use the standard kernel direct path:
  ```makefile
  TW_CUSTOM_VIBRATOR_PATH := /sys/class/leds/vibrator/brightness
  ```
  *(Note: Even with direct writing enabled, physical vibration during button presses in recovery does not function. This is a hard kernel limitation: the prebuilt recovery kernel powers down the PMIC voltage regulator LDO connected to the vibration motor to conserve battery in recovery, meaning the hardware has 0V power supplied to it.)*

### 4. Timezone & Clock Synchronization (FIXED)
* **The Problem**: Oppo/Realme stock firmware saves your local Indian Standard Time (IST) directly into the hardware RTC chip instead of UTC. When TWRP boots, the system clock is already on local time. Setting a non-zero timezone offset like `IST-5:30` causes TWRP to shift the clock forward by another 5:30 (e.g. from 18:05 to 23:35) immediately after data decryption (since TWRP reads and applies the Android settings databases from your decrypted `/data` partition on successful decryption). On shutdown, TWRP writes this shifted time back to the RTC, causing your Android clock to reset and show the wrong time on boot.
* **The Solution**: Set the default timezone offset to `GMT0` and properties to `GMT`:
  - Defined the default offset in `BoardConfig.mk` with double quotes:
    ```makefile
    TW_DEFAULT_TIME_ZONE := "GMT0"
    ```
  - Hardcoded the property-level default timezone in `system.prop`:
    ```properties
    persist.sys.timezone=GMT
    ```
  Since the hardware clock is already running on local time, an offset of 0 reads it directly without shifting it after decryption, keeping both your TWRP and Android clocks perfectly synced!

### 5. CPU Temperature scaling (FIXED)
* **The Problem**: Recovery mode powers down core SoC thermal zones to save power, returning `Invalid argument`. The PMIC battery node (`/sys/class/power_supply/battery/temp`) works but returns values in tenths of a degree (e.g. `480` for 48.0°C). TWRP treats values under 1000 as direct Celsius; because 480°C exceeds the 150°C safety limit, TWRP filtered it to 0°C.
* **The Solution**:
  - Pointed TWRP to `/tmp/cpu_temp` in `BoardConfig.mk`:
    ```makefile
    TW_CUSTOM_CPU_TEMP_PATH := /tmp/cpu_temp
    ```
  - Added a background loop script `/system/bin/cpu_temp.sh` running as a service in `init.recovery.mt6835.rc`. The script reads `/sys/class/power_supply/battery/temp`, multiplies it by 100 (e.g. `480 -> 48000`), and writes it to `/tmp/cpu_temp` every 5 seconds. TWRP divides `48000` by 1000 and displays **`48°C`** on screen.

### 6. Codename Refactoring
* Renamed all legacy A14 reference directories and configuration scripts from `RE5C6CL1` to **`chongqing`**.
* Renamed `twrp_RE5C6CL1.mk` to `twrp_chongqing.mk`.

---

## Directory Structure
```
device/realme/chongqing/
├── Android.mk                ← Updated target name to chongqing
├── AndroidProducts.mk        ← Updated products to twrp_chongqing.mk
├── BoardConfig.mk            ← PLATFORM_VERSION=15, /tmp/cpu_temp, haptics file path, GMT0
├── device.mk                 ← keymint@2.0, new AB_OTA_PARTITIONS
├── system.prop               ← ro.build.version.sdk=35, persist.sys.timezone=GMT
├── twrp_chongqing.mk         ← Updated device target details
├── recovery.fstab            ← All A15 fstab changes applied
├── prebuilt/
│   └── dtb.img               ← A15 stock prebuilt DTB (184,111 bytes)
├── bootctrl/                 ← Boot control block
├── mtk_plpath_utils/         ← PL path link utilities
└── recovery/
    └── root/
        ├── init.recovery.mt6835.rc   ← Added cpu_temp_loop service, disabled vibrator service (toybox override)
        ├── tee.rc                     ← Added camera dir creation
        ├── trustonic.rc               ← mcDriverDaemon path updated to vendor
        ├── ueventd.mt6835.rc
        ├── init.recovery.usb.rc
        ├── first_stage_ramdisk/
        │   ├── fstab.mt6835           ← All A15 fstab changes
        │   └── fstab.emmc             ← All A15 fstab changes
        ├── system/
        │   └── bin/
        │       └── cpu_temp.sh        ← NEW: battery temp PMIC scaling daemon
        │   └── etc/
        │       └── twrp.flags         ← Removed /sdcard conflict, renamed /persist_image
        ├── lib/modules/               ← A15 kernel modules
        └── vendor/
            ├── bin/
            │   ├── mcDriverDaemon     ← Pulled from device
            │   └── hw/
            │       ├── android.hardware.security.keymint@2.0-service.trustonic
            │       └── android.hardware.gatekeeper@1.0-service
            ├── etc/
            │   ├── oplus_avb.pubkey   ← NEW: AVB public key for odm & my_*
            │   ├── ueventd.rc
            │   └── vintf/
            └── app/mcRegistry/        ← drbin registry files
```

---

## Building
```bash
make installclean
source build/envsetup.sh
lunch twrp_chongqing-eng
mka recoveryimage
```

## Flashing
```bash
fastboot flash vendor_boot out/target/product/chongqing/vendor_boot.img
```

---

## Important Notes
- ⚠️ The `oplus_avb.pubkey` is MANDATORY for A15 — without it, `odm` and all `my_*` partitions will FAIL to mount.
- ⚠️ KeyMint @2.0 (not @4.1) must be used — decryption will fail otherwise.
- ⚠️ `mobicore` daemon configuration: Must keep the recovery-specific `seclabel u:r:recovery:s0`, `disabled` flag, and run under `root`/`root` to avoid SELinux domain transition issues during recovery decryption.
- ⚠️ `fscompress` in userdata fstab entry is A15-specific — must match device kernel support.
