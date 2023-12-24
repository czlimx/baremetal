# The Generic system name is used for embedded targets (targets without OS) in
set(CMAKE_SYSTEM_NAME          Generic)
set(CMAKE_SYSTEM_PROCESSOR     cortex-a8)

set(RTOS_ARCH     "armv7-a")
set(RTOS_CPU      "am335x")

set(MPU_FLAGS     "-march=armv7-a -marm -mtune=cortex-a8")
set(VFP_FLAGS     "-mfpu=vfpv3-d16 -mfloat-abi=hard")
set(ASM_FLAGS     "-nostdlib -fno-builtin -x assembler-with-cpp -DASSEMBLY")
set(GCC_FLAGS     "-nostdlib -fno-builtin -fdata-sections -ffunction-sections -fno-exceptions -mno-unaligned-access")
set(COM_FLAGS     "-Wall -Werror -Wextra -Wshadow -Wfatal-errors -Wpointer-arith -Wcast-qual -Winline -Wundef -Wredundant-decls -Wstrict-prototypes")
set(SPE_FLAGS     "")
set(LDD_FLAGS     "-nostdlib -fno-builtin -nodefaultlibs -ffreestanding -nostartfiles -Wl,--gc-sections")

include(${CMAKE_CURRENT_LIST_DIR}/arm-none-eabi.cmake)