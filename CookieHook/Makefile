ARCHS = arm64 arm64e
# 用系统现有 SDK（比如 17.5/18.2），部署目标设 15.0 就行
TARGET = iphone:clang::15.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CookieHook
CookieHook_FILES = Tweak.x

include $(THEOS_MAKE_PATH)/tweak.mk
