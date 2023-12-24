cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)

# Set up the project
project(baremetal LANGUAGES C ASM)

# clear not used warning
if(DEFINED _initial_CMAKE_TOOLCHAIN_FILE
   AND NOT _initial_CMAKE_TOOLCHAIN_FILE STREQUAL CMAKE_TOOLCHAIN_FILE)
  #message(WARNING "The CMAKE_TOOLCHAIN_FILE cannot be changed")
elseif(DEFINED CMAKE_TOOLCHAIN_FILE)
  set(_initial_CMAKE_TOOLCHAIN_FILE "${CMAKE_TOOLCHAIN_FILE}" CACHE INTERNAL "")
endif()

# set binary dir
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin/${MY_ARCH}/${MY_CPU}/${MY_BOARD})

# Define our target library and an alias for consumers
add_link_options(-T${CMAKE_CURRENT_LIST_DIR}/script/links/${MY_BOARD}.lds -Wl,-Map=${EXECUTABLE_OUTPUT_PATH}/${PROJECT_NAME}.map,--cref)

# Define our target
add_executable(${PROJECT_NAME})

# add link static library for our target
link_directories(${COMPILE_DIRECTORY}/lib)
target_link_libraries(${PROJECT_NAME} -lgcc)

# Pick up the port specific variables and apply them
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/code/mcore/${MY_ARCH})

# post build command
add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJDUMP} -D $<TARGET_FILE:${PROJECT_NAME}> > ${EXECUTABLE_OUTPUT_PATH}/${PROJECT_NAME}.dis
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${PROJECT_NAME}> > ${EXECUTABLE_OUTPUT_PATH}/${PROJECT_NAME}.bin
)
