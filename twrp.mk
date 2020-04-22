#
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_RECOVERY_DEVICE_DIRS += $(DEVICE_PATH)/twrp
#TW_EXCLUDE_DEFAULT_USB_INIT := true
#TW_OREO_MR1_F2FS := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_EXTRA_LANGUAGES := true
TW_THEME := portrait_hdpi
TW_INCLUDE_CRYPTO := true
TW_MAX_BRIGHTNESS := 255
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TARGET_RECOVERY_QCOM_RTC_FIX := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/twrp/recovery/root/etc/twrp.fstab
RECOVERY_SDCARD_ON_DATA := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_EXCLUDE_SUPERSU := true
TW_INCLUDE_FUSE_EXFAT := true
TW_INCLUDE_FUSE_NTFS := true
TW_USE_TOOLBOX := true
TW_EXCLUDE_TWRPAPP := true
