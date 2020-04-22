#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2018 The LineageOS Project
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
# Overlay
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay \
    $(LOCAL_PATH)/overlay-lineage

# Properties
PRODUCT_ENFORCE_RRO_TARGETS := framework-res

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# A list of dpis to select prebuilt apk, in precedence order.
PRODUCT_AAPT_PREBUILT_DPI := xhdpi

$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)

# ANT+
PRODUCT_PACKAGES += \
    AntHalService \
    com.dsi.ant.antradio_library \
    libantradio

# Audio
PRODUCT_PACKAGES += \
    audiod \
    audio.a2dp.default \
    audio.r_submix.default \
    audio.usb.default \
    libaudio-resampler \
    tinymix \
    libaudioparsers \
    tinyplay \
    tinycap \
    tinypcminfo \
    libtinycompress


PRODUCT_PACKAGES += \
    audio.primary.msm8916 \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing

PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.soundtrigger@2.1-impl

# Audio configuration file
AUDIO_CONFIG_PATH := hardware/qcom/audio-caf/msm8916/configs
PRODUCT_COPY_FILES += \
    $(AUDIO_CONFIG_PATH)/msm8916_64/audio_output_policy.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/audio_output_policy.conf \
    $(AUDIO_CONFIG_PATH)/msm8916_64/sound_trigger_mixer_paths.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sound_trigger_mixer_paths.xml
	   
PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    $(LOCAL_PATH)/configs/audio/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.conf \
    $(LOCAL_PATH)/configs/audio/mixer_paths_mtp.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/mixer_paths_mtp.xml

# BoringSSL Hacks
PRODUCT_PACKAGES += \
    libboringssl-compat

# Bluetooth
PRODUCT_PACKAGES += \
    libbt-vendor

PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service

# Camera
PRODUCT_PACKAGES += \
    libmm-qcamera \
    libc_util \
    libshim_atomic \
    camera.msm8916 \
    Snap

PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl-legacy \
    camera.device@1.0-impl-legacy \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml

# Connectivity Engine
PRODUCT_PROPERTY_OVERRIDES += \
    persist.cne.dpm=0 \
    persist.cne.feature=0 \
    persist.dpm.feature=0

# Connectivity Engine support
PRODUCT_PACKAGES += \
    libcnefeatureconfig

# Charger
PRODUCT_PACKAGES += \
   charger_res_images

# Data configuration files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/data/dsi_config.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/data/dsi_config.xml \
    $(LOCAL_PATH)/configs/data/netmgr_config.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/data/netmgr_config.xml \
    $(LOCAL_PATH)/configs/data/qmi_config.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/data/qmi_config.xml \
    $(LOCAL_PATH)/configs/calib.cfg:$(TARGET_COPY_OUT_SYSTEM)/etc/calib.cfg

# Display
PRODUCT_PACKAGES += \
    gralloc.msm8916 \
    hwcomposer.msm8916 \
    libgenlock \
    libtinyxml \
    copybit.msm8916 \
    memtrack.msm8916

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service

PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true

# Ebtables
PRODUCT_PACKAGES += \
    ebtables \
    ethertypes \
    libebtc

# Fingerprint sensor
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.0-service.passion

# FM
PRODUCT_PACKAGES += \
    FMRadio \
    libfmjni

# FS
PRODUCT_PACKAGES += \
    fs_config_files \
    fsck.f2fs \
    mkfs.f2fs

# Gatekeeper HAL
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

# GPS
PRODUCT_PACKAGES += \
    com.android.location.provider \
    com.android.location.provider.xml \
    libcurl \
    libgnss \
    libgnsspps \
    gps.msm8916 \
    libgps.utils \
    liblocation_api \
    libloc_core \
    libloc_pla \
    libshims_get_process_name \
    libshims_flp

PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0-impl \
    android.hardware.gnss@1.0-service

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/gps/flp.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/flp.conf \
    $(LOCAL_PATH)/configs/gps/gps.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/gps.conf \
    $(LOCAL_PATH)/configs/gps/izat.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/izat.conf \
    $(LOCAL_PATH)/configs/gps/sap.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/sap.conf \
    $(LOCAL_PATH)/configs/gps/lowi.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/lowi.conf \
    $(LOCAL_PATH)/configs/gps/xtwifi.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/xtwifi.conf

# Healthd
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-impl \
    android.hardware.health@2.0-service

# IMS
PRODUCT_PACKAGES += \
    ims-ext-common

# Init scripts
PRODUCT_PACKAGES += \
    init.qti.fm.sh \
    init.qcom.rc \
    init.qcom.mem.sh \
    init.qcom.power.rc \
    init.qcom.ssr.rc \
    init.qcom.usb.rc \
    ueventd.qcom.rc \
    init.recovery.qcom.rc \
    

PRODUCT_PACKAGES += \
    init.qcom.bt.sh

# IRQ balance
#ifeq ($(TARGET_BOARD_PLATFORM_VARIANT),msm8939)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf
#endif

# IRSC
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config

# Keylayout
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/keylayout/gpio-keys.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/gpio-keys.kl \
    $(LOCAL_PATH)/keylayout/ft5x06_ts.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/ft5x06_ts.kl \
    $(LOCAL_PATH)/keylayout/goodix_ts.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/goodix_ts.kl \
    $(LOCAL_PATH)/keylayout/synaptics_dsx.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/synaptics_dsx.kl \
    $(LOCAL_PATH)/keylayout/synaptics_rmi4_i2c.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/synaptics_rmi4_i2c.kl


PRODUCT_PACKAGES += \
    keystore.msm8916

PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service.passion_msm8939

# LineageActions
PRODUCT_PACKAGES += \
    LineageActions

# LiveDisplay
PRODUCT_PACKAGES += \
    vendor.lineage.livedisplay@2.0-service-legacymm \
    vendor.lineage.livedisplay@2.0-service-sysfs

# Media
PRODUCT_PACKAGES += \
    libOmxAacEnc \
    libOmxAmrEnc \
    libOmxCore \
    libOmxEvrcEnc \
    libOmxQcelp13Enc \
    libOmxVdec \
    libOmxVenc \
    libstagefrighthw

# Media
PRODUCT_PACKAGES += \
    libc2dcolorconvert \
    libOmxSwVencHevc \
    libextmedia_jni \
    libdashplayer \
    libdivxdrmdecrypt \
    libdrmclearkeyplugin \

# Media - OpenMAX
PRODUCT_PACKAGES += \
    libmm-omxcore \
    libOmxSwVencMpeg4 \
    libOmxVdecHevc \
    libOmxVidEnc \
    libOmxVdpp

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml\
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml \

# Media configurations
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media/media_codecs_msm8939.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(LOCAL_PATH)/configs/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/configs/media/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml



# Misc
PRODUCT_PACKAGES += \
    curl \
    libbson \
    libcurl \
    libkeyutils \
    tcpdump

# Net
PRODUCT_PACKAGES += \
    android.system.net.netd@1.0 \
    libandroid_net \
    libnl \
    netutils-wrapper-1.0

# NFC
PRODUCT_PACKAGES += \
    nfc_nci.bcm2079x.default \
    com.android.nfc_extras \
    libnfc_nci_jni \
    libnfc \
    NfcNci \
    Tag

#    libnfcdummy \

PRODUCT_PACKAGES += \
    android.hardware.nfc@1.0-impl-bcm \
    android.hardware.nfc@1.0-service 

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/nfc/libnfc-brcm.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nci.conf \
    $(LOCAL_PATH)/configs/nfc/libnfc-brcm.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nxp.conf \
    $(LOCAL_PATH)/configs/nfc/libnfc-brcm-20795a20.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nci-20795a20.conf \
    $(LOCAL_PATH)/configs/nfc/nfcee_access.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/nfcee_access.xml \
    $(LOCAL_PATH)/configs/nfc/nfcse.cfg:$(TARGET_COPY_OUT_SYSTEM)/etc/nfcse.cfg \
    $(LOCAL_PATH)/configs/nfc/nfc_wallet.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/nfc_wallet.conf

# QCOM Privapp Whitelist
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/privapp-permissions-qti.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-qti.xml \
    $(LOCAL_PATH)/configs/qti_whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/qti_whitelist.xml

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.manager@1.0 \
    android.hidl.manager@1.0-java

# Permissions
PRODUCT_COPY_FILES += \
    external/ant-wireless/antradio-library/com.dsi.ant.antradio_library.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.dsi.ant.antradio_library.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/base/nfc-extras/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml


# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.1-service-qti

# Radio
PRODUCT_PACKAGES += \
    libcnefeatureconfig \
    librmnetctl \
    libxml2

# Recovery
PRODUCT_PACKAGES += \
    librecovery_updater_cm

# RenderScript HAL
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl \
    android.hardware.renderscript@1.0-service

# Seccomp
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    $(LOCAL_PATH)/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

# Security configuration file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config

# Sensor HAL
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sensors/_hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/_hals.conf

PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl \
    sensors.msm8916

PRODUCT_COPY_FILES += \
  $(LOCAL_PATH)/configs/calmodule.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/calmodule.cfg

# Telephony
PRODUCT_PACKAGES += \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

# Thermal
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/thermal-engine.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/thermal-engine.conf

PRODUCT_PACKAGES += \
    android.hardware.thermal@1.0-impl

# Trust HAL
PRODUCT_PACKAGES += \
    vendor.lineage.trust@1.0-service

# Time services
PRODUCT_PROPERTY_OVERRIDES += \
    persist.timed.enable=true

# QMI
PRODUCT_PACKAGES += \
    libjson

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service.basic

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service

# WiDi
PRODUCT_PACKAGES += \
    com.android.media.remotedisplay \
    com.android.media.remotedisplay.xml


# Wi-Fi
PRODUCT_PACKAGES += \
    libcld80211 \
    libwcnss_qmi \
    wcnss_service

PRODUCT_PACKAGES += \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf


PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/configs/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
    $(LOCAL_PATH)/configs/wifi/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/firmware/wlan/prima/WCNSS_qcom_cfg.ini



PRODUCT_PROPERTY_OVERRIDES += \
    ro.qcom.ad=1 \
    ro.qcom.ad.sensortype=2

# USB debugging
PRODUCT_PROPERTY_OVERRIDES += \
	persist.sys.usb.config=mtp,adb \
	ro.adb.secure=0 \
	ro.secure=0 \
	ro.allow.mock.location=1 \
	ro.debuggable=1
