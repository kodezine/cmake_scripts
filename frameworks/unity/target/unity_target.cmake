# file that appends values for unity to work with Segger RTT framework
message (STATUS "Unity: Custom config file with Segger RTT")
add_definitions(-DUNITY_INCLUDE_CONFIG_H)
configure_file(${CMAKE_CURRENT_LIST_DIR}/unity_rtt_config.h ${unity_SOURCE_DIR}/src/unity_config.h COPYONLY)

# this is common for both host and target
add_subdirectory(${unity_SOURCE_DIR} ${unity_BINARY_DIR})

# this links the segger rtt library
message (STATUS "Unity: Linking with Segger RTT")
target_link_libraries(unity
    PUBLIC                  # The use of SEGGER RTT has to be public, else header is not found
        segger_rtt
)

# include functions for generation of test runner for target
include(${CMAKE_CURRENT_LIST_DIR}/cortex-m.cmake)
