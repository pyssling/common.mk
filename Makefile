D := $(dir $(lastword $(MAKEFILE_LIST)))
include $(D)/common.mk

$(D)/a: $(call get_dep,$(D)/subdir1/b) $(d)
	touch $@

$(call include_dep_makefile,$(D)/subdir1/Makefile)

$(D)_clean:
	rm -f $(D)/a

clean: $(D)_clean
