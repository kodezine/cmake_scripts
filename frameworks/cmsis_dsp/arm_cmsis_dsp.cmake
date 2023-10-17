include(CMakePrintHelpers)
include(FetchContent)

set(libName cmsis_dsp)
set(GITHUB_BRANCH_${libName} "1.15.0")
message(STATUS "${libName}: ${GITHUB_BRANCH_${libName}}")
# precompilation
if (DEFINED PRECOMPILED_TAG_${libName})
    message(STATUS "${libName}: Precompiled tag ${PRECOMPILED_TAG_${libName}}")
    FetchContent_Declare(
        ${libName}                              # Recommendation: Stick close to the original name.
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        URL https://github.com/kodezine/${libName}/releases/download/v${PRECOMPILED_TAG_${libName}}/${libName}-${GITHUB_BRANCH_${libName}}-$ENV{CORTEX_TYPE}-${CMAKE_C_COMPILER_ID}-${CMAKE_C_COMPILER_VERSION}.tar.gz
        FIND_PACKAGE_ARGS NAMES ${libName}
    )
    FetchContent_MakeAvailable(${libName})
    find_package(${libName})
else ()
    message(STATUS "${libName}: Compile from source")
    FetchContent_Declare(
        ${libName}                              # Recommendation: Stick close to the original name.
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        URL https://github.com/ARM-software/CMSIS-DSP/archive/refs/tags/v${GITHUB_BRANCH_${libName}}.tar.gz
    )
    FetchContent_GetProperties(${libName})
    if(NOT ${libName}_POPULATED)
        FetchContent_Populate(${libName})
        configure_file(${CMAKE_CURRENT_LIST_DIR}/${libName}Config.cmake ${${libName}_SOURCE_DIR}/${libName}Config.cmake COPYONLY)
        add_subdirectory(${CMAKE_CURRENT_LIST_DIR})
    endif ()
endif ()
