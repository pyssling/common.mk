# Copyright (c) 2014, Nils Carlson
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Tests for equality of two strings: a, a -> true
define are_eq
$(and $(findstring $(1),$(2)),$(findstring $(2),$(1)),true)
endef

# Checks for the presence of an element in a list: a, a b c -> true
define is_element_in_list
$(strip $(foreach elem,$(2),$(if $(call are_eq,$(1),$(elem)),true)))
endef

# Returns the tail of an element list: a b c -> b c
define list_tail
$(wordlist 2,$(words $(1)),$(1))
endef

# Splits a path into a list of elements: a/b -> a b
define split_path
$(subst /, ,$(1))
endef

# Joins a list of elements with /'s: a b -> a/b
define _join_path
$(if $(1),/$(firstword $(1))$(call _join_path,$(call list_tail,$(1))))
endef

define join_path
$(if $(1),$(firstword $(1))$(call _join_path,$(call list_tail,$(1))))
endef

# Replaces path elements with parent references: a/b -> ../..
define parent_dirs
$(call join_path,$(foreach dir,$(call split_path,$(1)),..))
endef


# Takes the final differing paths and computes the relative path:
# a,   -> ..
#  , b -> b
# a, b -> ../b
define ___rel_path
$(if $(call are_eq,$(1),),
$(call parent_dirs,$(2)),
$(if $(call are_eq,$(2),),
$(call, join_path,$(1)),
$(call join_path,$(call parent_dirs,$(2)) $(1))))
endef


# Recursively strip the paths from common elements
# and then calls ___rel_path to create the relative path:
# a b c d, a b c e -> ___rel_path(d, e)
define __rel_path
$(if $(call are_eq,$(firstword $(1)),$(firstword $(2))),
$(call __rel_path,$(call list_tail,$(1)),$(call list_tail,$(2))),
$(call ___rel_path,$(1),$(2)))
endef


# First checks if the paths are identical, then the path is .
# Else call __rel_path to calculate the relative paths:
# a/b, a/b -> true
define _rel_path
$(if $(call are_eq,$(1),$(2)),.,\
$(call __rel_path,$(call split_path,$(1)),$(call split_path,$(2))))
endef

# Computes the path of $(1) relative $(2):
# a/b/c, a/b/d -> ../c
define rel_path
$(strip $(call _rel_path,$(abspath $(1)),$(abspath $(2))))
endef

# Returns the path of a files and directories relative the current directory
# CURDIR = a/b
# a/b/c -> c
define get_dep
$(foreach dep,$(1),$(call rel_path,$(dep),$(CURDIR)))
endef

# Creates a dependency for all headers needed by the objects
define get_hdrs
$(foreach obj,$(1),$(obj) \
$(eval -include $(obj:.o=.d)) \
$(eval $(obj): CFLAGS += -MD))
endef

# Push a word onto a stack
# var = a, stack = b c -> stack = a b c
# a,b c-> a b c
define push
$(eval $(2) := $(1) $($(2)))
endef

# Pop a word from a stack
# var = , stack = a b c -> var = a, stack = b c
define pop
$(eval $(1) := $(firstword $($(2)))) \
$(eval $(2) := $(call list_tail,$($(2))))
endef

# Rewrites the directory variable to be relative $(CURDIR)
D := $(call rel_path,$(D),$(CURDIR))

# Identify this file, common.mk
__COMMON_MK := $(lastword $(MAKEFILE_LIST))
# Identify the Makefile which included common.mk
__CUR_MAKEFILE := $(abspath $(lastword $(filter-out $(__COMMON_MK),$(MAKEFILE_LIST))))
# Append the Makefile to the Makefile list
__ABS_MAKEFILE_LIST := $(__CUR_MAKEFILE) $(__ABS_MAKEFILE_LIST)

# create variables representing common targets
all := $(__CUR_MAKEFILE)_all
clean := $(__CUR_MAKEFILE)_clean

# Ensure that these operate on the correct directories
$(__CUR_MAKEFILE)_all: D := $(D)
$(__CUR_MAKEFILE)_clean: D := $(D)

# Connect these to the normal dummy targets
all: $(all)
clean: $(clean)

# Make them all phony
.PHONY: $(all) $(clean) all clean

# Includes a Makefile with dependencies of the current Makefile once.
# Restores the current directory variable $(D) after.
define include_dep_makefile
$(if $(call is_element_in_list,$(abspath $(1)),$(__ABS_MAKEFILE_LIST)),, \
$(call push,$(D),__MAKEFILE_DIR_STACK) \
$(call push,$(all),__ALL_STACK) \
$(call push,$(clean),__CLEAN_STACK) \
$(eval include $(1)) \
$(call pop,all,__ALL_STACK) \
$(call pop,clean,__CLEAN_STACK) \
$(call pop,D,__MAKEFILE_DIR_STACK))
endef
