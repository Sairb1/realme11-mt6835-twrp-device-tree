# TWRP Device Tree — Realme 11 Series (ossi)

> TWRP 12.1 (Android 14 base)  
> Codename: ossi (MT6835)

---

## Device Info

| Property | Value |
|---|---|
| Device | Realme 11 / 11x / Narzo 60X / C67 5G |
| SoC | MediaTek Dimensity 6100+ (MT6835) |
| Architecture | ARM64 |
| Android Base | 14 (Vendor SDK 33) |
| Boot Type | Virtual A/B (GKI, vendor_boot) |
| Encryption | FBE v2 (Fully Working) |

---

## Status

| Feature | Status |
|---|---|
| Booting | ✅ |
| Touch | ✅ |
| Display | ✅ |
| Decryption (/data) | ✅ |
| MTP | ✅ |
| ADB | ✅ |
| Fastbootd | ✅ |
| Flash ZIP | ✅ |
| Backup / Restore | ✅ |

---

## What Was Fixed

### Mount & Partition Issues
- Fixed wrong partition names (MT6983 → MT6835)
- Removed invalid / dead fstab entries
- Fixed logical partition mounting (my_* partitions)
- Corrected `/data` block path

---

### Decryption (FBE v2)
- Fixed broken `fileencryption` flags
- Corrected `keydirectory` parsing (semicolon issue)
- Enabled proper metadata encryption handling
- Added missing flags like `fsverity`

---

### First Stage Mount
- Added missing AVB keys (`oplus_avb.pubkey`)
- Fixed logical partition tree loading
- Resolved AVB verification stalls

---

### init.rc Fixes
- Removed conflicting vold services
- Removed useless userdata polling loop
- Removed invalid keymaster services
- Fixed early-init execution issues
- Properly initialized KeyMint (TEE)

---

### KeyMint / TEE
- Replaced incorrect Keymaster 4.x usage
- Implemented Trustonic KeyMint 2.0 properly
- Enabled real hardware-backed decryption

---

### BoardConfig & Device Fixes
- Fixed security patch mismatch (AVB rollback issues)
- Corrected architecture configs
- Fixed vendor SDK mismatch
- Cleaned broken flags

---

### General Cleanup
- Removed MT6983 configs
- Removed unused partitions
- Added only required blobs

---

## Build Instructions

```bash
mkdir -p ~/twrp/device/realme
cd ~/twrp/device/realme

git clone https://github.com/Sairb1/realme11-mt6835-device-tree.git
mv mt6835-dt ossi

cd ~/twrp
source build/envsetup.sh
lunch RE5C6CL1_ossi-eng

mka vendorbootimage -j$(nproc)

---
```
---
### Credits
Credits
- Device Tree Base: @notpiyushbro and @HuTao77-Studio
- Developer: @suchit_7x
- Contributions: @imnotaino - sairb1
- Tester: @Zuhaan

---
Community
- Telegram: https://t.me/realme11x
---
