if (NOT DEFINED ${libName})
    set(libName cmsis_v5)
endif ()

project (${libName}
    VERSION ${GITHUB_BRANCH_${libName}}
    LANGUAGES C
    DESCRIPTION "Header only library for CMSIS V5"
)

# Main target ------------------------------------------------------------------
add_library (${libName} INTERFACE)
add_library (${libName}::framework ALIAS ${libName})
# Sub target -------------------------------------------------------------------
# Static library for generic device objects
set (GenericName "${libName}_generic")
add_library (${GenericName} STATIC)
# Includes ---------------------------------------------------------------------
include (GNUInstallDirs)
include (CMakePackageConfigHelpers)

# set public headers as a globbed function
file (GLOB ${libName}_Device_Headers ${CMAKE_CURRENT_SOURCE_DIR}/Device/ARM/ARM$ENV{CORTEX_TYPE}/Include/*.h)
file (GLOB ${libName}_Core_Headers ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Core/Include/*.h)
set (${libName}_PUBLIC_HEADERS
    ${${libName}_Device_Headers}
    ${${libName}_Core_Headers}
)

target_include_directories (${libName}
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Core/Include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Device/ARM/ARM$ENV{CORTEX_TYPE}/Include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${libName}>
)

set_target_properties (${libName}
    PROPERTIES
        C_STANDARD          11
        C_STANDARD_REQUIRED ON
        C_EXTENSIONS        OFF
        PUBLIC_HEADER       "${${libName}_PUBLIC_HEADERS}"
        EXPORT_NAME         framework
)

target_compile_options (${libName}
    INTERFACE
        $<$<C_COMPILER_ID:Clang>:-Wcast-align
                                 -Wcast-qual
                                 -Wconversion
                                 -Wexit-time-destructors
                                 -Wglobal-constructors
                                 #-Wmissing-noreturn
                                 -Wmissing-prototypes
                                 -Wno-missing-braces
                                 -Wold-style-cast
                                 -Wshadow
                                 -Wweak-vtables
                                 #-Werror
                                 -Wall>
        $<$<C_COMPILER_ID:GNU>:-Waddress
                               -Waggregate-return
                               -Wformat-nonliteral
                               -Wformat-security
                               -Wformat
                               -Winit-self
                               -Wmissing-declarations
                               -Wmissing-include-dirs
                               -Wno-multichar
                               -Wno-parentheses
                               -Wno-type-limits
                               -Wno-unused-parameter
                               -Wunreachable-code
                               -Wwrite-strings
                               -Wpointer-arith
                               #-Werror
                               -Wall>
       $<$<C_COMPILER_ID:MSVC>:/Wall>
)
## Sub project ---------------------------------------------------------------

target_sources (${GenericName}
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/Device/ARM/ARM$ENV{CORTEX_TYPE}/Source/system_ARM$ENV{CORTEX_TYPE}.c
)

# define the generic definition based on architecture --------------------------
if (($ENV{CORTEX_TYPE} STREQUAL "CM7"))
    set (ARMCMFTYPE "ARM$ENV{CORTEX_TYPE}_DP")
elseif (($ENV{CORTEX_TYPE} STREQUAL "CM4F"))
    set (ARMCMFTYPE "ARM$ENV{CORTEX_TYPE}_SP")
else ()
    set (ARMCMFTYPE "ARM$ENV{CORTEX_TYPE}")
endif ()

message (STATUS "${libName}: ${ARMCMFTYPE}")

target_compile_definitions (${GenericName}
    PUBLIC
    ${ARMCMFTYPE} # defines the single, double or no floating point support
)

target_link_libraries(${GenericName}
    ${libName}
)

setTargetCompileOptions(GenericName)
## ---------------------------------------------------------------------------

write_basic_package_version_file(${libName}ConfigVersion.cmake
    VERSION         ${PROJECT_VERSION}
    COMPATIBILITY   SameMajorVersion
)

## Target installation
install(TARGETS     ${libName} ${GenericName}
    EXPORT          ${libName}Targets
    ARCHIVE         DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY         DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER   DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${libName}
    COMPONENT       library
)

## Target's cmake files: targets export
install(EXPORT      ${libName}Targets
    NAMESPACE       ${libName}::
    DESTINATION     ${CMAKE_INSTALL_LIBDIR}/cmake/${libName}
)

## Target's cmake files: config and version config for find_package()
install(FILES       ${libName}Config.cmake
                    ${CMAKE_CURRENT_BINARY_DIR}/${libName}ConfigVersion.cmake
    DESTINATION     ${CMAKE_INSTALL_LIBDIR}/cmake/${libName}
)

# This will set the CPACK tar file as
# cmsis_v5-<cmsisVersion>-<cortexType>-<compiler>-<compilerVersion>.tar.gz
set(CPACK_PACKAGE_CHECKSUM SHA3_256)
set(CPACK_SYSTEM_NAME "$ENV{CORTEX_TYPE}-${CMAKE_C_COMPILER_ID}-${CMAKE_C_COMPILER_VERSION}")
set(CPACK_BINARY_TGZ "ON")
set(CPACK_BINARY_ZIP "OFF")
set(CPACK_BINARY_ZIP "OFF")
set(CPACK_BINARY_NSIS "OFF")
set(CPACK_SOURCE_IGNORE_FILES
  \\.git/
  build/
  ".*~$"
)
set(CPACK_VERBATIM_VARIABLES YES)
include(CPack)
