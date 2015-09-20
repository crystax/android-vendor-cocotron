MYDIR := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))
TOPDIR := $(abspath $(MYDIR)/../../..)

SOURCES := $(strip $(wildcard $(addprefix $(TOPDIR)/,\
	CoreData/CoreDataErrors.m \
	CoreData/NS*.m \
)))

HEADERS := $(strip $(wildcard $(addprefix $(TOPDIR)/,\
	CoreData/CoreData.h \
	CoreData/CoreDataErrors.h \
	CoreData/CoreDataExports.h \
	CoreData/NS*.h \
)))

DEPENDENCIES := CoreFoundation CoreServices

include $(TOPDIR)/android/build.mk
