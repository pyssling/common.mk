D := $(dir $(lastword $(MAKEFILE_LIST)))
include $(D)/common.mk

$(all): $(D)/a

$(call include_dep_makefile,$(D)/subdir1/Makefile)
$(call include_dep_makefile,$(D)/subdir3/Makefile)

$(D)/a: $(call get_dep,$(D)/subdir1/b) $(d)
	touch $@

$(clean):
	rm -f $(D)/a
