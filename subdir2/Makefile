D := $(dir $(lastword $(MAKEFILE_LIST)))
include $(D)/../common.mk

$(D)/c:
	touch $@

$(D)_clean:
	rm -f $(D)/c

clean: $(D)_clean
