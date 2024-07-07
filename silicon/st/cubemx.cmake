include(CMakePrintHelpers)
include(FetchContent)

set(libName "cubemx")

# include list of all supported STM32 Types
include(${CMAKE_CURRENT_LIST_DIR}/stm32types.cmake)
# include list of all supported STM32 Devices
include(${CMAKE_CURRENT_LIST_DIR}/stm32devices.cmake)
# include the selection of cmsis used for this build
include(${CMAKE_CURRENT_LIST_DIR}/cubemx.cmsis.cmake)

if(NOT DEFINED GITHUB_BRANCH_${libName})
    set(GITHUB_BRANCH_${libName} "1.11.5")
endif()

message(STATUS "${libName}: ${GITHUB_BRANCH_${libName}}")
# precompilation
if(DEFINED PRECOMPILED_TAG_${libName})
    include(${CMAKE_CURRENT_LIST_DIR}/cubemx.precompiled.cmake)
else()
    message(STATUS "${libName}: Compiles from source and ${cmsis}")
    ### Determine if valid definitions exist for build from sources
    #1# overarching HAL and CMSIS driver repo fetching mechanism for STM32 microcontrollers
    if((NOT DEFINED STM32_TYPE) OR
        (NOT DEFINED STM32_DEVICE) OR
        (NOT DEFINED ENV{CORTEX_TYPE}))
        message(FATAL_ERROR "${libName}: Needs a valid STM32 Family type and device defined to work with.")
    endif()

    #2# the variable value should be always upper case
    string (TOUPPER ${STM32_TYPE} UPPERCASE_STM32_TYPE)
    string (TOLOWER ${STM32_TYPE} LOWERCASE_STM32_TYPE)

    #3# the stm32_type should be one from supported values
    if(NOT (${UPPERCASE_STM32_TYPE} IN_LIST LIST_SUPPORTED_STM32_TYPES))
        message(FATAL_ERROR "${libName}: Does not support the provided STM32_TYPE: ${STM32_TYPE}")
    endif()

    #4# determine a supported stm32 device
    if(NOT (${STM32_DEVICE} IN_LIST LIST_SUPPORTED_STM32_DEVICE))
        message(FATAL_ERROR "${libName}: Does not support the provided STM32_DEVICE: ${STM32_DEVICE}")
    endif()

    #5# use the device family to set a cache variable for ARM Cortex Mx family here
    set(ARMCMSIS_DEVICE "ARM$ENV{CORTEX_TYPE}" CACHE STRING "CMSIS Arm Cortex Device type to match folder" FORCE)

    #6# set the cubemx variable for a particular stm32 type
    set(STM32CubeXX STM32Cube${UPPERCASE_STM32_TYPE} CACHE STRING "CUBEMx String for controller family")

    FetchContent_Declare(
        ${libName}${LOWERCASE_STM32_TYPE}                              # Recommendation: Stick close to the original name.
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        GIT_REPOSITORY  https://github.com/STMicroelectronics/${STM32CubeXX}
        GIT_TAG         v${GITHUB_BRANCH_${libName}}
        GIT_SHALLOW     TRUE
    )
    cmake_print_variables(libName LOWERCASE_STM32_TYPE)
    FetchContent_GetProperties(${libName}${LOWERCASE_STM32_TYPE})
    if(NOT ${libName}${LOWERCASE_STM32_TYPE}_POPULATED)
        FetchContent_MakeAvailable(${libName}${LOWERCASE_STM32_TYPE})
    endif()

    configure_file(${CMAKE_CURRENT_LIST_DIR}/${libName}Config.cmake ${${libName}${LOWERCASE_STM32_TYPE}_SOURCE_DIR}/${libName}Config.cmake COPYONLY)
    configure_file(${CMAKE_CURRENT_LIST_DIR}/${libName}.CMakeLists.cmake ${${libName}${LOWERCASE_STM32_TYPE}_SOURCE_DIR}/CMakeLists.txt COPYONLY)
    set(st_CMSIS_DIR "${${libName}${LOWERCASE_STM32_TYPE}_SOURCE_DIR}/Drivers/CMSIS" CACHE PATH "Path to STM32CubeXX CMSIS folder")
    set(st_HAL_Driver_DIR "${${libName}${LOWERCASE_STM32_TYPE}_SOURCE_DIR}/Drivers/STM32${UPPERCASE_STM32_TYPE}xx_HAL_Driver" CACHE PATH "Path to STM32CubeXX Drivers folder")
    set(stm32_hal stm32${LOWERCASE_STM32_TYPE}xx_hal CACHE STRING "Prefix for HAL files")
    # cmake_print_variables(stm32_hal st_CMSIS_DIR st_HAL_Driver_DIR)
    add_subdirectory(${${libName}${LOWERCASE_STM32_TYPE}_SOURCE_DIR})
endif()
