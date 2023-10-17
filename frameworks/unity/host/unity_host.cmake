message (STATUS "Unity: Without custom config file")

# this is common for both host and target
add_subdirectory(${unity_SOURCE_DIR} ${unity_BINARY_DIR})

# include functions for generation of test runner for host
include(${CMAKE_CURRENT_LIST_DIR}/host.cmake)
