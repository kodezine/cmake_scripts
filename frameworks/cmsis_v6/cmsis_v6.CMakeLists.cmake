if (NOT DEFINED ${libName})
    set(libName cmsis_v6)
    # Minimum version for cmake compatiblity
    cmake_minimum_required(VERSION 3.29)
    include(CMakePrintHelpers)
    include(FetchContent)

    # Set branch names for the sub modules dependencies
    set(GITHUB_BRANCH_TOOLCHAIN "HEAD" CACHE STRING "git SHA for CMake Toolchain")
    # set the location of all fetched repos
    set(FETCHCONTENT_BASE_DIR "${CMAKE_SOURCE_DIR}/_deps")
    # show limited messages while cloning git repos
    set(FETCHCONTENT_QUIET ON)

    cmake_print_variables(GITHUB_BRANCH_TOOLCHAIN)
    FetchContent_Declare(
        cmake_scripts                             # Recommendation: Stick close to the original name.
        GIT_REPOSITORY  git@github.com:kodezine/cmake_scripts.git
        GIT_TAG         ${GITHUB_BRANCH_TOOLCHAIN}
    )

    # pre-fetch the toolchain repository as the first job before project configuration
    FetchContent_GetProperties(cmake_scripts)

    if(NOT cmake_scripts_POPULATED)
        FetchContent_Populate(cmake_scripts)
    endif()
endif ()

if (NOT DEFINED ${GITHUB_BRANCH_${libName}})
    set(GITHUB_BRANCH_${libName} "6.1.0")
endif ()

project(${libName}
    VERSION ${GITHUB_BRANCH_${libName}}
    LANGUAGES C
    DESCRIPTION "Header only library for CMSIS V6"
)

# Main target ------------------------------------------------------------------
add_library(${PROJECT_NAME} INTERFACE)
add_library(${PROJECT_NAME}::framework ALIAS ${PROJECT_NAME})

# Includes ---------------------------------------------------------------------
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# set public headers as a globbed function
file(GLOB ${libName}_Device_Headers ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Core/Include/m-profile/*.h)
file(GLOB ${libName}_Core_Headers ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Core/Include/*.h)
set(${libName}_PUBLIC_HEADERS ${${libName}_Device_Headers} ${${libName}_Core_Headers})

target_include_directories(${PROJECT_NAME}
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Core/Include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Core/Include/m-profile>
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

write_basic_package_version_file(${PROJECT_NAME}ConfigVersion.cmake
    VERSION         ${PROJECT_VERSION}
    COMPATIBILITY   SameMajorVersion
)

## Target's cmake files: targets export
install(TARGETS ${PROJECT_NAME}
    EXPORT      ${PROJECT_NAME}Targets
    DESTINATION     ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

## Target's cmake files: config and version config for find_package()
install(FILES       ${PROJECT_NAME}Config.cmake
                    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION     ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
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
