# Primary Arch
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_VARIANT := generic
TARGET_CPU_ABI := arm64-v8a

# Secondary Arch
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_VARIANT := cortex-a15
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

TARGET_USES_64_BIT_BINDER := true
TARGET_SUPPORTS_32_BIT_APPS := true
TARGET_SUPPORTS_64_BIT_APPS := true

TARGET_BOARD_PLATFORM := hikey
ANDROID_64=true
#WITH_DEXPREOPT ?= true
USE_OPENGL_RENDERER := true
ANDROID_ENABLE_RENDERSCRIPT := true

# BT configs
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := "device/linaro/hikey/bluetooth"
BOARD_HAVE_BLUETOOTH := true

# generic wifi
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
CONFIG_DRIVER_NL80211 := y
CONFIG_DRIVER_WEXT :=y


BOARD_KERNEL_CMDLINE := k3v2mem hisi_dma_print=0 vmalloc=484M no_irq_affinity loglevel=7 androidboot.hardware=hikey selinux=0
BOARD_KERNEL_BASE := 0x07400000
BOARD_DTB_ADDR := 0x09e00000
BOARD_RAMDISK_OFFSET := 0x07c00000
BOARD_KERNEL_OFFSET := 0x00080000
TARGET_USES_HISI_DTIMAGE := true
ifeq ($(strip $(USE_LINARO_TOOLCHAIN)),true)
# 64bit toolchain
KERNEL_TOOLS_PREFIX ?= $(realpath $(TOP))/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9-linaro/bin/aarch64-linux-android-
TARGET_TOOLS_PREFIX ?= $(realpath $(TOP))/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9-linaro/bin/aarch64-linux-android-
# 32bit toolchain
# Linaro 32bit toolchain is disabled because of this bug https://bugs.linaro.org/show_bug.cgi?id=383
2ND_TARGET_TOOLCHAIN_ROOT ?= $(realpath $(TOP))/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9-linaro
2ND_TARGET_TOOLS_PREFIX ?= $(realpath $(TOP))/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9-linaro/bin/arm-linux-androideabi-
endif

# Kernel Config
KERNEL_CONFIG = arch/arm64/configs/defconfig android/configs/android-base.cfg  android/configs/android-recommended.cfg
# Kernel Source and Device Tree
TARGET_KERNEL_SOURCE ?= kernel/linaro/hisilicon
DEVICE_TREES := hi6220-hikey:hi6220-hikey.dtb
BUILD_KERNEL_MODULES ?= true
GATOR_DAEMON_PATH := $(TARGET_KERNEL_SOURCE)

TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false
TARGET_NO_RECOVERY := true
TARGET_USE_XLOADER := false
TARGET_USE_UBOOT := false
TARGET_HARDWARE_3D := true
TARGET_SHELL := ash
BOARD_USES_GENERIC_AUDIO := true
USE_CAMERA_STUB := true
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1342177280
BOARD_USERDATAIMAGE_PARTITION_SIZE := 1342177280
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072
TARGET_USE_PAN_DISPLAY := true

BOARD_SEPOLICY_DIRS += device/linaro/build/sepolicy
BOARD_SEPOLICY_UNION += \
        file_contexts \
        gatord.te  \
        init.te  \
        kernel.te  \
        logd.te  \
        mediaserver.te  \
        netd.te  \
        shell.te  \
        surfaceflinger.te

BOARD_SEPOLICY_DIRS += device/linaro/hikey/sepolicy
BOARD_SEPOLICY_UNION += \
        file.te \
        genfs_contexts \
        init.te \
        kernel.te
