D := $(dir $(lastword $(MAKEFILE_LIST)))
include $(D)/common.mk

$(all): build_tests

build_tests:
	$(MAKE) clean
	$(MAKE) a
	$(MAKE) clean
	$(MAKE) -C subdir1 b
	$(MAKE) -C subdir1 clean
	$(MAKE) -C subdir2 c
	$(MAKE) -C subdir2 clean
	$(MAKE) -C subdir1 d
	$(MAKE) -C subdir1 clean
