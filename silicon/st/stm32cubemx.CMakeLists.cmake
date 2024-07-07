
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
include(CMakePrintHelpers)

if (NOT DEFINED ${libName})
    set(libName stm32cubemx)
endif ()

project(${libName}
    VERSION ${GITHUB_BRANCH_${libName}}
    LANGUAGES C
    DESCRIPTION "STM32CubeMx library for devices"
)

add_library(${libName} STATIC)
add_library(${libName}::framework ALIAS ${libName})

# the configuration of hal should be available in all cases
# if it is not provided, we use ALL the available drivers in the default configuration
if (EXISTS STM32CubeMxConfigHeaderFile)
    message (STATUS "${libName}: Will use ${STM32CubeMxConfigHeaderFile}")
    configure_file (${STM32CubeMxConfigHeaderFile} ${${libName}_SOURCE_DIR}/Drivers/STM32${UPPERCASE_STM32_TYPE}xx_HAL_Driver/Inc/stm32${LOWERCASE_STM32_TYPE}xx_hal_conf.h COPYONLY)
else ()
    message (STATUS "${libName}: Will use all available HAL layer artefacts")
    configure_file (${${libName}_SOURCE_DIR}/Drivers/STM32${UPPERCASE_STM32_TYPE}xx_HAL_Driver/Inc/stm32${LOWERCASE_STM32_TYPE}xx_hal_conf_template.h ${${libName}_SOURCE_DIR}/Drivers/STM32${UPPERCASE_STM32_TYPE}xx_HAL_Driver/Inc/stm32${LOWERCASE_STM32_TYPE}xx_hal_conf.h COPYONLY)
endif ()

set (st_CMSIS_DIR ${${libName}_SOURCE_DIR}/Drivers/CMSIS CACHE PATH "Path to STM32CubeXX CMSIS folder" FORCE)
set (st_HAL_Driver_DIR ${${libName}_SOURCE_DIR}/Drivers/STM32${UPPERCASE_STM32_TYPE}xx_HAL_Driver CACHE PATH "Path to STM32CubeXX Drivers folder" FORCE)
set (stm32_hal stm32${LOWERCASE_STM32_TYPE}xx_hal CACHE STRING "Prefix for HAL files")
cmake_print_variables (st_CMSIS_DIR st_HAL_Driver_DIR)
if (DEFINED cmsis)
else ()
    set (cmsis_CORE_INCLUDE_PATH "${st_CMSIS_DIR}/Core/Include" CACHE PATH "Path to STM32CubeXX CMSIS Core Includes")
    set (cmsis_DEVICE_INCLUDE_PATH "${st_CMSIS_DIR}/Device/Include" CACHE PATH "Path to STM32CubeXX CMSIS Device Includes")
endif ()
cmake_print_variables(cmsis_CORE_INCLUDE_PATH)
message (STATUS "${libName}: compiles from source and ${cmsis_CORE_INCLUDE_PATH}")

# Get the STM32 HAL and CMSIS drivers from STM GitHub pages
set(st_CMSIS_DEVICE_INCLUDE_DIR "${st_CMSIS_DIR}/Device/ST/STM32${UPPERCASE_STM32_TYPE}xx/Include")
set(st_HAL_DRV_INCLUDE_DIR "${st_HAL_Driver_DIR}/Inc")
set(st_HAL_DRV_INCLUDE_LEGACY_DIR "${st_HAL_DRV_INCLUDE_DIR}/Legacy")
set(st_HAL_DRV_SOURCE_DIR "${st_HAL_Driver_DIR}/Src")
# USE OF GLOB TO MAKE IT USEFUL FOR FUTURE
file(GLOB st_HAL_DRV_SOURCES ${st_HAL_DRV_SOURCE_DIR}/*.c)
# exclude all templates from the library
list(FILTER st_HAL_DRV_SOURCES EXCLUDE REGEX "template")

# glob legacy headers
file(GLOB STLegacyHeaders ${st_HAL_DRV_INCLUDE_LEGACY_DIR}/*.h)
# glob device header files
file(GLOB STDeviceHeaders ${st_CMSIS_DEVICE_INCLUDE_DIR}/*.h)
# glob all hal and ll headers
file(GLOB HALAndLLHeaders ${st_HAL_DRV_INCLUDE_DIR}/*.h)

set(AllHeaders
    ${STLegacyHeaders}
    ${STDeviceHeaders}
    ${HALAndLLHeaders}
)

list(FILTER AllHeaders EXCLUDE REGEX "template")

set(${libName}_PUBLIC_HEADERS ${AllHeaders})

target_sources(${libName}
    PRIVATE
    ${st_HAL_DRV_SOURCES}
)

target_include_directories(${libName}
    PUBLIC
        $<BUILD_INTERFACE:${cmsis_CORE_INCLUDE_PATH}>
        $<BUILD_INTERFACE:${cmsis_DEVICE_INCLUDE_PATH}>
        $<BUILD_INTERFACE:${st_HAL_DRV_INCLUDE_DIR}>
        $<BUILD_INTERFACE:${st_HAL_DRV_INCLUDE_LEGACY_DIR}>
        $<BUILD_INTERFACE:${st_CMSIS_DEVICE_INCLUDE_DIR}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${libName}>
)

target_compile_definitions(${libName}
    PUBLIC
        USE_HAL_DRIVER
        # USE_FULL_LL_DRIVER
        ${STM32_DEVICE}
)

set_target_properties(${libName}
    PROPERTIES
        C_STANDARD          11
        C_STANDARD_REQUIRED ON
        C_EXTENSIONS        OFF
        PUBLIC_HEADER       "${${libName}_PUBLIC_HEADERS}"
        EXPORT_NAME         framework
)

target_link_libraries(${libName}
    ${cmsis}
)

# set the target compile options
setTargetCompileOptions(libName)

# Package begins
write_basic_package_version_file(${libName}ConfigVersion.cmake
    VERSION       ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

## Package, Target installation
install(TARGETS     ${libName}
    EXPORT          ${libName}Targets
    ARCHIVE         DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY         DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME         DESTINATION ${CMAKE_INSTALL_BINDIR}
    PUBLIC_HEADER   DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${libName}
    COMPONENT       library
)

## Target's cmake files: targets export
install(EXPORT  ${libName}Targets
    NAMESPACE   ${libName}::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${libName}
)

## Target's cmake files: config and version config for find_package()
install(FILES   ${libName}Config.cmake
            ${CMAKE_CURRENT_BINARY_DIR}/${libName}ConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${libName}
)
