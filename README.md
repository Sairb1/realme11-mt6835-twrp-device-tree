<div align="center">

# 🔧 TWRP Device Tree — Realme 11 Series (ossi)

### TWRP 12.1 • Android 14 Base • MT6835 Platform

<img src="https://img.shields.io/badge/TWRP-12.1-blueviolet?style=for-the-badge&logo=android"/>
<br/>
<img src="https://img.shields.io/badge/Platform-MT6835-brightgreen?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Android-14-red?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Architecture-ARM64-orange?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Recovery-Virtual%20A%2FB-blue?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Telegram-realme11x-229ED9?style=for-the-badge&logo=telegram"/>

<br/>

### Fully working TWRP tree for Realme 11 Series based on MT6835

</div>

---

# 📖 About

This is a fully fixed and cleaned TWRP 12.1 device tree for the **Realme 11 Series** based on the **MediaTek Dimensity 6100+ (MT6835)** platform.

The tree was heavily reworked to properly support:
- Android 14 vendor base
- FBE v2 decryption
- Virtual A/B
- KeyMint 2.0
- modern vendor_boot implementations
- logical partition handling

A lot of broken MT6983 leftovers, invalid fstab entries, and incorrect Keymaster implementations were removed and rebuilt properly for MT6835.

Result:
- stable booting
- fully working decryption
- proper mounting
- clean recovery environment

---

# 📱 Supported Devices

| Device | Codename |
|---|---|
| Realme 11 | ossi |
| Realme 11x | ossi |
| Narzo 60X | ossi |
| Realme C67 5G | ossi |
| Vivo V50 | ossi |
| Vivo V50s | ossi |

---

# ⚙️ Device Information

| Property | Value |
|---|---|
| SoC | MediaTek Dimensity 6100+ |
| Platform | MT6835 |
| Architecture | ARM64 |
| Android Base | Android 14 |
| Vendor SDK | 33 |
| Boot Type | Virtual A/B |
| Recovery Type | vendor_boot |
| Encryption | FBE v2 |

---

# ✅ Current Status

| Feature | Status |
|---|---|
| Booting | ✅ |
| Touch | ✅ |
| Display | ✅ |
| FBE v2 Decryption | ✅ |
| /data Mount | ✅ |
| MTP | ✅ |
| ADB | ✅ |
| Fastbootd | ✅ |
| Flash ZIP | ✅ |
| Backup / Restore | ✅ |

---

# 🛠️ What Was Fixed

## 📦 Mount & Partition Fixes

- Fixed incorrect MT6983 partition references
- Removed dead fstab entries
- Fixed logical partition mounting
- Corrected `/data` block paths
- Properly mounted `my_*` partitions

---

## 🔐 FBE v2 Decryption

Implemented proper FBE v2 handling:

- fixed broken `fileencryption` flags
- corrected `keydirectory` parsing
- fixed metadata encryption handling
- added required `fsverity` flags

Result:
- real decryption
- stable `/data` mounting
- proper password handling

---

## 🚀 First Stage Mount

Fixed:
- AVB verification stalls
- logical partition loading
- vendor_boot initialization

Added:
```text
oplus_avb.pubkey
```

for proper AVB chain handling.

---

## ⚡ init.rc Cleanup

Removed:
- conflicting vold services
- broken userdata polling loops
- invalid Keymaster services
- dead early-init routines

Fixed:
- early-init execution
- service startup order
- recovery initialization

---

## 🔑 KeyMint / TEE Fixes

Replaced broken:
```text
Keymaster 4.x
```

implementation with proper:
```text
Trustonic KeyMint 2.0
```

This enabled:
- hardware-backed decryption
- proper TEE communication
- stable credential handling

---

## 🧹 General Cleanup

- Removed MT6983 leftovers
- cleaned broken configs
- fixed vendor SDK mismatch
- fixed AVB rollback issues
- corrected architecture configs
- removed unused partitions
- added only required blobs

---

# 💻 Build Instructions

```bash
mkdir -p ~/twrp/device/realme
cd ~/twrp/device/realme

git clone https://github.com/Sairb1/realme11-mt6835-device-tree.git

# Move DT into your synced source

cd ~/twrp

source build/envsetup.sh
lunch RE5C6CL1_ossi-eng

mka vendorbootimage -j$(nproc)
```

---

# 📦 Build Notes

- Android 14 Base
- Vendor SDK 33
- Built for vendor_boot recovery
- Compatible with Virtual A/B devices
- Designed specifically for MT6835 platform

---

# 👑 Credits

| Role | Name |
|---|---|
| Device Tree Base | @notpiyushbro |
| Device Tree Base | @HuTao77-Studio |
| Developer | @suchit_7x |
| Contributions | @imnotaino (sairb1) |
| Tester | @Zuhaan |

---

# 📢 Community

### 👉 https://t.me/realme11x

---

<div align="center">

## ⚡ Proper MT6835 recovery support without broken hacks

Made with ♥ by the Realme 11 community

</div>
