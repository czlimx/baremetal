# Define our target library and an alias for consumers
target_sources(${PROJECT_NAME}
    PRIVATE
	${CMAKE_CURRENT_LIST_DIR}/src/arch_startup.s
    ${CMAKE_CURRENT_LIST_DIR}/src/arch_vectors.s
    ${CMAKE_CURRENT_LIST_DIR}/src/arch_init.c
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/include
)
