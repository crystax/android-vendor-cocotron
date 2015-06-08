MYDIR := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))
TOPDIR := $(abspath $(MYDIR)/../../..)

SOURCES := $(wildcard $(TOPDIR)/CoreServices/CoreServices.m)
HEADERS := $(wildcard $(TOPDIR)/CoreServices/CoreServices.h)

include $(TOPDIR)/android/build.mk
