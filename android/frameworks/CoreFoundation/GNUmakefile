MYDIR := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))
TOPDIR := $(abspath $(MYDIR)/../../..)

SOURCES := $(strip $(wildcard $(addprefix $(TOPDIR)/,\
	CFNetwork/CF*.m \
	CoreFoundation/CF*.m \
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
	objc/objc_exception.m \
	objc/objc_tls.c \
)))

HEADERS := $(strip $(wildcard $(addprefix $(TOPDIR)/,\
	CFNetwork/CF*.h \
	CoreFoundation/CF*.h \
	CoreFoundation/CoreFoundation.h \
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

DEPENDENCIES := CoreServices

LDLIBS := -llog

include $(TOPDIR)/android/build.mk
