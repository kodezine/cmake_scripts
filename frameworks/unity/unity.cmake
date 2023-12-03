include(FetchContent)
include(CMakePrintHelpers)
# The options to build the Fixtures and Memory for Unity are enabled here.
set(UNITY_EXTENSION_FIXTURE ON CACHE BOOL "Build unity with fixture")
set(UNITY_EXTENSION_MEMORY  ON CACHE BOOL "Build unity with memory")

set(GITHUB_BRANCH_UNITY "2.5.2")
set(GITHUB_BRANCH_UNITY_MD5 "41e6422c3a54a395abcae531293e254c")

cmake_print_variables(GITHUB_BRANCH_UNITY)

FetchContent_Declare(
    unity # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP true
    URL https://github.com/ThrowTheSwitch/Unity/archive/refs/tags/v${GITHUB_BRANCH_UNITY}.tar.gz
    URL_HASH MD5=${GITHUB_BRANCH_UNITY_MD5}
)

FetchContent_GetProperties(unity)

if(NOT unity_POPULATED)
    FetchContent_Populate(unity)
    enable_testing()
    # this is common for both host and target
    add_subdirectory(${unity_SOURCE_DIR} ${unity_BINARY_DIR})
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "arm")
        include(${CMAKE_CURRENT_LIST_DIR}/target/unity_target.cmake)
    else()
        include(${CMAKE_CURRENT_LIST_DIR}/host/unity_host.cmake)
    endif()
endif()

# establish the unity framework
set(ENV{UNITY_DIR} ${unity_SOURCE_DIR})
