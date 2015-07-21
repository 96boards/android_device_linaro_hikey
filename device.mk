#
# Copyright (C) 2011 The Android Open-Source Project
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

# Adjust the dalvik heap to be appropriate for a tablet.
$(call inherit-product-if-exists, frameworks/base/build/tablet-dalvik-heap.mk)
$(call inherit-product-if-exists, frameworks/native/build/tablet-dalvik-heap.mk)

PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
			$(LOCAL_PATH)/fstab.hikey:root/fstab.hikey \
			$(LOCAL_PATH)/init.hikey.rc:root/init.hikey.rc \
			$(LOCAL_PATH)/ueventd.hikey.rc:root/ueventd.hikey.rc \
			$(LOCAL_PATH)/hikey.kl:system/usr/keylayout/hikey.kl)

# Copy preboot binaries
PRE_BOOT_FILES := bl1.bin fip.bin
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
                        $(LOCAL_PATH)/preboot/bl1.bin:boot/bl1.bin \
                        $(LOCAL_PATH)/preboot/fip.bin:boot/fip.bin)

# Set custom settings
DEVICE_PACKAGE_OVERLAYS := device/linaro/hikey/overlay

# Add openssh support for remote debugging and job submission
PRODUCT_PACKAGES += ssh sftp scp sshd ssh-keygen sshd_config start-ssh uim wpa_supplicant

# Build and run only ART
PRODUCT_RUNTIMES := runtime_libart_default

# Build BT a2dp audio HAL
PRODUCT_PACKAGES += audio.a2dp.default

# Needed to sync the system clock with the RTC clock
PRODUCT_PACKAGES += hwclock

# Include USB speed switch App
PRODUCT_PACKAGES += UsbSpeedSwitch

# Build libion for new double-buffering HDLCD driver
PRODUCT_PACKAGES += libion

# Build gatord daemon for DS-5/Streamline
PRODUCT_PACKAGES += gatord

# Build gralloc for Juno
PRODUCT_PACKAGES += gralloc.hikey

# Include ION tests
PRODUCT_PACKAGES += iontest \
                    ion-unit-tests

# Set zygote config
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.zygote=zygote64_32
PRODUCT_PROPERTY_OVERRIDES += \
         debug.sf.no_hw_vsync=1 \
         ro.secure=0 \
         ro.adb.secure=0

PRODUCT_COPY_FILES += system/core/rootdir/init.zygote64_32.rc:root/init.zygote64_32.rc

PRODUCT_PACKAGES += libGLES_android

# Copy hardware config file(s)
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
                        device/linaro/build/android.hardware.screen.xml:system/etc/permissions/android.hardware.screen.xml \
                        frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml \
                        frameworks/native/data/etc/android.software.app_widgets.xml:system/etc/permissions/android.software.app_widgets.xml \
                        frameworks/native/data/etc/android.software.backup.xml:system/etc/permissions/android.software.backup.xml \
                        frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml)

#Copy Graphics binaries
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
                       vendor/mali/64bit/libGLES_mali.so:system/lib64/egl/libGLES_mali.so\
                       vendor/mali/64bit/gralloc.hikey.so:system/lib64/hw/gralloc.hikey.so\
                       vendor/mali/32bit/libGLES_mali.so:system/lib/egl/libGLES_mali.so \
                       vendor/mali/32bit/gralloc.hikey.so:system/lib/hw/gralloc.hikey.so)

# Include BT modules
$(call inherit-product-if-exists, hardware/ti/wpan/ti-wpan-products.mk)

$(call inherit-product-if-exists, device/linaro/hikey/boot_fat.mk)

####### Copy build and install howtos for this build ########
define copy-howto
ifneq ($(wildcard $(TOP)/device/linaro/hikey/howto/$(LINARO_BUILD_SPEC)/$1),)
PRODUCT_COPY_FILES += \
        device/linaro/hikey/howto/$(LINARO_BUILD_SPEC)/$1:$1
else
ifneq ($(wildcard $(TOP)/device/hikey/howto/default/$1),)
PRODUCT_COPY_FILES += \
        device/linaro/hikey/howto/default/$1:$1
endif
endif
endef

PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
        frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
        frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
        device/linaro/hikey/bt-wifi-firmware-util/TIInit_11.8.32.bts:system/etc/firmware/ti-connectivity/TIInit_11.8.32.bts \
        device/linaro/hikey/bt-wifi-firmware-util/TIInit_11.8.32.bts:system/etc/firmware/TIInit_11.8.32.bts \
        device/linaro/hikey/bt-wifi-firmware-util/wl18xx-fw-4.bin:system/etc/firmware/ti-connectivity/wl18xx-fw-4.bin \
        device/linaro/hikey/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
        device/linaro/hikey/audio/audio_policy.conf:system/etc/audio_policy.conf

HOWTOS := \
        HOWTO_install.txt \
        HOWTO_getsourceandbuild.txt \
        HOWTO_flashfirmware.txt \
        HOWTO_releasenotes.txt \
        HOWTO_rtsm.txt

ifneq ($(wildcard $(TOP)/build-info),)
PRODUCT_COPY_FILES += \
        build-info/BUILD-INFO.txt:BUILD-INFO.txt
endif

$(foreach howto,$(HOWTOS),$(eval $(call copy-howto,$(howto))))

# Copy media codecs config file
PRODUCT_COPY_FILES += device/linaro/build/media_codecs.xml:system/etc/media_codecs.xml

INCLUDE_TESTS := 0
$(call inherit-product-if-exists, device/linaro/build/common-device.mk)
