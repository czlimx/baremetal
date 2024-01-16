##########################################################################################################################
# File automatically-generated by tool: [projectgenerator] version: [3.15.2] date: [Fri Feb 24 23:44:06 CST 2023]
##########################################################################################################################

######################################
# target
######################################
ifeq ("$(origin SOC)", "command line")
  	COMPILE_TARGET := $(SOC)
else
	COMPILE_TARGET = am6254
endif

BUILD_BOARD := CONFIG_$(shell echo $(COMPILE_TARGET) | tr a-z A-Z)

# Build path
BUILD_DIR = build

# Binaries path
BIN_DIR = bin

#######################################
# binaries
#######################################
CROSS_COMPILE 	 = aarch64-none-linux-gnu-
AS			  	 = $(CROSS_COMPILE)as
LD			  	 = $(CROSS_COMPILE)ld
CC			  	 = $(CROSS_COMPILE)gcc
SZ			  	 = $(CROSS_COMPILE)size
OBJCOPY		  	 = $(CROSS_COMPILE)objcopy
OBJDUMP		  	 = $(CROSS_COMPILE)objdump

# compile gcc flags
BUILD_CFLAGS   := -march=armv8-a -mtune=cortex-a53 \
				  -mlittle-endian -nostdlib -fno-builtin \
				  -Wall -Werror -Wextra -Wshadow \
		   		  -Wfatal-errors -Wpointer-arith \
		   		  -Wcast-qual -Winline -Wundef \
		   		  -Wredundant-decls -Wstrict-prototypes \
				  -fdata-sections -ffunction-sections \
				  -fno-exceptions -mstrict-align \
		   		  -std=c99 -O0 -g -gdwarf-2 \
				  -D$(BUILD_BOARD)
BUILD_AFLAGS   := -D__ASSEMBLY__

# Generate dependency information
LINKS_CFLAGS   := -Tscript/links/${COMPILE_TARGET}.lds \
				  -fno-builtin -ffreestanding \
				  -nostdlib -nodefaultlibs \
				  -nostartfiles -Wl,--gc-sections \
				  -Wl,-Map=${BIN_DIR}/${COMPILE_TARGET}.map

######################################
# source
######################################
CC_INCLUDES = \
-Icore/aarch64/include \
-Icore/gic/include

ASM_SOURCES = \
core/aarch64/src/arch_vectors.s \
core/aarch64/src/arch_startup.s \
core/aarch64/src/arch_cache.s \
core/aarch64/src/arch_system.s \
core/aarch64/src/arch_pmu.s 

CCC_SOURCES = \
core/aarch64/src/arch_init.c \
core/aarch64/src/arch_libc.c \
core/gic/src/gic_dist.c

#######################################
# build the application
#######################################
# default action: build all
all: $(BIN_DIR)/$(COMPILE_TARGET).elf $(BIN_DIR)/$(COMPILE_TARGET).dis $(BIN_DIR)/$(COMPILE_TARGET).bin

# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(CCC_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(CCC_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	@$(CC) $(CC_INCLUDES) -c $(BUILD_CFLAGS) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	@$(CC) -x assembler-with-cpp $(CC_INCLUDES) -c $(BUILD_CFLAGS) $(BUILD_AFLAGS) $< -o $@

$(BIN_DIR)/$(COMPILE_TARGET).elf: $(OBJECTS) Makefile | $(BIN_DIR)
	@$(CC) $(OBJECTS) $(LINKS_CFLAGS) -o $@
	@$(SZ) $@

$(BIN_DIR)/%.dis: $(BIN_DIR)/%.elf | $(BIN_DIR)
	@$(OBJDUMP) -D $< > $@
	
$(BIN_DIR)/%.bin: $(BIN_DIR)/%.elf | $(BIN_DIR)
	@$(OBJCOPY) -O binary -S $< $@
	
$(BUILD_DIR):
	@mkdir $@	

$(BIN_DIR):
	@mkdir $@	

#######################################
# clean up
#######################################
clean:
	@rm -rf $(BUILD_DIR)/*
  
#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***