cmake_minimum_required (VERSION 3.30)
include (CMakePrintHelpers)
include (FetchContent)

# Define the build type
if (NOT CMAKE_BUILD_TYPE)
    set (CMAKE_BUILD_TYPE "Debug")
endif ()

# Set branch names for the sub modules dependencies
# set(GITHUB_BRANCH_TOOLCHAIN "HEAD" CACHE STRING "git SHA for CMake Toolchain")
# set the location of all fetched repos
# set(FETCHCONTENT_BASE_DIR "${CMAKE_SOURCE_DIR}/_deps")
# show limited messages while cloning git repos
# set(FETCHCONTENT_QUIET ON)

# cmake_print_variables(GITHUB_BRANCH_TOOLCHAIN)
#FetchContent_Declare(
#    cmake_scripts                             # Recommendation: Stick close to the original name.
#    GIT_REPOSITORY  git@github.com:kodezine/cmake_scripts.git
#    GIT_TAG         ${GITHUB_BRANCH_TOOLCHAIN}
#)

# pre-fetch the toolchain repository as the first job before project configuration
# FetchContent_GetProperties(cmake_scripts)

#if(NOT cmake_scripts_POPULATED)
#    FetchContent_MakeAvailable(cmake_scripts)
#endif()

project (
    static_libs
    VERSION     1.0.0
    LANGUAGES   C ASM CXX
    DESCRIPTION "static libraries recepies"
)

if (CMAKE_SYSTEM_PROCESSOR STREQUAL "arm")
    # Include dependencies from repositories ---------------------------------------
    #include(${CMAKE_CURRENT_SOURCE_DIR}/frameworks/cmsis_v5/cmsis_v5.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/frameworks/cmsis_v6/cmsis_v6.cmake)
    #include(${CMAKE_CURRENT_SOURCE_DIR}/frameworks/segger_rtt/segger_rtt.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/silicon/st/stm32cubemx.cmake)
    set (cmake_scripts_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
    include (${CMAKE_CURRENT_SOURCE_DIR}/frameworks/cmsis-dsp/cmsis-dsp.cmake)
else ()
    message (STATUS "Compiling for Host system")
endif ()
