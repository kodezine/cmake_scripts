
project(cmock
    VERSION 2.5.3
    LANGUAGES C
    DESCRIPTION "C mocking framework."
)
add_library(cmock STATIC)
add_library(cmock::framework ALIAS cmock)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# Makes the mock
target_sources(cmock
    PRIVATE
        ${cmock_SOURCE_DIR}/src/cmock.c
)

target_include_directories(cmock
    PUBLIC
    ${cmock_SOURCE_DIR}/src
)

set(cmock_PUBLIC_HEADERS
    src/cmock.h
    src/cmock_internals.h
)

set_target_properties(cmock
    PROPERTIES
        C_STANDARD 11
        C_STANDARD_REQUIRED ON
        C_EXTENSIONS OFF
        PUBLIC_HEADER "${cmock_PUBLIC_HEADERS}"
        EXPORT_NAME framework
)

target_link_libraries(cmock
    PUBLIC
        unity
)


target_compile_options(cmock
    PRIVATE
        $<$<C_COMPILER_ID:Clang>:# -Wcast-align only for CortexM targets
                                 -Wcast-qual
                                 -Wconversion
                                 -Wexit-time-destructors
                                 -Wglobal-constructors
                                 -Wmissing-noreturn
                                 -Wmissing-prototypes
                                 -Wno-missing-braces
                                 -Wold-style-cast
                                 -Wshadow
                                 -Wweak-vtables
                                 -Werror
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
                               -Werror
                               -Wall>
       $<$<C_COMPILER_ID:MSVC>:/Wall>
)

write_basic_package_version_file(cmockConfigVersion.cmake
    VERSION       ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)
