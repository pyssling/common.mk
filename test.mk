D := $(dir $(lastword $(MAKEFILE_LIST)))
include $(D)/common.mk

ALL_TGTS=a subdir1/b subdir1/d subdir2/c
CLEAN_TEST=set -e ; for t in $(ALL_TGTS); do ! test -f $$t || (echo "Not cleaned: $$t"; exit 1); done

build_tests:
	$(MAKE) clean
	$(CLEAN_TEST)
	$(MAKE) a
	# a depends on subdir1/b, which depends on subdir2/c
	test -f a
	test -f subdir1/b
	test -f subdir2/c
	$(MAKE) clean
	$(CLEAN_TEST)
	$(MAKE) -C subdir1 b
	# subdir1/b depends on subdir2/c
	test -f subdir1/b
	test -f subdir2/c
	$(MAKE) clean
	$(CLEAN_TEST)
	$(MAKE) -C subdir2 c
	test -f subdir2/c
	$(MAKE) clean
	$(CLEAN_TEST)
	$(MAKE) -C subdir1 d
	test -f subdir1/d
	$(MAKE) clean
	$(CLEAN_TEST)
