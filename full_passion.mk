#
# Copyright (C) 2015 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from passion device
$(call inherit-product, device/lenovo/passion/device.mk)

# Device vendor
$(call inherit-product, vendor/lenovo/passion/passion-vendor.mk)

# Encryption
PRODUCT_PACKAGES += \
    libcryptfs_hw

# Device identifier. This must come after all inclusions
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_DEVICE := passion
PRODUCT_NAME := full_passion
PRODUCT_BRAND := Lenovo
PRODUCT_MODEL := Vibe P1
PRODUCT_MANUFACTURER := lenovo
