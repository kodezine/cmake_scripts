include (CMakePrintHelpers)
include (FetchContent)

set (libName "cmsis-dsp")

if (NOT DEFINED GITHUB_BRANCH_${libName})
    set (GITHUB_BRANCH_${libName} "1.15.0")
endif ()

message (STATUS "${libName}: ${GITHUB_BRANCH_${libName}}")
# bring in the cmsis core folder as CMSISCORE here.
include (${CMAKE_CURRENT_LIST_DIR}/${libName}.cmsis.cmake)

# precompilation
if (DEFINED PRECOMPILED_TAG_${libName})
    message (STATUS "${libName}: Precompiled tag ${PRECOMPILED_TAG_${libName}}")
    FetchContent_Declare (
        ${libName}                              # Recommendation: Stick close to the original name.
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        URL https://github.com/kodezine/${libName}/releases/download/v${PRECOMPILED_TAG_${libName}}/${libName}-${GITHUB_BRANCH_${libName}}-$ENV{CORTEX_TYPE}-${CMAKE_C_COMPILER_ID}-${CMAKE_C_COMPILER_VERSION}.tar.gz
        FIND_PACKAGE_ARGS NAMES ${libName}
    )
    FetchContent_MakeAvailable (${libName})
    find_package (${libName})
else ()
    message (STATUS "${libName}: Compile from source")
    FetchContent_Declare (
        ${libName}                              # Recommendation: Stick close to the original name.
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        URL https://github.com/ARM-software/CMSIS-DSP/archive/refs/tags/v${GITHUB_BRANCH_${libName}}.tar.gz
    )
    FetchContent_MakeAvailable (${libName})
endif ()
