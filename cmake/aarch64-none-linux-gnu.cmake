# Toolchain settings
set(COMPILE_DIRECTORY   /home/czlimx/toolchain/aarch64-none-linux-gnu)
set(CROSS_COMPILE       aarch64-none-linux-gnu-)
set(CMAKE_C_COMPILER    ${CROSS_COMPILE}gcc)
set(CMAKE_CXX_COMPILER  ${CROSS_COMPILE}g++)
set(AS                  ${CROSS_COMPILE}as)
set(AR                  ${CROSS_COMPILE}ar)
set(OBJCOPY             ${CROSS_COMPILE}objcopy)
set(OBJDUMP             ${CROSS_COMPILE}objdump)
set(SIZE                ${CROSS_COMPILE}size)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER)

# this makes the test compiles use static library option so that we don't need to pre-set linker flags and scripts
set(CMAKE_C_FLAGS   "${MPU_FLAGS} ${VFP_FLAGS} ${COM_FLAGS} ${GCC_FLAGS}" CACHE INTERNAL "c compiler flags")
set(CMAKE_ASM_FLAGS "${MPU_FLAGS} ${VFP_FLAGS} ${COM_FLAGS} ${ASM_FLAGS}" CACHE INTERNAL "asm compiler flags")
set(CMAKE_EXE_LINKER_FLAGS "${MPU_FLAGS} ${SPE_FLAGS} ${LDD_FLAGS} ${CMAKE_EXE_LINKER_FLAGS} -static-libgcc -Wl,--print-memory-usage ${CMAKE_LINK_FLAGS}" CACHE INTERNAL "exe link flags")

SET(CMAKE_C_FLAGS_DEBUG "-O0 -g -gdwarf-2" CACHE INTERNAL "c debug compiler flags")
SET(CMAKE_ASM_FLAGS_DEBUG "-g -gdwarf-2" CACHE INTERNAL "asm debug compiler flags")

SET(CMAKE_C_FLAGS_RELEASE "-O3" CACHE INTERNAL "c release compiler flags")
SET(CMAKE_ASM_FLAGS_RELEASE "" CACHE INTERNAL "asm release compiler flags")
