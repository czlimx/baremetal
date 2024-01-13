# Define our target library and an alias for consumers
target_sources(${PROJECT_NAME}
    PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/${MY_ARCH}/src/arch_startup.s
    ${CMAKE_CURRENT_LIST_DIR}/${MY_ARCH}/src/arch_vectors.s
    ${CMAKE_CURRENT_LIST_DIR}/${MY_ARCH}/src/arch_init.c
    ${CMAKE_CURRENT_LIST_DIR}/${MY_ARCH}/src/arch_cache.s
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/${MY_ARCH}/include
)
