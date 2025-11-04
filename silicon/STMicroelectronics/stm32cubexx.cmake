include (CMakePrintHelpers)

# the stm32cubexx library fetch and configuration script define your - STM32_TYPE as the type of stm32 device e.g. "f0",
# "f1", "f4", "l4", etc. - STM32_DEVICE as the exact device name e.g. "STM32F031x6", "STM32F103xB", "STM32F407xx",
# "STM32L476xx", etc. - CORTEX_TYPE as the cortex type e.g. "cm0", "cm3", "cm4", "cm7", etc. optionally define -
# GITHUB_BRANCH_stm32cubexx as the github tag to use with format "v1.11.5" - PRECOMPILED_TAG_stm32cubexx as the
# precompiled tag to use with format "v1.11.5" - PRECOMPILED_RESOURCE_stm32cubexx as the precompiled resource URL to use
# with SHA256 hash - PRE - cmsis_v5_CORE_INCLUDE_PATH and cmsis_v5_DEVICE_INCLUDE_PATH to use cmsis v5 from outside -
# cmsis_v6_CORE_INCLUDE_PATH and cmsis_v6_DEVICE_INCLUDE_PATH to use cmsis v6 from outside - STM32CubeMxConfigHeaderFile
# to provide a custom HAL configuration file

# 0 # Check for CPM package manager
if (COMMAND CPMAddPackage)
  message (STATUS "CPM: using CPM package manager")
else ()
  message (ERROR "CPM: not finding CPM, use older scripts or add CPM.cmake to your project")
endif ()

# 1 # overarching HAL and CMSIS driver repo fetching mechanism for STM32 microcontrollers
if (NOT DEFINED ENV{CORTEX_TYPE})
  message (FATAL_ERROR "${libName}: needs a cortex type defined")
endif ()

# 2 # Set the variable value should be always upper case
string (TOUPPER ${STM32_TYPE} UPPERCASE_STM32_TYPE)
string (TOLOWER ${STM32_TYPE} LOWERCASE_STM32_TYPE)

# 3 # the library is made as stm32cubef0 for STM32_TYPE as "f0"
set (libName "stm32cube${LOWERCASE_STM32_TYPE}")

# 4 # include list of all supported STM32 Devices, checks if the valid device is defined
include (${CMAKE_CURRENT_LIST_DIR}/stm32cubexx.devices.cmake)

# 5 # include list of all supported STM32 Types, lower case STM32_TYPE from STM32_DEVICE
include (${CMAKE_CURRENT_LIST_DIR}/stm32cubexx.types.cmake)

# 6 # include the selection of cmsis used for this build
include (${CMAKE_CURRENT_LIST_DIR}/stm32cubexx.cmsis.cmake)

# 7 # set the github branch to use for fetching the cubemx library from STMicroelectronics github
if (NOT DEFINED GITHUB_BRANCH_${libName})
  set (GITHUB_BRANCH_${libName} "v1.11.5")
endif ()
message (STATUS "${libName}: uses version ${GITHUB_BRANCH_${libName}} for fetching from github.com/STMicroelectronics")

# 8 # Check if a precompiled tag is defined, else fetch from github
if (DEFINED PRECOMPILED_TAG_${libName})
  include (${CMAKE_CURRENT_LIST_DIR}/stm32cubexx.precompiled.cmake)
else ()

  # 9 # set the cmsis system type based on the cortex type
  string (TOUPPER $ENV{CORTEX_TYPE} CORTEX_TYPE_UPPERCASE)

  # 10 # CM4F is within CM4 so rename this type
  if (CORTEX_TYPE_UPPERCASE STREQUAL "CM4F")
    set (CORTEX_TYPE_UPPERCASE "CM4")
  endif ()

  # 11 # set the system cortex type string and cmsis variable
  set (SYSTEM_CORTEX_TYPE_STRING "ARM${CORTEX_TYPE_UPPERCASE}")
  set (
    CMSIS_SYSTEM_TYPE
    "${SYSTEM_CORTEX_TYPE_STRING}"
    CACHE STRING "CMSIS Arm Cortex Device type to match folder" FORCE)

  # 12 # set the cubemx repository name based on the stm32 type
  set (
    STM32CubeXX
    STM32Cube${UPPERCASE_STM32_TYPE}
    CACHE STRING "CUBEMx String for controller family")
  message (STATUS "${libName}: fetching ${STM32CubeXX} from github.com/STMicroelectronics")
  cpmaddpackage (
    NAME
    ${libName}
    GITHUB_REPOSITORY
    https://github.com/STMicroelectronics/${STM32CubeXX}
    GIT_TAG
    ${GITHUB_BRANCH_${libName}}
    DOWNLOAD_ONLY
    TRUE)
  message (STATUS "${libName}: configuring and building from source")
  # 13 # strip the GITHUB_BRANCH_${libName} "v" for CMMakeLists Versioning
  string (REPLACE "v" "" ${libName}Version ${GITHUB_BRANCH_${libName}})
  # 14 # configure the CMakeLists and Config files into the source directory
  configure_file (${CMAKE_CURRENT_LIST_DIR}/stm32cubexx.config.cmake ${${libName}_SOURCE_DIR}/${libName}Config.cmake
                  COPYONLY)
  configure_file (${CMAKE_CURRENT_LIST_DIR}/stm32cubexx.CMakeLists.cmake ${${libName}_SOURCE_DIR}/CMakeLists.txt
                  COPYONLY)
  # 15 # add the subdirectory to build the library from source
  add_subdirectory (${${libName}_SOURCE_DIR} ${${libName}_BINARY_DIR})
endif ()
