# determine a cmsis version based on already supplied by the framework/cmsis_v6 or framework/cmsis_v5
# if none is give, use the local cmsis supplied by the stm32cubexx

include (GNUInstallDirs)
include (CMakePackageConfigHelpers)
include (CMakePrintHelpers)

if ((DEFINED cmsis_v5_CORE_INCLUDE_PATH) AND
   (DEFINED cmsis_v5_DEVICE_INCLUDE_PATH))
    #set (cmsis_CORE_INCLUDE_PATH    ${cmsis_v5_CORE_INCLUDE_PATH})
    #set (cmsis_DEVICE_INCLUDE_PATH  ${cmsis_v5_DEVICE_INCLUDE_PATH})
    #string (REPLACE ${cmsis_v5_CORE_INCLUDE_PATH} "Include" "" CMSISCORE)
    set (cmsis "cmsis_v5")
    message (STATUS "${libName}: ${cmsis} is found at ${cmsis_v5_CORE_INCLUDE_PATH}")
elseif ((DEFINED cmsis_v6_CORE_INCLUDE_PATH) AND
        (DEFINED cmsis_v6_DEVICE_INCLUDE_PATH))
    #set (cmsis_CORE_INCLUDE_PATH    ${cmsis_v6_CORE_INCLUDE_PATH})
    #set (cmsis_DEVICE_INCLUDE_PATH  ${cmsis_v6_DEVICE_INCLUDE_PATH})
    string (STRIP cmsis_v5_CORE_INCLUDE_PATH CMSISCORE)
    set (cmsis "cmsis_v6")
    message (STATUS "${libName}: ${cmsis} is found at ${CMSISCORE}")
else ()
    set (cmsis_CORE_INCLUDE_PATH "")
    set (cmsis_DEVICE_INCLUDE_PATH "")
    set (cmsis "")
    message (FATAL_ERROR "${libName}: cmsis should be defined")
endif ()
