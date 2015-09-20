MYDIR := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))
TOPDIR := $(abspath $(MYDIR)/../../..)

SOURCES := $(strip $(wildcard $(addprefix $(TOPDIR)/,\
	CoreGraphics/CG*.m \
	Onyx2D/O2*.m \
	Onyx2D/VG*.m \
	Onyx2D/gif_lib.m \
	Onyx2D/platform_android/O2*.m \
	OpenGL/OpenGL.m \
)))

HEADERS := $(strip $(wildcard $(addprefix $(TOPDIR)/,\
	CoreGraphics/CG*.h \
	CoreGraphics/CoreGraphics.h \
	CoreGraphics/CoreGraphicsExport.h \
	Onyx2D/O2*.h \
	Onyx2D/VG*.h \
	Onyx2D/gif_lib.h \
	Onyx2D/platform_android/O2*.h \
	OpenGL/CGL*.h \
	OpenGL/OpenGL.h \
	OpenGL/gl.h \
	OpenGL/glext.h \
	OpenGL/glweak.h \
)))

DEPENDENCIES := CoreFoundation CoreServices

LDLIBS := -lGLESv2

include $(TOPDIR)/android/build.mk
