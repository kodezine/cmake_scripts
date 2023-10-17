
if (${PROJECT_NAME} STREQUAL ${libName})

else ()
    project(${libName}
        VERSION ${GITHUB_BRANCH_${libName}}
        LANGUAGES C
        DESCRIPTION "Header only library for CMSIS V5"
    )
endif ()

# Main target ------------------------------------------------------------------
add_library(${PROJECT_NAME} INTERFACE)
add_library(${PROJECT_NAME}::framework ALIAS ${PROJECT_NAME})
# Sub target -------------------------------------------------------------------
# Static library for generic device objects
set(GenericName "${PROJECT_NAME}_generic")
add_library(${GenericName} STATIC)
# Includes ---------------------------------------------------------------------
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# set public headers as a globbed function
file(GLOB ${PROJECT_NAME}_Device_Headers ${CMAKE_CURRENT_SOURCE_DIR}/Device/ARM/ARM$ENV{CORTEX_TYPE}/Include/*.h)
file(GLOB ${PROJECT_NAME}_Core_Headers ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Core/Include/*.h)
set(${PROJECT_NAME}_PUBLIC_HEADERS ${${PROJECT_NAME}_Device_Headers} ${${PROJECT_NAME}_Core_Headers})

target_include_directories(${PROJECT_NAME}
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Core/Include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Device/ARM/ARM$ENV{CORTEX_TYPE}/Include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}>
)


set_target_properties(${PROJECT_NAME}
    PROPERTIES
        C_STANDARD          11
        C_STANDARD_REQUIRED ON
        C_EXTENSIONS        OFF
        PUBLIC_HEADER       "${${PROJECT_NAME}_PUBLIC_HEADERS}"
        EXPORT_NAME         framework
)

target_compile_options(${PROJECT_NAME}
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

target_sources(${GenericName}
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/Device/ARM/ARM$ENV{CORTEX_TYPE}/Source/system_ARM$ENV{CORTEX_TYPE}.c
)

target_compile_definitions(${GenericName}
    PUBLIC
    ARM$ENV{CORTEX_TYPE}_DP
)

target_link_libraries(${GenericName}
    ${PROJECT_NAME}
)

setTargetCompileOptions(GenericName)
## ---------------------------------------------------------------------------

write_basic_package_version_file(${PROJECT_NAME}ConfigVersion.cmake
    VERSION         ${PROJECT_VERSION}
    COMPATIBILITY   SameMajorVersion
)

## Target installation
install(TARGETS     ${PROJECT_NAME} ${GenericName}
    EXPORT          ${PROJECT_NAME}Targets
    ARCHIVE         DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY         DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER   DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
    COMPONENT       library
)

## Target's cmake files: targets export
install(EXPORT      ${PROJECT_NAME}Targets
    NAMESPACE       ${PROJECT_NAME}::
    DESTINATION     ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

## Target's cmake files: config and version config for find_package()
install(FILES       ${PROJECT_NAME}Config.cmake
                    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION     ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

# This will set the CPACK tar file as
# cmsis-v5-<cmsisVersion>-<cortexType>-<compiler>-<compilerVersion>.tar.gz
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
