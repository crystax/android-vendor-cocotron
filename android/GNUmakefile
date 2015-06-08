MYDIR := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))

FRAMEWORKS := $(MYDIR)/frameworks

PROJECTS := $(subst $(FRAMEWORKS)/,,$(foreach __f,$(wildcard $(FRAMEWORKS)/*/GNUmakefile),$(patsubst %/,%,$(dir $(__f))) ))

.PHONY: all
all: $(PROJECTS)

.PHONY: clean
clean:

define add-project-rule
.PHONY: $(1)
$(1):
	$$(MAKE) -C $$(FRAMEWORKS)/$(1)

.PHONY: clean-$(1)
clean-$(1):
	$$(MAKE) -C $$(FRAMEWORKS)/$(1) clean

.PHONY: clean
clean: clean-$(1)

endef

$(foreach __p,$(PROJECTS),\
    $(eval $(call add-project-rule,$(__p)))\
)
