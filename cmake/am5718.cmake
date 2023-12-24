# The Generic system name is used for embedded targets (targets without OS) in
set(CMAKE_SYSTEM_NAME          Generic)
set(CMAKE_SYSTEM_PROCESSOR     cortex-a15)

set(RTOS_ARCH     "armv7-a")
set(RTOS_CPU      "am57xx")

set(MPU_FLAGS     "-march=armv7-a -marm -mtune=cortex-a15")
set(VFP_FLAGS     "-mfpu=vfpv3-d16 -mfloat-abi=hard")
set(ASM_FLAGS     "-nostdlib -fno-builtin")
set(GCC_FLAGS     "-fno-builtin -fdata-sections -ffunction-sections -fno-exceptions -nostdlib -fno-builtin -mno-unaligned-access")
set(COM_FLAGS     "-Wall -Werror -Wextra -Wshadow -Wfatal-errors -Wpointer-arith -Wcast-qual -Winline -Wundef -Wredundant-decls -Wstrict-prototypes")
set(SPE_FLAGS     "--specs=nosys.specs")
set(LDD_FLAGS     "-nostartfiles -nodefaultlibs -nostdlib -Wl,--gc-sections -Wl,--print-memory-usage")

include(${CMAKE_CURRENT_LIST_DIR}/arm-none-eabi.cmake)