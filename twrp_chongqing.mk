#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Installs gsi keys into ramdisk, to boot a developer GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)


# Inherit from our custom product configuration.
$(call inherit-product, vendor/twrp/config/common.mk)

# Device specific configs.
$(call inherit-product, device/realme/chongqing/device.mk)

# Device identifier. This must come after all inclusions
PRODUCT_DEVICE := chongqing
PRODUCT_NAME := twrp_chongqing
PRODUCT_BRAND := realme
PRODUCT_MODEL := RMX3780
PRODUCT_MANUFACTURER := realme
PRODUCT_RELEASE_NAME := realme 11
