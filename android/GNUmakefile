MYDIR := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))

PROJECTS := $(subst $(MYDIR)/,,$(foreach __f,$(wildcard $(MYDIR)/*/GNUmakefile),$(patsubst %/,%,$(dir $(__f))) ))

.PHONY: all
all: $(PROJECTS)

.PHONY: $(PROJECTS)
$(PROJECTS):
	$(MAKE) -C $@

.PHONY: clean
clean:
	@$(foreach __p,$(PROJECTS),$(MAKE) -C $(__p) clean || exit 1; )
