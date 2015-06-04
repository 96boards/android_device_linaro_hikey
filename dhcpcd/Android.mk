ifeq (hikey, $(TARGET_PRODUCT))
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := dhcpcd.conf
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/dhcpcd
LOCAL_SRC_FILES := android_dhcpcd.conf
include $(BUILD_PREBUILT)
endif
