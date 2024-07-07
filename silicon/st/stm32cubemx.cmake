include (CMakePrintHelpers)
include (FetchContent)

set (libName "stm32cubemx")

# include list of all supported STM32 Devices, checks if the valid device is defined
include (${CMAKE_CURRENT_LIST_DIR}/stm32devices.cmake)
# include list of all supported STM32 Types, lower case STM32_TYPE from STM32_DEVICE
include (${CMAKE_CURRENT_LIST_DIR}/stm32types.cmake)
# include the selection of cmsis used for this build
include (${CMAKE_CURRENT_LIST_DIR}/${libName}.cmsis.cmake)

if (NOT DEFINED GITHUB_BRANCH_${libName})
    set (GITHUB_BRANCH_${libName} "1.11.5")
endif ()

message (STATUS "${libName}: ${GITHUB_BRANCH_${libName}}")
# precompilation
if (DEFINED PRECOMPILED_TAG_${libName})
    include (${CMAKE_CURRENT_LIST_DIR}/${libName}.precompiled.cmake)
else ()
    ### Determine if valid definitions exist for build from sources
    #1# overarching HAL and CMSIS driver repo fetching mechanism for STM32 microcontrollers
    if (NOT DEFINED ENV{CORTEX_TYPE})
        message (FATAL_ERROR "${libName}: needs a cortex type defined")
    endif ()

    #2# the variable value should be always upper case
    string (TOUPPER ${STM32_TYPE} UPPERCASE_STM32_TYPE)
    string (TOLOWER ${STM32_TYPE} LOWERCASE_STM32_TYPE)

    #5# use the device family to set a cache variable for ARM Cortex Mx family here
    set (ARMCMSIS_DEVICE "ARM$ENV{CORTEX_TYPE}" CACHE STRING "CMSIS Arm Cortex Device type to match folder" FORCE)

    #6# set the cubemx variable for a particular stm32 type
    set (STM32CubeXX STM32Cube${UPPERCASE_STM32_TYPE} CACHE STRING "CUBEMx String for controller family")

    FetchContent_Declare (
        ${libName}                  # Recommendation: Stick close to the original name.
        DOWNLOAD_EXTRACT_TIMESTAMP  true
        GIT_REPOSITORY              https://github.com/STMicroelectronics/${STM32CubeXX}
        GIT_TAG                     v${GITHUB_BRANCH_${libName}}
        GIT_SHALLOW                 true
    )
    FetchContent_GetProperties (${libName})
    if (NOT ${libName}_POPULATED)
        FetchContent_MakeAvailable (${libName})
    endif ()

    configure_file (${CMAKE_CURRENT_LIST_DIR}/${libName}.config.cmake ${${libName}_SOURCE_DIR}/${libName}Config.cmake COPYONLY)
    configure_file (${CMAKE_CURRENT_LIST_DIR}/${libName}.CMakeLists.cmake ${${libName}_SOURCE_DIR}/CMakeLists.txt COPYONLY)

    add_subdirectory (${${libName}_SOURCE_DIR})
    # cmake_print_variables (libName LOWERCASE_STM32_TYPE)
endif ()
