D := $(dir $(lastword $(MAKEFILE_LIST)))
include $(D)/common.mk

$(all): build_tests

all_tgts=a subdir1/b subdir1/d subdir2/c subir3/hello_world \
	$(addprefix subdir3/hello_world, .o .d)

define clean_test
$(foreach t,$(all_tgts),
test ! -f $(t) || ( echo "Not cleaned: $(t)" &&  exit 1 ) )
endef

define target_test
$(foreach t,$(1),
test -f $(t) || ( echo "Target not built: $(t)" && exit 1 ) )
endef

define build_test
$(MAKE) -C $(1) $(2)
$(call target_test,$(3))
$(MAKE) -C $(1) clean
$(call clean_test)
endef

build_tests:
	$(MAKE) clean
	$(call clean_test)
	$(call build_test, ., a, a subdir1/b subdir1/d subdir2/c)
	$(call build_test, subdir1, b, subdir1/b subdir2/c)
	$(call build_test, subdir2, c, subdir2/c)
	$(call build_test, subdir1, d, subdir1/d)
	$(call build_test, subdir3, hello_world, subdir3/hello_world)
