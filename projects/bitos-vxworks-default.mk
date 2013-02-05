#
#   bitos-vxworks-default.mk -- Makefile to build Bit O/S Layer for vxworks
#

export WIND_BASE := $(WIND_BASE)
export WIND_HOME := $(WIND_BASE)/..
export WIND_PLATFORM := $(WIND_PLATFORM)

PRODUCT         := bitos
VERSION         := 0.1.0
BUILD_NUMBER    := 0
PROFILE         := default
ARCH            := $(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/')
OS              := vxworks
CC              := ccpentium
LD              := /usr/bin/ld
CONFIG          := $(OS)-$(ARCH)-$(PROFILE)
LBIN            := $(CONFIG)/bin

BIT_ROOT_PREFIX := /
BIT_CFG_PREFIX  := $(BIT_VER_PREFIX)
BIT_PRD_PREFIX  := $(BIT_ROOT_PREFIX)deploy
BIT_VER_PREFIX  := $(BIT_ROOT_PREFIX)deploy
BIT_BIN_PREFIX  := $(BIT_VER_PREFIX)
BIT_INC_PREFIX  := $(BIT_VER_PREFIX)/inc
BIT_LOG_PREFIX  := $(BIT_VER_PREFIX)
BIT_SPL_PREFIX  := $(BIT_VER_PREFIX)
BIT_SRC_PREFIX  := $(BIT_ROOT_PREFIX)usr/src/bitos-0.1.0
BIT_WEB_PREFIX  := $(BIT_VER_PREFIX)/web
BIT_UBIN_PREFIX := $(BIT_VER_PREFIX)
BIT_MAN_PREFIX  := $(BIT_VER_PREFIX)

CFLAGS          += -fno-builtin -fno-defer-pop -fvolatile  -w
DFLAGS          += -D_REENTRANT -DVXWORKS -DRW_MULTI_THREAD -D_GNU_TOOL  -DCPU=PENTIUM $(patsubst %,-D%,$(filter BIT_%,$(MAKEFLAGS)))
IFLAGS          += -I$(CONFIG)/inc -I$(WIND_BASE)/target/h -I$(WIND_BASE)/target/h/wrn/coreip
LDFLAGS         += '-Wl,-r'
LIBPATHS        += -L$(CONFIG)/bin -L$(CONFIG)/bin
LIBS            += 

DEBUG           := debug
CFLAGS-debug    := -g
DFLAGS-debug    := -DBIT_DEBUG
LDFLAGS-debug   := -g
DFLAGS-release  := 
CFLAGS-release  := -O2
LDFLAGS-release := 
CFLAGS          += $(CFLAGS-$(DEBUG))
DFLAGS          += $(DFLAGS-$(DEBUG))
LDFLAGS         += $(LDFLAGS-$(DEBUG))

unexport CDPATH

all compile: prep \
        

.PHONY: prep

prep:
	@if [ "$(CONFIG)" = "" ] ; then echo WARNING: CONFIG not set ; exit 255 ; fi
	@if [ "$(BIT_PRD_PREFIX)" = "" ] ; then echo WARNING: BIT_PRD_PREFIX not set ; exit 255 ; fi
	@[ ! -x $(CONFIG)/bin ] && mkdir -p $(CONFIG)/bin; true
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc; true
	@[ ! -x $(CONFIG)/obj ] && mkdir -p $(CONFIG)/obj; true
	@[ ! -f $(CONFIG)/inc/bit.h ] && cp projects/bitos-vxworks-default-bit.h $(CONFIG)/inc/bit.h ; true
	@[ ! -f $(CONFIG)/inc/bitos.h ] && cp src/bitos.h $(CONFIG)/inc/bitos.h ; true
	@if ! diff $(CONFIG)/inc/bit.h projects/bitos-vxworks-default-bit.h >/dev/null ; then\
		echo cp projects/bitos-vxworks-default-bit.h $(CONFIG)/inc/bit.h  ; \
		cp projects/bitos-vxworks-default-bit.h $(CONFIG)/inc/bit.h  ; \
	fi; true
clean:

clobber: clean
	rm -fr ./$(CONFIG)

version: 
	@echo 0.1.0-0

