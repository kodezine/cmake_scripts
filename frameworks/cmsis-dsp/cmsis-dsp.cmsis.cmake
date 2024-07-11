# determine a cmsis version based on already supplied by the framework/cmsis_v6 or framework/cmsis_v5
# if none is give, use the local cmsis supplied by the stm32cubexx

include (GNUInstallDirs)
include (CMakePackageConfigHelpers)
include (CMakePrintHelpers)

if ((DEFINED cmsis_v5_CORE_INCLUDE_PATH) AND
   (DEFINED cmsis_v5_DEVICE_INCLUDE_PATH))
    set (CMSISCORE ${cmsis_v5_CORE_PATH} CACHE STRING "Place to find the cmsis core folder for cmsis-dsp" FORCE)
    set (cmsis "cmsis_v5")
    message (STATUS "${libName}: ${cmsis} is found at ${CMSISCORE}")
elseif ((DEFINED cmsis_v6_CORE_INCLUDE_PATH) AND
        (DEFINED cmsis_v6_DEVICE_INCLUDE_PATH))
    set (CMSISCORE ${cmsis_v6_CORE_PATH} CACHE STRING "Place to find the cmsis core folder for cmsis-dsp" FORCE)
    set (cmsis "cmsis_v6")
    message (STATUS "${libName}: ${cmsis} is found at ${CMSISCORE}")
else ()
    set (cmsis_CORE_INCLUDE_PATH "")
    set (cmsis_DEVICE_INCLUDE_PATH "")
    set (cmsis "")
    message (FATAL_ERROR "${libName}: cmsis should be defined")
endif ()
