ARCHS = arm64 arm64e
TARGET = iphone:clang::15.0
# 关键：开启 rootless 模式，自动适配路径
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CookieHook
CookieHook_FILES = Tweak.x
CookieHook_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
