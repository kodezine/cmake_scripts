# https://github.com/SEGGERMicro/RTT/archive/refs/tags/V7.54.tar.gz

include(CMakePrintHelpers)
include(FetchContent)

set(GITHUB_BRANCH_SEGGER_RTT "7.54")
set(GITHUB_BRANCH_SEGGER_RTT_MD5 "c6d48403fea85469b3700d73b2c4f379")

cmake_print_variables(GITHUB_BRANCH_SEGGER_RTT)

FetchContent_Declare(
    segger_rtt                             # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP true
    URL https://github.com/SEGGERMicro/RTT/archive/refs/tags/V${GITHUB_BRANCH_SEGGER_RTT}.tar.gz
    URL_HASH MD5=${GITHUB_BRANCH_SEGGER_RTT_MD5}
)

FetchContent_GetProperties(segger_rtt)

if(NOT segger_rtt_POPULATED)
    FetchContent_MakeAvailable(segger_rtt)
endif()

configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeLists.cmake ${segger_rtt_SOURCE_DIR}/CMakeLists.txt COPYONLY)

add_subdirectory(${segger_rtt_SOURCE_DIR})
