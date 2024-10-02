include (CMakePrintHelpers)
include (FetchContent)

### Determine if valid definitions exist for build from sources
#1# overarching HAL and CMSIS driver repo fetching mechanism for STM32 microcontrollers
if (NOT DEFINED ENV{CORTEX_TYPE})
    message (FATAL_ERROR "${libName}: needs a cortex type defined")
endif ()

#2# the variable value should be always upper case
string (TOUPPER ${STM32_TYPE} UPPERCASE_STM32_TYPE)
string (TOLOWER ${STM32_TYPE} LOWERCASE_STM32_TYPE)

#3# the library is made as stm32cubef0 for STM32_TYPE as "f0"
set (libName "stm32cube${LOWERCASE_STM32_TYPE}")

#4# include list of all supported STM32 Devices, checks if the valid device is defined
include (${CMAKE_CURRENT_LIST_DIR}/stm32cubexx.devices.cmake)
#5# include list of all supported STM32 Types, lower case STM32_TYPE from STM32_DEVICE
include (${CMAKE_CURRENT_LIST_DIR}/stm32cubexx.types.cmake)
#6# include the selection of cmsis used for this build
include (${CMAKE_CURRENT_LIST_DIR}/stm32cubexx.cmsis.cmake)

if (NOT DEFINED GITHUB_BRANCH_${libName})
    set (GITHUB_BRANCH_${libName} "1.11.5")
endif ()

message (STATUS "${libName}: ${GITHUB_BRANCH_${libName}}")
# precompilation
if (DEFINED PRECOMPILED_TAG_${libName})
    include (${CMAKE_CURRENT_LIST_DIR}/stm32cubexx.precompiled.cmake)
else ()

    #5# use the device family to set a cache variable for ARM Cortex Mx family here
    # set string to represent one of the above patterns
    string (TOUPPER $ENV{CORTEX_TYPE} CORTEX_TYPE_UPPERCASE)
    # CM4F is within CM4 so rename this type
    if (CORTEX_TYPE_UPPERCASE STREQUAL "CM4F")
        set (CORTEX_TYPE_UPPERCASE "CM4")
    endif ()
    # Add ARM prefix
    set (SYSTEM_CORTEX_TYPE_STRING "ARM${CORTEX_TYPE_UPPERCASE}")
    set (CMSIS_SYSTEM_TYPE "${SYSTEM_CORTEX_TYPE_STRING}" CACHE STRING "CMSIS Arm Cortex Device type to match folder" FORCE)

    #6# set the cubemx variable for a particular stm32 type
    set (STM32CubeXX STM32Cube${UPPERCASE_STM32_TYPE} CACHE STRING "CUBEMx String for controller family")

    FetchContent_Declare (
        ${libName}                  # Recommendation: Stick close to the original name.
        DOWNLOAD_EXTRACT_TIMESTAMP  true
        GIT_REPOSITORY              https://github.com/STMicroelectronics/${STM32CubeXX}.git
        GIT_TAG                     v${GITHUB_BRANCH_${libName}}
        GIT_SHALLOW                 true
        GIT_PROGRESS                true # show progress of download
        USES_TERMINAL_DOWNLOAD      true # show progress in ninja generator
      
    )

    FetchContent_MakeAvailable (${libName})

endif ()
