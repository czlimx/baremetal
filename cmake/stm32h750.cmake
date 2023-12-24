# Name of the target
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR cortex-m7)

set(RTOS_ARCH    "armv7-m")
set(RTOS_CPU     "stm32h7")

set(MPU_FLAGS    "-mthumb -mcpu=cortex-m7")
set(VFP_FLAGS     "-mfloat-abi=hard -mfpu=fpv5-d16")
set(ASM_FLAGS     "")
set(GCC_FLAGS     "-fno-builtin -fdata-sections -ffunction-sections -fno-exceptions")
set(COM_FLAGS     "-Werror -Wall -Wextra -Wshadow -Wfatal-errors -Wpointer-arith -Wcast-qual -Winline -Wundef -Wredundant-decls -Wstrict-prototypes")
set(SPE_FLAGS     "--specs=nosys.specs")
set(LDD_FLAGS     "-nostartfiles")

include(${CMAKE_CURRENT_LIST_DIR}/arm-none-eabi.cmake)
