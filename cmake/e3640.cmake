# The Generic system name is used for embedded targets (targets without OS) in
set(CMAKE_SYSTEM_NAME          Generic)
set(CMAKE_SYSTEM_PROCESSOR     cortex-r5)

set(RTOS_ARCH     "armv7-r")
set(RTOS_CPU      "e3")

set(MPU_FLAGS     "-march=armv7-r -marm -mtune=cortex-r5")
set(VFP_FLAGS     "-mfpu=vfpv3-d16 -mfloat-abi=hard")
set(ASM_FLAGS     "-nostdlib -fno-builtin")
set(GCC_FLAGS     "-fno-builtin -fdata-sections -ffunction-sections -fno-exceptions -fno-builtin -mno-unaligned-access")
set(COM_FLAGS     "-Wall -Werror -Wextra -Wshadow -Wfatal-errors -Wpointer-arith -Wcast-qual -Winline -Wundef -Wredundant-decls -Wstrict-prototypes")
set(SPE_FLAGS     "--specs=nosys.specs")
set(LDD_FLAGS     "-nostartfiles -Wl,--gc-sections -Wl,--print-memory-usage")

include(${CMAKE_CURRENT_LIST_DIR}/arm-none-eabi.cmake)