# determine a cmsis version based on already supplied by the framework/cmsis_v6 or framework/cmsis_v5
# if none is give, use the local cmsis supplied by the stm32cubexx

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
include(CMakePrintHelpers)

if((DEFINED cmsis_v5_CORE_INCLUDE_PATH) AND
   (DEFINED cmsis_v5_DEVICE_INCLUDE_PATH))
    set(cmsis_CORE_INCLUDE_PATH ${cmsis_v5_CORE_INCLUDE_PATH})
    set(cmsis_DEVICE_INCLUDE_PATH ${cmsis_v5_DEVICE_INCLUDE_PATH})
    set(cmsis "cmsis_v5")
    message(STATUS "${libName}: CMSIS v5 is found")
elseif((DEFINED cmsis_v6_CORE_INCLUDE_PATH) AND
        (DEFINED cmsis_v6_DEVICE_INCLUDE_PATH))
    set(cmsis_CORE_INCLUDE_PATH ${cmsis_v6_CORE_INCLUDE_PATH})
    set(cmsis_DEVICE_INCLUDE_PATH ${cmsis_v6_DEVICE_INCLUDE_PATH})
    set(cmsis "cmsis_v6")
    message(STATUS "${libName}: CMSIS v6 is found")
else()
    message(FATAL_ERROR "No Valid cmsis found")
endif()
