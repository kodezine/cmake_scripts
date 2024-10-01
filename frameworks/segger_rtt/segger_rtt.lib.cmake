# Minimum version for cmake compatiblity
include(CMakePrintHelpers)
include(FetchContent)

set (libName segger_rtt)

# Extract information for segger_rtt framework
if(CMAKE_C_COMPILER_ID STREQUAL "ARMClang"  OR CMAKE_C_COMPILER_ID STREQUAL "Clang")
    set(SYSCALL_COMPILER_ID "KEIL")
elseif(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    set(SYSCALL_COMPILER_ID "GCC")
else()
    message(FATAL_ERROR "segger-rtt can not be integrated with this compiler...yet")
endif()

# Main target ------------------------------------------------------------------
add_library(${libName} STATIC)
add_library(${libName}::framework ALIAS ${libName})


# Includes ---------------------------------------------------------------------

set(${libName}_SOURCES
    #${${libName}_SOURCE_DIR}/RTT/SEGGER_RTT_ASM_ARMv7M.S
    ${${libName}_SOURCE_DIR}/RTT/SEGGER_RTT_printf.c
    ${${libName}_SOURCE_DIR}/RTT/SEGGER_RTT.c

    ${${libName}_SOURCE_DIR}/Syscalls/SEGGER_RTT_Syscalls_${SYSCALL_COMPILER_ID}.c
)

target_sources(${libName}
    PRIVATE
    ${${libName}_SOURCES}
)

target_include_directories(${libName}
    PUBLIC
        $<BUILD_INTERFACE:${${libName}_SOURCE_DIR}/Config>
        $<BUILD_INTERFACE:${${libName}_SOURCE_DIR}/RTT>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${libName}>
)

set(${libName}_PUBLIC_HEADERS
        ${${libName}_SOURCE_DIR}/RTT/SEGGER_RTT.h
        ${${libName}_SOURCE_DIR}/Config/SEGGER_RTT_Conf.h
)

# Add target compile options based on toolchain
setTargetCompileOptions(libName)
