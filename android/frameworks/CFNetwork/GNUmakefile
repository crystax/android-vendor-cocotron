MYDIR := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))
TOPDIR := $(abspath $(MYDIR)/../../..)

SOURCES := $(wildcard $(TOPDIR)/CFNetwork/empty.m)
HEADERS := $(wildcard $(TOPDIR)/CFNetwork/CF*.h)

DEPENDENCIES := CoreFoundation

include $(TOPDIR)/android/build.mk
