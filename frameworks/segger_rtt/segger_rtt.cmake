# https://github.com/SEGGERMicro/RTT/archive/refs/tags/V7.54.tar.gz

include(CMakePrintHelpers)
include(FetchContent)

set(libName "segger_rtt")

if(NOT DEFINED GITHUB_BRANCH_${libName})
    set(GITHUB_BRANCH_${libName} "7.54")
    set(GITHUB_BRANCH_${libName}_MD5 "c6d48403fea85469b3700d73b2c4f379")
endif()

message(STATUS "${libName}: ${GITHUB_BRANCH_${libName}}")

FetchContent_Declare(
    ${libName}                             # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP true
    URL https://github.com/SEGGERMicro/RTT/archive/refs/tags/V${GITHUB_BRANCH_${libName}}.tar.gz
    URL_HASH MD5=${GITHUB_BRANCH_${libName}_MD5}
)

FetchContent_GetProperties(${libName})

if(NOT ${libName}_POPULATED)
    FetchContent_MakeAvailable(${libName})
endif()

configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeLists.cmake ${${libName}_SOURCE_DIR}/CMakeLists.txt COPYONLY)

add_subdirectory(${${libName}_SOURCE_DIR})
