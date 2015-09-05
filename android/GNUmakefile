MYDIR := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))

FRAMEWORKS := $(MYDIR)/frameworks

PROJECTS := $(subst $(FRAMEWORKS)/,,$(foreach __f,$(wildcard $(FRAMEWORKS)/*/GNUmakefile),$(patsubst %/,%,$(dir $(__f))) ))

# $1: project
define project-dependencies
$(strip \
	$(foreach __d,\
		$(shell $(MAKE) --no-print-directory -C $(FRAMEWORKS)/$(1) dump-dependencies DONT_EVAL_RULES=yes NDK=$(NDK)),\
		$(call project-dependencies,$(__d)) \
		$(__d) \
	)\
)
endef

DEPENDENCIES := $(strip \
	$(eval __deps := )\
	$(foreach __p,$(PROJECTS),\
		$(eval __deps += $(call project-dependencies,$(__p)))\
		$(eval __deps += $(__p))\
	)\
	$(eval __ret := )\
	$(foreach __d,$(__deps),\
		$(eval __ret += $(if $(filter $(__d),$(__ret)),,$(__d)))\
	)\
	$(__ret)\
)

.PHONY: all
all:

.PHONY: clean
clean:

.PHONY: install
install:

define add-common-rule
.PHONY: $(1)
$(1):
	@+$$(foreach __p,$$(DEPENDENCIES),\
		$$(MAKE) -C $$(FRAMEWORKS)/$$(__p) BUILD_DEPENDENCIES=no $(1) || exit 1; \
	)
endef

define add-project-rule
.PHONY: $(1)
$(1):
	@$$(MAKE) -C $$(FRAMEWORKS)/$(1)

.PHONY: clean-$(1)
clean-$(1):
	@$$(MAKE) -C $$(FRAMEWORKS)/$(1) clean

endef

$(foreach __a,all clean install,\
    $(eval $(call add-common-rule,$(__a)))\
)

$(foreach __p,$(PROJECTS),\
    $(eval $(call add-project-rule,$(__p)))\
)
