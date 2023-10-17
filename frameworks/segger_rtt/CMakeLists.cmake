# Minimum version for cmake compatiblity
cmake_minimum_required(VERSION 3.25)
include(CMakePrintHelpers)
include(FetchContent)

project(
    segger_rtt
    VERSION     0.0.1
    LANGUAGES   C ASM CXX
    DESCRIPTION "Segger RTT based target debug output and input library"
)
# Extract information for segger_rtt framework
if(CMAKE_C_COMPILER_ID STREQUAL "ARMClang"  OR CMAKE_C_COMPILER_ID STREQUAL "Clang")
    set(SYSCALL_COMPILER_ID "KEIL")
elseif(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    set(SYSCALL_COMPILER_ID "GCC")
else()
    message(FATAL_ERROR "segger-rtt can not be integrated with this compiler...yet")
endif()

# Main target ------------------------------------------------------------------
add_library(${PROJECT_NAME} STATIC)
add_library(${PROJECT_NAME}::framework ALIAS ${PROJECT_NAME})


# Includes ---------------------------------------------------------------------
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(segger_rtt_SOURCES
    #${segger_rtt_SOURCE_DIR}/RTT/SEGGER_RTT_ASM_ARMv7M.S
    ${segger_rtt_SOURCE_DIR}/RTT/SEGGER_RTT_printf.c
    ${segger_rtt_SOURCE_DIR}/RTT/SEGGER_RTT.c

    ${segger_rtt_SOURCE_DIR}/Syscalls/SEGGER_RTT_Syscalls_${SYSCALL_COMPILER_ID}.c
)

target_sources(${PROJECT_NAME}
    PRIVATE
    ${segger_rtt_SOURCES}
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Config>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/RTT>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}>
)

set(${PROJECT_NAME}_PUBLIC_HEADERS
        RTT/SEGGER_RTT.h
        Config/SEGGER_RTT_Conf.h
)

# Add target compile options based on toolchain
set(libName ${PROJECT_NAME})
setTargetCompileOptions(libName)


write_basic_package_version_file(${PROJECT_NAME}ConfigVersion.cmake
    VERSION       ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

## Target installation
install(TARGETS   ${PROJECT_NAME}
    EXPORT        ${PROJECT_NAME}Targets
    ARCHIVE       DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY       DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
    COMPONENT     library
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
