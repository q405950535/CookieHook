ARCHS = arm64 arm64e
TARGET = iphone:clang:18.4:18.4

INSTALL_TARGET_PROCESSES = MobileSafari Safari

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CookieHook
CookieHook_FILES = Tweak.x
CookieHook_CFLAGS = -fobjc-arc
CookieHook_FRAMEWORKS = WebKit

include $(THEOS)/makefiles/tweak.mk
