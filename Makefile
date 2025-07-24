# override with `make BUILD=release`
# default to debug build
BUILD := debug
BIN := exe

# using make's computed variables to select object and bin folders
# depending on the build type and compilation
BUILD_DIR := ./build
OBJ_DIR.debug := $(BUILD_DIR)/obj/debug
OBJ_DIR.release := $(BUILD_DIR)/obj/release
OBJ_DIR := $(OBJ_DIR.$(BUILD))
BIN_DIR.debug := $(BUILD_DIR)/bin/debug
BIN_DIR.release := $(BUILD_DIR)/bin/release
BIN_DIR := $(BIN_DIR.$(BUILD))
DEP_DIR.debug :=$(BUILD_DIR)/dep/debug
DEP_DIR.release := $(BUILD_DIR)/dep/release
DEP_DIR=$(DEP_DIR.$(BUILD))
CFLAGS.debug=-W -Wall -ansi -pedantic -g
CFLAGS.release=-W -Wall -ansi -pedantic
CFLAGS=$(CFLAGS.$(BUILD))
SRC_DIR := ./src
INC_DIR := ./inc

CC := gcc
LDFLAGS :=
SRC := $(wildcard $(SRC_DIR)/*.c)
OBJ := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC))
DEP := $(patsubst $(SRC_DIR)/%.c,$(DEP_DIR)/%.d,$(SRC))

all:$(BIN_DIR)/$(BIN)

$(BIN_DIR)/$(BIN) : $(OBJ)
	mkdir -p $(BIN_DIR)
	$(CC) -o $@ $^ $(LDFLAGS) -I $(INC_DIR)

# $(OBJ_DIR)/%.o : $(DEP_DIR)/%.d

$(DEP_DIR)/%.d : $(SRC_DIR)/%.c
	set -e; mkdir -p $(DEP_DIR); rm -f $@; \
	$(CC) -MM $(CFLAGS) $< -I $(INC_DIR) > $@.$$$$; \
	sed 's|$*.o[ :]*|$(OBJ_DIR)/$*.o $@ : |g' < $@.$$$$ > $@; \
	printf "\tmkdir -p $(OBJ_DIR)\n\t$(CC) -o $(OBJ_DIR)/$*.o -c $< $(CFLAGS) -I $(INC_DIR)">>$@; \
	rm -f $@.$$$$

ifeq (,$(filter clean mrproper,$(MAKECMDGOALS)))
include $(DEP)
endif


.PHONY : clean mrproper

clean:
	rm -rf $(OBJ_DIR)/*
	rm -rf $(DEP_DIR)/*
	rm -rf $(BIN_DIR)/*

mrproper:
	rm -rf $(BUILD_DIR)
