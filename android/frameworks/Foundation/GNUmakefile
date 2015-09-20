MYDIR := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))
TOPDIR := $(abspath $(MYDIR)/../../..)

SOURCES := $(strip $(wildcard $(addprefix $(TOPDIR)/,\
	Foundation/Foundation.m \
)))

HEADERS := $(strip $(wildcard $(addprefix $(TOPDIR)/,\
	Foundation/Foundation*.h \
	Foundation/NS*.h \
	Foundation/NS*/CF*.h \
	Foundation/NS*/NS*.h \
	Foundation/NSCharacterSet/bitmapRepresentation.h \
	Foundation/NSNetService/bonjour.h \
	Foundation/NSObject/forwarding.h \
	Foundation/NSObject/objc_size_alignment.h \
	Foundation/platform_android/NS*.h \
	Foundation/platform_posix/NS*.h \
	Foundation/xml/NS*.h \
)))

RESOURCES := $(strip \
	$(wildcard $(addprefix $(TOPDIR)/Foundation/,\
		English.lproj/NSUserDefaults.plist \
		NSTimeZone/NSTimeZoneAbbreviations.plist \
	))\
)

DEPENDENCIES := CoreGraphics CoreFoundation CoreServices CFNetwork

include $(TOPDIR)/android/build.mk
