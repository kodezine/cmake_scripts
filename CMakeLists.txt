cmake_minimum_required (VERSION 3.30)
include (CMakePrintHelpers)
include (FetchContent)

# Define the build type
if (NOT CMAKE_BUILD_TYPE)
    set (CMAKE_BUILD_TYPE "Debug")
endif ()

set (cmake_scripts_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

project (
    static_libs
    VERSION     1.0.0
    LANGUAGES   C ASM CXX
    DESCRIPTION "static libraries recepies"
)

if (CMAKE_SYSTEM_PROCESSOR STREQUAL "arm")
    if (test_all_frameworks STREQUAL "true")
        # Include dependencies from repositories ---------------------------------------
        include (${CMAKE_CURRENT_SOURCE_DIR}/frameworks/cmsis_v5/cmsis_v5.cmake)
        include (${CMAKE_CURRENT_SOURCE_DIR}/frameworks/cmsis_v6/cmsis_v6.cmake)
        include (${CMAKE_CURRENT_SOURCE_DIR}/frameworks/segger_rtt/segger_rtt.cmake)
        include (${CMAKE_CURRENT_SOURCE_DIR}/frameworks/cmsis-dsp/cmsis-dsp.cmake)
        include (${CMAKE_CURRENT_SOURCE_DIR}/silicon/st/stm32cubexx.cmake)
    else ()
        message (STATUS "Configuration provided")
    endif ()

else ()
    message (STATUS "Compiling for Host system")
endif ()
