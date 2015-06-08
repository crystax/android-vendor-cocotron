MYDIR := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))
TOPDIR := $(abspath $(MYDIR)/../../..)

SOURCES := $(wildcard $(TOPDIR)/CoreFoundation/CF*.m)

HEADERS := $(strip \
	$(wildcard $(addprefix $(TOPDIR)/CoreFoundation/,\
		CF*.h \
		CoreFoundation.h \
	)) \
	$(foreach __dir,$(wildcard $(TOPDIR)/Foundation/NS*),\
		$(wildcard $(__dir)/NS*.h) \
	) \
	$(wildcard $(addprefix $(TOPDIR)/Foundation/,\
		NS*.h \
	)) \
)

DEPENDENCIES := CoreServices

include $(TOPDIR)/android/build.mk
