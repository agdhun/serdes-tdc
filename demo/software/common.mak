TARGET_PREFIX=lm32-elf

ifeq ($(USE_CLANG),1)
	# FIXME: clang/llvm target features are broken
	CLANG=clang -ccc-host-triple $(TARGET_PREFIX) \
		-Xclang -target-feature -Xclang -div \
		-Xclang -target-feature -Xclang -mul \
		-Xclang -target-feature -Xclang -barrel \
		-Xclang -target-feature -Xclang -signextend
	CC_normal := $(CLANG)
	CC_quiet = @echo " CC " $@ && $(CLANG)
else
	GCC=$(TARGET_PREFIX)-gcc
	CC_normal := $(GCC)
	CC_quiet = @echo " CC " $@ && $(GCC)
endif

AR_normal := $(TARGET_PREFIX)-ar
LD_normal := $(TARGET_PREFIX)-ld
OBJCOPY_normal := $(TARGET_PREFIX)-objcopy
RANLIB_normal := $(TARGET_PREFIX)-ranlib

AR_quiet = @echo " AR " $@ && $(TARGET_PREFIX)-ar
LD_quiet = @echo " LD " $@ && $(TARGET_PREFIX)-ld
OBJCOPY_quiet = @echo " OBJCOPY " $@ && $(TARGET_PREFIX)-objcopy
RANLIB_quiet = @echo " RANLIB  " $@ && $(TARGET_PREFIX)-ranlib

ifeq ($(V),1)
	CC = $(CC_normal)
	AR = $(AR_normal)
	LD = $(LD_normal)
	OBJCOPY = $(OBJCOPY_normal)
	RANLIB = $(RANLIB_normal)
else
	CC = $(CC_quiet)
	AR = $(AR_quiet)
	LD = $(LD_quiet)
	OBJCOPY = $(OBJCOPY_quiet)
	RANLIB = $(RANLIB_quiet)
endif

# Toolchain options
#
INCLUDES = -I$(TDCDIR)/software/include/base -I$(TDCDIR)/software/include -I$(TDCDIR)/common
CFLAGS = -O9 -Wall -Wstrict-prototypes -Wold-style-definition -Wshadow \
	 -Wmissing-prototypes -fsigned-char -fno-builtin -nostdinc $(INCLUDES)
LDFLAGS = -nostdlib -nodefaultlibs

# compile and generate dependencies, based on
# http://scottmcpeak.com/autodepend/autodepend.html

define compile-dep =
$(CC) -c $(CFLAGS) $< -o $*.o
@$(CC_normal) -MM $(CFLAGS) $< > $*.d
@mv -f $*.d $*.d.tmp
@sed -e 's|.*:|$*.o:|' < $*.d.tmp > $*.d
@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | \
	sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
@rm -f $*.d.tmp
endef
