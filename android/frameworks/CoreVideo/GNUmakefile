MYDIR := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))
TOPDIR := $(abspath $(MYDIR)/../../..)

SOURCES := $(strip $(wildcard $(addprefix $(TOPDIR)/,\
	CoreVideo/CV*.m \
)))

HEADERS := $(strip $(wildcard $(addprefix $(TOPDIR)/,\
	CoreVideo/CV*.h \
	CoreVideo/CoreVideo.h \
)))

DEPENDENCIES := CoreGraphics CoreFoundation CoreServices

include $(TOPDIR)/android/build.mk
