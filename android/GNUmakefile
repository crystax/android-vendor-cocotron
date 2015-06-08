PROJECTS := Foundation

.PHONY: all
all: $(PROJECTS)

.PHONY: $(PROJECTS)
$(PROJECTS):
	$(MAKE) -C $@

.PHONY: clean
clean:
	@$(foreach __p,$(PROJECTS),$(MAKE) -C $(__p) clean || exit 1; )
