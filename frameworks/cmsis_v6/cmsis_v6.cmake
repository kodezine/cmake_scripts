include (CMakePrintHelpers)
include (FetchContent)

set (libName "cmsis_v6")
set (GITHUB_BRANCH_${libName} "6.1.0")
message (STATUS "${libName}: ${GITHUB_BRANCH_${libName}}")

if (DEFINED PRECOMPILED_TAG_${libName})
    message (STATUS "${libName}: Precompiled tag ${PRECOMPILED_TAG_${libName}}")
    FetchContent_Declare (
        ${libName}                             # Recommendation: Stick close to the original name.
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        URL https://github.com/kodezine/${libName}/releases/download/v${PRECOMPILED_TAG_${libName}}/${libName}-${GITHUB_BRANCH_${libName}}-$ENV{CORTEX_TYPE}-${CMAKE_C_COMPILER_ID}-${CMAKE_C_COMPILER_VERSION}.tar.gz
        FIND_PACKAGE_ARGS NAMES ${libName}
    )
    FetchContent_MakeAvailable (${libName})
    find_package (${libName})
    # export the two includes
    set (${libName}_CORE_INCLUDE_PATH "${${libName}_SOURCE_DIR}/include/${libName}" CACHE PATH "Path to the cmsis v5 includes")
    set (${libName}_DEVICE_INCLUDE_PATH "${${libName}_SOURCE_DIR}/include/${libName}" CACHE PATH "Path to the cmsis v5 device folder")
else ()
    message (STATUS "${libName}: Compile from source")
    FetchContent_Declare (
        ${libName}                             # Recommendation: Stick close to the original name.
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        URL https://github.com/ARM-software/CMSIS_6/archive/refs/tags/v${GITHUB_BRANCH_${libName}}.tar.gz
    )
    FetchContent_GetProperties (${libName})
    if (NOT ${libName}_POPULATED)
        FetchContent_MakeAvailable (${libName})
        configure_file (${CMAKE_CURRENT_LIST_DIR}/${libName}Config.cmake ${${libName}_SOURCE_DIR}/${libName}Config.cmake COPYONLY)
        configure_file (${CMAKE_CURRENT_LIST_DIR}/${libName}.CMakeLists.cmake ${${libName}_SOURCE_DIR}/CMakeLists.txt COPYONLY)
        add_subdirectory (${${libName}_SOURCE_DIR} ${${libName}_BINARY_DIR})
    endif ()
    # export the three includes
    set (${libName}_CORE_PATH "${${libName}_SOURCE_DIR}/CMSIS/Core" CACHE PATH "Path to cmsis core folder")
    set (${libName}_CORE_INCLUDE_PATH "${${libName}_SOURCE_DIR}/CMSIS/Core/Include" CACHE PATH "Path to the cmsis v5 includes")
    set (${libName}_DEVICE_INCLUDE_PATH "${${libName}_SOURCE_DIR}/Device/ARM/ARM$ENV{CORTEX_TYPE}/Include" CACHE PATH "Path to the cmsis v5 device folder")
endif ()
