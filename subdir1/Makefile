D := $(dir $(lastword $(MAKEFILE_LIST)))
include $(D)/../common.mk

$(call include_dep_makefile,$(D)/../subdir2/Makefile)

$(D)/b: $(call get_dep,$(D)/../subdir2/c)
	touch $@

d := $(D)/d

$(d):
	touch $@
