MYDIR := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))
TOPDIR := $(abspath $(MYDIR)/../../..)

SOURCES := $(strip $(wildcard $(addprefix $(TOPDIR)/,\
	Foundation/NS**/CF*.m \
	Foundation/NS**/NS*.m \
	Foundation/NS*.m \
	Foundation/NSNetService/bonjour.m \
	Foundation/NSObject/forwarding.m \
	Foundation/NSObject/objc_msg_sendv-Disabled.m \
	Foundation/NSObject/objc_size_alignment.m \
	Foundation/platform_android/NS*.m \
	Foundation/platform_posix/NS*.m \
	Foundation/xml/NS*.m \
	objc/dyld.c \
	objc/objc_arc.c \
	objc/objc_exception.c \
	objc/objc_tls.c \
)))

HEADERS := $(strip \
	$(foreach __dir,$(wildcard $(TOPDIR)/Foundation/NS*),\
		$(wildcard $(__dir)/NS*.h) \
		$(wildcard $(__dir)/CF*.h) \
	) \
	$(wildcard $(addprefix $(TOPDIR)/Foundation/,\
		Foundation*.h \
		NS*.h \
		NSCharacterSet/bitmapRepresentation.h \
		NSNetService/bonjour.h \
		NSObject/forwarding.h \
		NSObject/objc_size_alignment.h \
		platform_android/NS*.h \
		platform_posix/NS*.h \
		xml/NS*.h \
	)) \
)

RESOURCES := $(strip \
	$(wildcard $(addprefix $(TOPDIR)/Foundation/,\
		English.lproj/NSUserDefaults.plist \
		NSTimeZone/NSTimeZoneAbbreviations.plist \
	))\
)

DEPENDENCIES := CoreFoundation CoreServices CFNetwork

include $(TOPDIR)/android/build.mk
