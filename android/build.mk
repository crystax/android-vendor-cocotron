ifeq (,$(strip $(NDK)))
$(error NDK is not defined!)
endif

override NDK := $(realpath $(wildcard $(NDK)))

ifeq (,$(strip $(SOURCES)))
$(error SOURCES are not defined!)
endif

ifeq (,$(strip $(HEADERS)))
$(error HEADERS are not defined!)
endif

ifeq (,$(strip $(TOPDIR)))
$(error TOPDIR is not defined!)
endif

ifeq (,$(strip $(MYDIR)))
$(error MYDIR is not defined!)
endif

FRAMEWORK ?= $(notdir $(MYDIR))

DEVDEFAULTS = $(NDK)/build/instruments/dev-defaults.sh

OBJC2 := $(NDK)/$(shell source $(DEVDEFAULTS) && echo $$GNUSTEP_OBJC2_SUBDIR)

LLVM_VERSION ?= $(shell source $(DEVDEFAULTS) && echo $$DEFAULT_LLVM_VERSION)
GCC_VERSION  ?= $(shell source $(DEVDEFAULTS) && echo $$DEFAULT_GCC_VERSION)

PREFIX ?= $(NDK)/$(shell source $(DEVDEFAULTS) && echo $$COCOTRON_SUBDIR)/frameworks
ABIS ?= $(shell source $(DEVDEFAULTS) && echo $$PREBUILT_ABIS)

# $1: ABI
# $2: source file
define commonflags
$(strip \
	-fgnu-runtime \
	-fobjc-nonfragile-abi \
	-fblocks \
	-fno-objc-arc \
	-fintegrated-as \
	-fpic \
	-O3 -g \
	-Werror \
	-DOBJC_EXPORT= \
	-DGCC_RUNTIME_3 \
	-DPTHREAD_INSIDE_BUILD \
	-DCFNETWORK_INSIDE_BUILD \
	-DCOREFOUNDATION_INSIDE_BUILD \
	-DFOUNDATION_INSIDE_BUILD \
	-DOBJC_INSIDE_BUILD \
	-DPLATFORM_IS_POSIX \
	-DPLATFORM_USES_BSD_SOCKETS \
	-DCOCOTRON_DISALLOW_FORWARDING \
	-I$(OBJC2)/include \
	-I$(TOPDIR)/android/include \
	$(foreach __d,$(DEPENDENCIES),\
		-I$(call genroot,$(__d))/include \
	) \
	-I$(call genroot)/include \
)
endef

# $1: ABI
define ldflags
$(strip \
	-fpic \
	-O2 -g \
)
endef

#=======================================================================================

empty :=
space := $(empty) $(empty)
comma := ,

define commas-to-spaces
$(strip $(subst $(comma),$(space),$(1)))
endef

define spaces-to-commas
$(strip $(subst $(space),$(comma),$(strip $(1))))
endef

# $1: list
define head
$(firstword $(1))
endef

# $1: list
define tail
$(wordlist 2,$(words $(1)),$(1))
endef

# $1: root directory
# $2: wildcards (*.c, *.h etc)
define rwildcard
$(foreach __d,$(wildcard $(1)*),$(call rwildcard,$(__d)/,$(2)) $(filter $(subst *,%,$(2)),$(__d)))
endef

define rm-if-exists
$(if $(wildcard $(1)),rm -Rf $(wildcard $(1)))
endef

define link
rm -f $(2) && ln -s $(1) $(2)
endef

define hide
$(if $(filter 1,$(V)),,@)
endef

define abis
$(call commas-to-spaces,$(strip $(ABIS)))
endef

define host-os
$(shell uname -s | tr '[A-Z]' '[a-z]')
endef

define host-arch
$(shell uname -m)
endef

# $1: module (optional)
define outdir
$(strip \
	$(if $(OUT),\
		$(OUT)/$(or $(strip $(1)),$(FRAMEWORK)),\
		$(TOPDIR)/android/frameworks/$(or $(strip $(1)),$(FRAMEWORK))/build\
	)\
)
endef

# $1: module (optional)
define objroot
$(call outdir,$(1))/obj
endef

# $1: module (optional)
define targetroot
$(call outdir,$(1))/lib
endef

# $1: module (optional)
define genroot
$(call outdir,$(1))/gen
endef

# $1: ABI
define objdir
$(strip $(if $(strip $(1)),\
    $(call objroot)/$(strip $(1)),\
    $(error Usage: call objdir,abi)\
))
endef

# $1: source file
define objfile
$(addsuffix .o,$(subst $(abspath $(TOPDIR))/,,$(abspath $(1))))
endef

# $1: ABI
define objfiles
$(strip \
    $(addprefix $(call objdir,$(1))/,\
        $(foreach __f,$(SOURCES),$(call objfile,$(__f)))\
    )\
)
endef

# $1: ABI
define tcprefix
$(strip $(if $(strip $(1)),\
    $(or \
        $(if $(filter armeabi%,$(1)),arm-linux-androideabi-),\
        $(if $(filter arm64-v8a,$(1)),aarch64-linux-android-),\
        $(if $(filter x86,$(1)),x86-),\
        $(if $(filter x86_64,$(1)),x86_64-),\
        $(if $(filter mips,$(1)),mipsel-linux-android-),\
        $(if $(filter mips64,$(1)),mips64el-linux-android-),\
        $(error Unsupported ABI: '$(1)')\
    ),\
    $(error Usage: call tcprefix,abi)\
))
endef

# $1: ABI
define tcname
$(strip $(if $(strip $(1)),\
    $(or \
        $(if $(filter x86,$(1)),i686-linux-android-),\
        $(if $(filter x86_64,$(1)),x86_64-linux-android-),\
        $(call tcprefix,$(1))\
    ),\
    $(error Usage: call tcname,abi)\
))
endef

# $1: ABI
# $2: GCC version
define gcc-toolchain
$(abspath $(NDK)/toolchains/$(call tcprefix,$(1))$(2)/prebuilt/$(host-os)-$(host-arch))
endef

# $1: ABI
define llvm-tripple
$(strip $(if $(strip $(1)),\
    $(or \
        $(if $(filter armeabi,$(1)),armv5te-none-linux-androideabi),\
        $(if $(filter armeabi-v7a%,$(1)),armv7-none-linux-androideabi),\
        $(if $(filter arm64-v8a,$(1)),aarch64-none-linux-android),\
        $(if $(filter x86,$(1)),i686-none-linux-android),\
        $(if $(filter x86_64,$(1)),x86_64-none-linux-android),\
        $(if $(filter mips,$(1)),mipsel-none-linux-android),\
        $(if $(filter mips64,$(1)),mips64el-none-linux-android),\
        $(error Unsupported ABI: '$(1)')\
    ),\
    $(error Usage: call llvm-tripple,abi)\
))
endef

# $1: ABI
# $2: Toolchain utility name (clang, ar etc)
define tc-bin
$(strip $(if $(and $(strip $(1)),$(strip $(2))),\
    $(strip \
        $(abspath $(NDK))/toolchains/llvm-$(LLVM_VERSION)/prebuilt/$(host-os)-$(host-arch)/bin/$(strip $(2))\
        $(if $(filter clang clang++,$(2)),\
            -target $(call llvm-tripple,$(1))\
            -gcc-toolchain $(call gcc-toolchain,$(1),$(GCC_VERSION))\
        )\
    ),\
    $(error Usage: call tc-bin,abi,name)\
))
endef

# $1: ABI
define cc
$(call tc-bin,$(1),clang)
endef

# $1: ABI
define c++
$(call tc-bin,$(1),clang++)
endef

# $1: ABI
define ar
$(call tc-bin,$(1),llvm-ar)
endef

# $1: ABI
# $2: source file
define compiler-for
$(strip $(if $(and $(strip $(1)),$(strip $(2))),\
    $(or \
        $(if $(filter %.c %.m %.s %.S,$(2)),$(call cc,$(1))),\
        $(if $(filter %.cpp %.cc %.mm,$(2)),$(call c++,$(1))),\
        $(error Cannot detect compiler for '$(2)')\
    ),\
    $(error Usage: call compiler-for,abi,source-file)\
))
endef

# $1: ABI
# $2: source file
define cflags
$(call commonflags,$(1),$(2))
endef

# $1: ABI
# $2: source file
define c++flags
$(call commonflags,$(1),$(2))
endef

# $1: ABI
# $2: source file
define asmflags
$(call commonflags,$(1),$(2))
endef

# $1: ABI
# $2: source file
define compiler-flags
$(strip $(if $(and $(strip $(1)),$(strip $(2))),\
    $(or \
        $(if $(filter %.c %.m,$(2)),$(call cflags,$(1),$(2))),\
        $(if $(filter %.cpp %.cc %.mm,$(2)),$(call c++flags,$(1),$(2))),\
        $(if $(filter %.s %.S,$(2)),$(call asmflags,$(1),$(2))),\
        $(error Cannot detect compiler flags for '$(2)')\
    ),\
    $(error Usage: call compiler-for,abi,source-file)\
))
endef

# $1: ABI
define arch-for-abi
$(strip $(if $(filter 1,$(words $(1))),\
    $(or \
        $(if $(filter armeabi%,$(1)),arm),\
        $(if $(filter arm64%,$(1)),arm64),\
        $(if $(filter x86 x86_64 mips mips64,$(1)),$(1)),\
        $(error Unsupported ABI: '$(1)')\
    ),\
    $(error Usage: call arch-for-abi,abi)\
))
endef

# $1: ABI
# $2: list of API levels
define detect-platform
$(strip $(if $(filter 1,$(words $(1))),\
    $(if $(strip $(2)),\
        $(if $(wildcard $(NDK)/platforms/android-$(call head,$(2))/arch-$(call arch-for-abi,$(1))),\
            android-$(call head,$(2)),\
            $(call detect-platform,$(1),$(call tail,$(2)))\
        ),\
        $(error Can not detect sysroot platform for ABI '$(1)')\
    ),\
    $(error Usage: call detect-platform,abi,api-levels)\
))
endef

# $1: ABI
define sysroot
$(strip $(if $(filter 1,$(words $(1))),\
    $(abspath $(NDK)/platforms/$(call detect-platform,$(1),9 21)/arch-$(call arch-for-abi,$(1))),\
    $(error Usage: call sysroot,abi)\
))
endef

define makefiles
$(filter-out %.d,$(MAKEFILE_LIST))
endef

# $1: ABI
# $2: source file
define add-objfile-rule
$$(call objdir,$(1))/$$(call objfile,$(2)): $$(abspath $(2)) $$(makefiles) | dependencies
	@echo "CC [$(1)] $$(subst $$(abspath $$(TOPDIR))/,,$$<)"
	@mkdir -p $$(dir $$@)
	$$(hide)$$(call compiler-for,$(1),$$<) \
		-MD -MP -MF $$(patsubst %.o,%.d,$$@) \
		$$(call compiler-flags,$(1),$$<) \
		--sysroot=$$(call sysroot,$(1)) \
		-c -o $$@ $$<
endef

# $1: type (static or shared)
# $2: ABI
define add-target-rule
__target := $$(call targetroot)/$(2)/lib$$(FRAMEWORK).$$(if $$(filter static,$(1)),a,so)

$$(__target): $$(call objfiles,$(2)) $$(RESOURCES) $$(makefiles) | $$(dir $$(__target)) dependencies
	@echo "$(if $(filter static,$(1)),AR,LD) [$(2)] $$(subst $$(abspath $$(outdir))/,,$$@)"
	@rm -f $$@
	$$(hide)$$(strip $$(if $$(filter static,$(1)),\
		$$(call ar,$(2)) crs $$@ $$(filter-out $$(makefiles),$$^),\
		$$(call cc,$(2)) \
			-shared -Wl,-soname,$$(notdir $$@) \
			$(if $(filter armeabi-v7a-hard,$(2)),-Wl$(comma)--no-warn-mismatch) \
			-Wl$(comma)--no-undefined \
			--sysroot=$$(call sysroot,$(2)) \
			-L$$(call sysroot,$(2))/usr/$(if $(filter x86_64 mips64,$(2)),lib64,lib) \
			-L$$(NDK)/sources/crystax/libs/$(2) \
			-L$$(OBJC2)/libs/$(2) \
			$$(foreach __d,$$(DEPENDENCIES),\
				-L$$(call targetroot,$$(__d))/$(2) \
			)\
			$$(call objfiles,$(2)) \
			$$(call ldflags,$(2)) \
			$$(foreach __d,$$(DEPENDENCIES),\
				-l$$(__d) \
			)\
			-lobjc \
			$(LDLIBS) \
			-o $$@ \
		))

ifneq (static,$(1))
.PHONY: install-$(2)
install-$(2): $$(__target)
	$$(eval __installdir := $$(PREFIX)/$(2)/$$(FRAMEWORK).framework)
	@echo "INSTALL $$(__installdir)"
	$$(hide)mkdir -p $$(__installdir)/Versions/A
	$$(hide)$$(call link,A,$$(__installdir)/Versions/Current)
	$$(hide)rsync -a $$< $$(__installdir)/Versions/Current/
	$$(hide)$$(call link,Versions/Current/$$(FRAMEWORK),$$(__installdir)/$$(FRAMEWORK))
	$$(hide)$$(call link,$$(notdir $$<),$$(__installdir)/Versions/Current/$$(FRAMEWORK))
	$$(eval __headers := $$(call genroot)/include/$$(FRAMEWORK))
	$$(hide)rm -Rf $$(__installdir)/Versions/Current/Headers
	$$(hide)mkdir -p $$(__installdir)/Versions/Current/Headers
	$$(hide)rsync -aL $$(__headers)/ $$(__installdir)/Versions/Current/Headers/
	$$(hide)$$(call link,Versions/Current/Headers,$$(__installdir)/Headers)
	$$(eval __resdir := $$(__installdir)/Resources)
	$$(hide)rm -Rf $$(__resdir)
	$$(hide)$$(if $$(strip $$(RESOURCES)),mkdir -p $$(__resdir))
	$$(hide)$$(foreach __f,$$(RESOURCES),\
			cp $$(__f) $$(__resdir)/ || exit 1; \
		)
	$$(hide)echo "LOCAL_EXPORT_CFLAGS += $$(foreach __d,$$(DEPENDENCIES),-framework $$(__d))" >$$(__installdir)/deps.mk

.PHONY: install
install: install-$(2)

endif

$$(eval $$(call add-mkdir-rule,$$(dir $$(__target))))

.PHONY: all
all: $$(__target)

.PHONY: $(1)-$(2)
$(1)-$(2): $$(__target)

.PHONY: $(1)
$(1): $$(__target)

endef

# $1: directory
define add-mkdir-rule
ifeq (,$$(__mkdir_rule_added.$(1)))
$(1):
	$$(hide)mkdir -p $$@

$$(eval __mkdir_rule_added.$(1) := yes)
endif
endef

# $1: source file
# $2: category
define add-gen-header-rule
__relsrc := $$(patsubst $$(TOPDIR)/$(2)/%,%,$(1))
__dstdir := $$(call genroot)/include/$(2)

gen-sources: $$(__dstdir)/$$(notdir $$(__relsrc))

$$(__dstdir)/$$(notdir $$(__relsrc)): $(1) | $$(__dstdir)
	@echo "GEN $$(patsubst $$(call genroot)/include/%,%,$$@)"
	$$(hide)ln -sf $$< $$@

$$(eval $$(call add-mkdir-rule,$$(__dstdir)))
endef

# $1: dependency
define add-dependency-rule
.PHONY: dependency-$(1)
dependency-$(1):
	$$(MAKE) -C $$(TOPDIR)/android/frameworks/$(1) all

.PHONY: dependencies
dependencies: dependency-$(1)
endef

#=======================================================================================

.PHONY: all
all:

.PHONY: clean
clean:
	$(call rm-if-exists,$(outdir))

.PHONY: install
install:

.PHONY: gen-sources
gen-sources:

.PHONY: dependencies
dependencies: gen-sources

.PHONY: dump-dependencies
dump-dependencies:
	@echo $(DEPENDENCIES)

ifneq (yes,$(DONT_EVAL_RULES))
$(foreach __abi,$(call abis),\
    $(foreach __t,static shared,\
        $(eval $(call add-target-rule,$(__t),$(__abi)))\
    )\
    $(foreach __src,$(SOURCES),\
        $(eval $(call add-objfile-rule,$(__abi),$(__src)))\
    )\
    $(eval sinclude $(call rwildcard,$(call objdir,$(__abi)),*.d))\
)

$(foreach __c,\
    $(sort $(foreach __f,$(patsubst $(TOPDIR)/%,%,$(HEADERS)),$(firstword $(subst /, ,$(dir $(__f)))) )),\
    $(foreach __h,$(filter $(TOPDIR)/$(__c)/%,$(HEADERS)),\
        $(eval $(call add-gen-header-rule,$(__h),$(__c)))\
    )\
)

ifneq (no,$(BUILD_DEPENDENCIES))
$(foreach __d,$(DEPENDENCIES),\
    $(eval $(call add-dependency-rule,$(__d)))\
)
endif

endif
