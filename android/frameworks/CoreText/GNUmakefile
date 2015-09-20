MYDIR := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))
TOPDIR := $(abspath $(MYDIR)/../../..)

SOURCES := $(strip $(wildcard $(addprefix $(TOPDIR)/,\
	CoreText/CT*.m \
	CoreText/KT*.m \
)))

HEADERS := $(strip $(wildcard $(addprefix $(TOPDIR)/,\
	CoreText/CT*.h \
	CoreText/CoreText.h \
	CoreText/CoreTextExport.h \
	CoreText/KT*.h \
)))

DEPENDENCIES := CoreGraphics CoreFoundation CoreServices

include $(TOPDIR)/android/build.mk
