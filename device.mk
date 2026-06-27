#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# API - changed to 32 for TWRP 12.1 branch compatibility
PRODUCT_SHIPPING_API_LEVEL := 32
PRODUCT_TARGET_VNDK_VERSION := 32

# A/B
ENABLE_VIRTUAL_AB := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# SDCard replacement functionality
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := \
    boot \
    cdt_engineering \
    connsys_bt \
    dpm \
    dtbo \
    gz \
    init_boot \
    lk \
    logo \
    mcf_ota \
    mcupm \
    md1img \
    my_bigball \
    my_carrier \
    my_engineering \
    my_heytap \
    my_manifest \
    my_product \
    my_region \
    my_stock \
    odm \
    odm_dlkm \
    pi_img \
    preloader \
    product \
    scp \
    spmfw \
    sspm \
    system \
    system_dlkm \
    system_ext \
    tee \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vcp \
    vendor \
    vendor_boot \
    vendor_dlkm

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier \
    checkpoint_gc

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/mtk_plpath_utils \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-mtkimpl \
    android.hardware.boot@1.2-mtkimpl.recovery

PRODUCT_PACKAGES_DEBUG += \
    bootctrl

# Build MT-PL-Utils
PRODUCT_PACKAGES += \
    mtk_plpath_utils \
    mtk_plpath_utils.recovery

# Dynamic
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

# Drm
PRODUCT_PACKAGES += \
    android.hardware.drm@1.4	

# Keymint - V2 for Android 15 (confirmed: keymint manifest version=2 in A15 stock vendor_boot)
PRODUCT_PACKAGES += \
    android.hardware.security.keymint \
    android.hardware.security.secureclock \
    android.hardware.security.sharedsecret


# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.1

# Additional target Libraries
TARGET_RECOVERY_DEVICE_MODULES += \
    android.hardware.keymaster@4.1
   
# Keystore2
PRODUCT_PACKAGES += \
    android.system.keystore2

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@4.1.so

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)

# Copy core configs to vendor ramdisk to populate the target directory and avoid build errors
PRODUCT_COPY_FILES += \
    device/realme/chongqing/recovery/root/init.recovery.mt6835.rc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/init.recovery.mt6835.rc \
    device/realme/chongqing/recovery/root/ueventd.mt6835.rc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/ueventd.mt6835.rc \
    device/realme/chongqing/recovery/root/first_stage_ramdisk/fstab.emmc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.emmc \
    device/realme/chongqing/recovery/root/first_stage_ramdisk/fstab.mt6835:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt6835

