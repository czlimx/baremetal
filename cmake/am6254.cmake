# The Generic system name is used for embedded targets (targets without OS) in
set(CMAKE_SYSTEM_NAME          Generic)
set(CMAKE_SYSTEM_PROCESSOR     aarch64)

set(MY_ARCH         "armv8-a")
set(MY_CPU          "am625x")

set(MPU_FLAGS       "-march=armv8-a -mtune=cortex-a53 -mabi=lp64 -mlittle-endian")
set(VFP_FLAGS       "")
set(ASM_FLAGS       "-nostdlib -fno-builtin -DASSEMBLY")
set(GCC_FLAGS       "-nostdlib -fno-builtin -fdata-sections -ffunction-sections -fno-exceptions -mstrict-align")
set(COM_FLAGS       "-Wall -Werror -Wextra -Wshadow -Wfatal-errors -Wpointer-arith -Wcast-qual -Winline -Wundef -Wredundant-decls -Wstrict-prototypes")
set(SPE_FLAGS       "")
set(LDD_FLAGS       "-nostdlib -fno-builtin -nodefaultlibs -ffreestanding -nostartfiles -Wl,--gc-sections")

include(${CMAKE_CURRENT_LIST_DIR}/aarch64-none-linux-gnu.cmake)
