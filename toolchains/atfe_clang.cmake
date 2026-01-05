# SPDX-License-Identifier: MIT Copyright (c) 2026 Kodezine
#
# ============================================================================ ATFE (Arm Toolchain for Embedded) -
# LLVM/Clang Toolchain Configuration
# ============================================================================
#
# This toolchain file provides support for the Arm Toolchain for Embedded (ATFE), which is a Clang-based compiler
# toolchain for bare-metal ARM Cortex-M development.
#
# GitHub Repository: https://github.com/arm/arm-toolchain
#
# ============================================================================ PREREQUISITES
# ============================================================================
#
# 1. COMPILER_ROOT_PATH must be defined in your CMake cache or preset: - Points to the ATFE installation directory -
#   Example: /opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3 - Must contain bin/clang executable
#
# 1. Runtime Library Overlays: - By default, auto-download is enabled (ATFE_AUTO_DOWNLOAD=ON) - Overlays are downloaded
#   from ARM GitHub releases as needed - Downloaded overlays are installed in COMPILER_ROOT_PATH - For offline/CI
#   environments, pre-install overlays or disable auto-download
#
# ============================================================================ HOW IT WORKS
# ============================================================================
#
# This toolchain uses a dynamic configuration approach:
#
# 1. Cache Variable Selection: - Select runtime library via ATFE_RUNTIME_LIB (newlib/newlib-nano/picolibc) - Select CRT
#   variant via ATFE_CRT_VARIANT (default/semihost/nosys) - Configure auto-download via ATFE_AUTO_DOWNLOAD (ON/OFF)
#
# 1. Early Validation: - Verifies COMPILER_ROOT_PATH is set and exists - Checks for clang binary existence - Detects
#   sysroot location using dual-pattern support
#
# 1. Auto-Download (if enabled): - Detects clang version (major.minor) - Downloads matching runtime overlay from ARM
#   releases - Verifies SHA256 checksum - Extracts to COMPILER_ROOT_PATH - Cleans up archive after installation
#
# 1. Config File Generation: - Generates .cfg file in toolchains/common/.atfe_config/ - Config files are variant-specific
#   and git-ignored - Only regenerates when content changes (MD5-based) - Uses relative paths for portability
#
# 1. Compiler Invocation: - Clang is invoked with --config=<path-to-cfg> - Config file contains all target/runtime/CRT
#   settings
#
# ============================================================================ CACHE VARIABLES
# ============================================================================
#
# COMPILER_ROOT_PATH (REQUIRED) Path to ATFE installation directory Example:
# /opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3
#
# CORTEX_TYPE (REQUIRED) Target Cortex-M variant Options: cm0, cm4f, cm7
#
# ATFE_RUNTIME_LIB (Default: newlib) Runtime library selection Options: newlib, newlib-nano, picolibc
#
# ATFE_CRT_VARIANT (Default: default) C runtime startup variant Options: - default:  Standard startup (-lcrt0) -
# semihost: Semihosting support (-lcrt0-rdimon -lrdimon) - nosys:    No syscalls (-lcrt0-nosys)
#
# ATFE_AUTO_DOWNLOAD (Default: ON) Enable automatic download of missing runtime overlays Set to OFF for offline/CI
# environments with pre-installed overlays
#
# ============================================================================ EXAMPLE USAGE
# ============================================================================
#
# CMakePresets.json: { "configurePresets": [ { "name": "cortex-m4-atfe-newlib", "cacheVariables": {
# "CMAKE_TOOLCHAIN_FILE": "${sourceDir}/cmake/toolchains/atfe_clang.cmake", "COMPILER_ROOT_PATH":
# "/opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3", "CORTEX_TYPE": "cm4f", "ATFE_RUNTIME_LIB": "newlib",
# "ATFE_CRT_VARIANT": "semihost", "ATFE_AUTO_DOWNLOAD": "ON" } } ] }
#
# ============================================================================ TROUBLESHOOTING
# ============================================================================
#
# Error: "COMPILER_ROOT_PATH is not set" Solution: Define COMPILER_ROOT_PATH in your CMake cache or preset
#
# Error: "COMPILER_ROOT_PATH does not exist" Solution: Verify the path points to a valid ATFE installation
#
# Error: "clang binary not found" Solution: Ensure COMPILER_ROOT_PATH contains bin/clang
#
# Error: "Sysroot for 'xxx' not found" Solution 1: Enable ATFE_AUTO_DOWNLOAD=ON to auto-download overlays Solution 2:
# Manually install the overlay from ARM GitHub releases
#
# Error: "Failed to download overlay" Solution: Check network connectivity or download manually from:
# https://github.com/arm/arm-toolchain/releases
#
# Error: "Checksum verification failed" Solution: Delete the downloaded file and try again, or download manually
#
# ============================================================================

include (CMakePrintHelpers)

# Set CMake system information for cross-compilation
set (CMAKE_SYSTEM_NAME Generic)
set (CMAKE_SYSTEM_PROCESSOR ARM)

# Validate COMPILER_ROOT_PATH early (before including cortex files)
if (NOT DEFINED COMPILER_ROOT_PATH)
  message (
    FATAL_ERROR
      "ATFE Toolchain Error: COMPILER_ROOT_PATH is not defined.\n"
      "Please set COMPILER_ROOT_PATH in your CMake cache or preset.\n"
      "Example: -DCOMPILER_ROOT_PATH=/opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3")
endif ()

if (NOT DEFINED CORTEX_TYPE)
  message (FATAL_ERROR "ATFE Toolchain Error: CORTEX_TYPE is not defined.\n"
                       "Please set CORTEX_TYPE in your CMake cache or preset.\n" "Supported values: cm0, cm4f, cm7")
endif ()

# Create .atfe_config directory for generated configs
set (ATFE_CONFIG_DIR "${CMAKE_CURRENT_LIST_DIR}/common/.atfe_config")
file (MAKE_DIRECTORY "${ATFE_CONFIG_DIR}")

# Include cortex-specific configuration This will set ATFE cache variables and generate the config file
string (TOLOWER "${CORTEX_TYPE}" cmType)
include (${CMAKE_CURRENT_LIST_DIR}/cortex/${cmType}.cmake)

# Exports the compile options for each file as compile_commands.json
set (CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set toolchain paths
cmake_path (SET TC_ROOT_FOLDER NORMALIZE "${COMPILER_ROOT_PATH}")
cmake_path (SET TC___C_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/clang")
cmake_path (SET TC_CXX_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/clang++")
cmake_path (SET TC_ASM_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/clang")

# Set LLVM tool paths
cmake_path (SET TC_ELF_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-objcopy")
cmake_path (SET TC_SIZ_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-size")
cmake_path (SET TC_CFG_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-config")
cmake_path (SET TC_OBJ_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-objdump")
cmake_path (SET TC__NM_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-nm")
cmake_path (SET TC_ROB_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-readobj")

# Use generated ATFE config file
if (DEFINED atfe_config_file_name)
  set (
    FLAGS
    "--config=${atfe_config_file_name}"
    CACHE STRING "Compiler flags")
else ()
  message (WARNING "ATFE config file not generated. Build may fail.")
endif ()

set (ASM_FLAGS "-x assembler-with-cpp")

set (CMAKE_C_COMPILER ${TC___C_EXEC} ${FLAGS})
set (CMAKE_ASM_COMPILER ${TC_ASM_EXEC} ${ASM_FLAGS})
set (CMAKE_CXX_COMPILER ${TC_CXX_EXEC} ${FLAGS})
set (CMAKE_OBJCOPY ${TC_ELF_EXEC})
set (CMAKE_SIZE ${TC_SIZ_EXEC})

# LLVM tools
set (CMAKE_LLVM_OBJDUMP ${TC_OBJ_EXEC})
set (CMAKE_LLVM_NM ${TC__NM_EXEC})
set (CMAKE_LLVM_READOBJ ${TC_ROB_EXEC})

set (CMAKE_EXECUTABLE_SUFFIX_ASM ".elf")
set (CMAKE_EXECUTABLE_SUFFIX_C ".elf")
set (CMAKE_EXECUTABLE_SUFFIX_CXX ".elf")
set (CMAKE_EXECUTABLE_SUFFIX ".elf")

# Upfront configured for target compiler triplet for compiler checks
set (CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Include common clang settings
include (${CMAKE_CURRENT_LIST_DIR}/common/clang.cmake)

# Don't search for programs in host directories
set (CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set (CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set (CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

message (STATUS "ATFE Toolchain configured:")
message (STATUS "  COMPILER_ROOT_PATH: ${COMPILER_ROOT_PATH}")
message (STATUS "  CORTEX_TYPE: ${CORTEX_TYPE}")
message (STATUS "  Runtime Library: ${ATFE_RUNTIME_LIB}")
message (STATUS "  CRT Variant: ${ATFE_CRT_VARIANT}")
message (STATUS "  Auto-Download: ${ATFE_AUTO_DOWNLOAD}")
if (DEFINED atfe_config_file_name)
  message (STATUS "  Config File: ${atfe_config_file_name}")
endif ()
