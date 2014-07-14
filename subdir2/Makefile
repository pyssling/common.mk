D := $(dir $(lastword $(MAKEFILE_LIST)))
include $(D)/../common.mk

$(all): $(D)/c

$(D)/c:
	touch $@

$(clean):
	rm -f $(D)/c
