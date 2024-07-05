if (${PROJECT_NAME} STREQUAL cubemx)

else ()
    cmake_minimum_required(VERSION 3.27)

    project(
        cubemx
        VERSION ${GITHUB_BRANCH_cubemx}
        LANGUAGES   C ASM CXX
        DESCRIPTION "Hardware Abstraction Layer for ${STM32_DEVICE}"
    )
endif ()

if ((DEFINED cmsis_v5_CORE_INCLUDE_PATH) AND
    (DEFINED cmsis_v5_DEVICE_INCLUDE_PATH))
    set (cmsis_CORE_INCLUDE_PATH ${cmsis_v5_CORE_INCLUDE_PATH})
    set (cmsis_DEVICE_INCLUDE_PATH ${cmsis_v5_DEVICE_INCLUDE_PATH})
    set (cmsis "cmsis_v5")
    message(STATUS "${PROJECT_NAME}: CMSIS v5 is found")
else ((DEFINED cmsis_v6_CORE_INCLUDE_PATH) AND
    (DEFINED cmsis_v6_DEVICE_INCLUDE_PATH))
    set (cmsis_CORE_INCLUDE_PATH ${cmsis_v6_CORE_INCLUDE_PATH})
    set (cmsis_DEVICE_INCLUDE_PATH ${cmsis_v6_DEVICE_INCLUDE_PATH})
    set (cmsis "cmsis_v6")
    message(STATUS "${PROJECT_NAME}: CMSIS v6 is found")
endif ()

# Check for valid paths to Cube Drivers used in this file
if ((NOT EXISTS ${st_CMSIS_DIR}) OR
    (NOT EXISTS ${st_HAL_Driver_DIR}))
    message(FATAL_ERROR "${PROJECT_NAME}: Can only compile if the STM32CubeXX is cloned from STMicroelectronics GitHub")
endif()

# the configuration of hal should be available in all cases
# if it is not provided, we use ALL the available drivers in the default configuration
if(NOT DEFINED STM32_HAL_CONFIGURATION)
    message(STATUS "${PROJECT_NAME}: Will use all available HAL layer artefacts")
    configure_file(${st_HAL_Driver_DIR}/Inc/stm32${LOWERCASE_STM32_TYPE}xx_hal_conf_template.h ${st_HAL_Driver_DIR}/Inc/stm32${LOWERCASE_STM32_TYPE}xx_hal_conf.h COPYONLY)
else()
    message(STATUS "${PROJECT_NAME}: Will use ${STM32_HAL_CONFIGURATION}")
    configure_file(${STM32_HAL_CONFIGURATION} ${st_HAL_Driver_DIR}/Inc/stm32${LOWERCASE_STM32_TYPE}xx_hal_conf.h COPYONLY)
endif()

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
include(CMakePrintHelpers)

add_library(${PROJECT_NAME} STATIC)
add_library(${PROJECT_NAME}::framework ALIAS ${PROJECT_NAME})

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

set(${PROJECT_NAME}_PUBLIC_HEADERS ${AllHeaders})

target_sources(${PROJECT_NAME}
    PRIVATE
    ${st_HAL_DRV_SOURCES}
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${cmsis_CORE_INCLUDE_PATH}>
        $<BUILD_INTERFACE:${cmsis_DEVICE_INCLUDE_PATH}>
        $<BUILD_INTERFACE:${st_HAL_DRV_INCLUDE_DIR}>
        $<BUILD_INTERFACE:${st_HAL_DRV_INCLUDE_LEGACY_DIR}>
        $<BUILD_INTERFACE:${st_CMSIS_DEVICE_INCLUDE_DIR}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}>
)

target_compile_definitions(${PROJECT_NAME}
    PUBLIC
        USE_HAL_DRIVER
        USE_FULL_LL_DRIVER
        ${STM32_DEVICE}
)

set_target_properties(${PROJECT_NAME}
    PROPERTIES
        C_STANDARD          11
        C_STANDARD_REQUIRED ON
        C_EXTENSIONS        OFF
        PUBLIC_HEADER       "${${PROJECT_NAME}_PUBLIC_HEADERS}"
        EXPORT_NAME         framework
)

target_link_libraries(${PROJECT_NAME}
    INTERFACE
    ${cmsis}
)

# set the target compile options
setTargetCompileOptions(PROJECT_NAME)

# Package begins
write_basic_package_version_file(${PROJECT_NAME}ConfigVersion.cmake
    VERSION       ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

## Package, Target installation
install(TARGETS     ${PROJECT_NAME}
    EXPORT          ${PROJECT_NAME}Targets
    ARCHIVE         DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY         DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME         DESTINATION ${CMAKE_INSTALL_BINDIR}
    PUBLIC_HEADER   DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
    COMPONENT       library
)

## Target's cmake files: targets export
install(EXPORT  ${PROJECT_NAME}Targets
    NAMESPACE   ${PROJECT_NAME}::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

## Target's cmake files: config and version config for find_package()
install(FILES   ${PROJECT_NAME}Config.cmake
            ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)
