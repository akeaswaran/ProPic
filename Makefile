TARGET_IPHONEOS_DEPLOYMENT_VERSION = 8.1
SDKVERSION=8.1
ARCHS = armv7 arm64
THEOS_BUILD_DIR = debs
DEBUG = 1
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include theos/makefiles/common.mk

TWEAK_NAME = ProPic
ProPic_FILES = Tweak.xm $(wildcard External/*.m)
ProPic_FRAMEWORKS = UIKit CoreGraphics Foundation QuartzCore MediaPlayer Accelerate
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
