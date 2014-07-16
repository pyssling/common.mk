D := $(dir $(lastword $(MAKEFILE_LIST)))
include $(D)/../common.mk

$(all): $(D)/hello_world

$(D)/hello_world: $(call get_hdrs, $(D)/hello_world.o)

$(clean):
	rm -f $(D)/hello_world
	rm -f $(addprefix $(D)/hello_world, .o .d)