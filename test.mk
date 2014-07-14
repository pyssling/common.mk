D := $(dir $(lastword $(MAKEFILE_LIST)))
include $(D)/common.mk

build_tests:
	$(MAKE) clean
	$(MAKE) a
	$(MAKE) clean
	$(MAKE) -C subdir1 b
	$(MAKE) clean
	$(MAKE) -C subdir2 c
	$(MAKE) clean
	$(MAKE) -C subdir1 d
	$(MAKE) clean
