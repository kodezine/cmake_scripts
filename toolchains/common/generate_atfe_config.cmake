# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Kodezine
#
# generate_atfe_config.cmake
#
# This module provides a CMake function to dynamically generate ATFE (Arm Toolchain
# for Embedded) configuration files based on runtime library, target architecture,
# and CRT variant selections.
#
# The generator function:
# 1. Validates COMPILER_ROOT_PATH and clang binary existence (fail early)
# 2. Detects sysroot location using dual-pattern support
# 3. Auto-downloads missing runtime overlays from ARM releases (if enabled)
# 4. Composes config file with appropriate flags for target/runtime/CRT
# 5. Only regenerates when content changes (MD5-based check)
#
# Generated config files are placed in toolchains/common/.atfe_config/ which
# is git-ignored to prevent accidental commits.

# Function: generate_atfe_config
#
# Generates an ATFE configuration file for the specified target and runtime library.
#
# Parameters:
#   COMPILER_ROOT_PATH - Path to ATFE installation (required, must contain bin/clang)
#   TARGET_ARCH        - Target architecture triple (e.g., armv6m-none-eabi, armv7em-none-eabi)
#   MARCH              - Architecture flag (e.g., armv6-m, armv7e-m)
#   MCPU               - CPU flag (e.g., cortex-m0, cortex-m4, cortex-m7)
#   MFLOAT_ABI         - Float ABI (soft, softfp, hard)
#   MFPU               - FPU type (none, fpv4-sp-d16, fpv5-d16)
#   RUNTIME_LIB        - Runtime library (newlib, newlib-nano, picolibc)
#   CRT_VARIANT        - CRT variant (default, semihost, nosys)
#   AUTO_DOWNLOAD      - Enable auto-download of missing overlays (ON/OFF)
#   OUTPUT_VAR         - Variable name to store generated config file path
#
function(generate_atfe_config)
    set(options "")
    set(oneValueArgs 
        COMPILER_ROOT_PATH 
        TARGET_ARCH 
        MARCH 
        MCPU 
        MFLOAT_ABI 
        MFPU 
        RUNTIME_LIB 
        CRT_VARIANT 
        AUTO_DOWNLOAD 
        OUTPUT_VAR
    )
    set(multiValueArgs "")
    
    cmake_parse_arguments(ATFE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # ============================================================================
    # EARLY VALIDATION - Fail fast with clear error messages
    # ============================================================================
    
    if(NOT ATFE_COMPILER_ROOT_PATH)
        message(FATAL_ERROR 
            "ATFE Configuration Error: COMPILER_ROOT_PATH is not set.\n"
            "Please define COMPILER_ROOT_PATH in your CMake cache or preset.\n"
            "Example: -DCOMPILER_ROOT_PATH=/opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3"
        )
    endif()
    
    if(NOT EXISTS "${ATFE_COMPILER_ROOT_PATH}")
        message(FATAL_ERROR 
            "ATFE Configuration Error: COMPILER_ROOT_PATH does not exist.\n"
            "Path: ${ATFE_COMPILER_ROOT_PATH}\n"
            "Please verify the ATFE installation path is correct."
        )
    endif()
    
    set(CLANG_BINARY "${ATFE_COMPILER_ROOT_PATH}/bin/clang")
    if(NOT EXISTS "${CLANG_BINARY}")
        message(FATAL_ERROR 
            "ATFE Configuration Error: clang binary not found.\n"
            "Expected location: ${CLANG_BINARY}\n"
            "Please verify COMPILER_ROOT_PATH points to a valid ATFE installation."
        )
    endif()
    
    # ============================================================================
    # SYSROOT DETECTION - Support dual patterns
    # ============================================================================
    
    # Pattern 1: lib/clang-runtimes/${RUNTIME_LIB}/
    set(SYSROOT_PATTERN1 "${ATFE_COMPILER_ROOT_PATH}/lib/clang-runtimes/${ATFE_RUNTIME_LIB}")
    
    # Pattern 2: ${RUNTIME_LIB}/arm-none-eabi/
    set(SYSROOT_PATTERN2 "${ATFE_COMPILER_ROOT_PATH}/${ATFE_RUNTIME_LIB}/arm-none-eabi")
    
    if(EXISTS "${SYSROOT_PATTERN1}")
        set(SYSROOT_PATH "${SYSROOT_PATTERN1}")
    elseif(EXISTS "${SYSROOT_PATTERN2}")
        set(SYSROOT_PATH "${SYSROOT_PATTERN2}")
    else()
        # Sysroot not found - attempt auto-download if enabled
        if(ATFE_AUTO_DOWNLOAD)
            message(STATUS "ATFE: Sysroot for '${ATFE_RUNTIME_LIB}' not found, attempting auto-download...")
            
            # Detect clang version (major.minor)
            execute_process(
                COMMAND "${CLANG_BINARY}" --version
                OUTPUT_VARIABLE CLANG_VERSION_OUTPUT
                OUTPUT_STRIP_TRAILING_WHITESPACE
                ERROR_QUIET
            )
            
            if(CLANG_VERSION_OUTPUT MATCHES "version ([0-9]+)\\.([0-9]+)")
                set(CLANG_MAJOR "${CMAKE_MATCH_1}")
                set(CLANG_MINOR "${CMAKE_MATCH_2}")
                set(CLANG_VERSION "${CLANG_MAJOR}.${CLANG_MINOR}")
            else()
                message(FATAL_ERROR 
                    "ATFE Configuration Error: Failed to detect clang version.\n"
                    "Output: ${CLANG_VERSION_OUTPUT}"
                )
            endif()
            
            # Detect host platform
            if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
                set(PLATFORM "linux")
                set(ARCHIVE_EXT ".tar.xz")
            elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
                set(PLATFORM "windows")
                set(ARCHIVE_EXT ".zip")
            elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
                set(PLATFORM "darwin")
                set(ARCHIVE_EXT ".tar.xz")
            else()
                message(FATAL_ERROR 
                    "ATFE Configuration Error: Unsupported host platform: ${CMAKE_HOST_SYSTEM_NAME}\n"
                    "Supported platforms: Linux, Windows, Darwin"
                )
            endif()
            
            # Find matching release (try exact version first, then minor version tolerance)
            set(OVERLAY_BASENAME "LLVMEmbeddedToolchainForArm-${CLANG_VERSION}.0-${PLATFORM}-${ATFE_RUNTIME_LIB}")
            set(OVERLAY_FILENAME "${OVERLAY_BASENAME}${ARCHIVE_EXT}")
            set(OVERLAY_URL "https://github.com/arm/arm-toolchain/releases/download/release-${CLANG_VERSION}.1-ATfE/${OVERLAY_FILENAME}")
            set(CHECKSUM_URL "https://github.com/arm/arm-toolchain/releases/download/release-${CLANG_VERSION}.1-ATfE/SHA256SUMS")
            
            # Download to temporary location
            set(DOWNLOAD_DIR "${CMAKE_BINARY_DIR}/_atfe_downloads")
            file(MAKE_DIRECTORY "${DOWNLOAD_DIR}")
            set(ARCHIVE_PATH "${DOWNLOAD_DIR}/${OVERLAY_FILENAME}")
            set(CHECKSUM_PATH "${DOWNLOAD_DIR}/SHA256SUMS")
            
            # Download checksum file first
            message(STATUS "ATFE: Downloading checksums from ${CHECKSUM_URL}")
            file(DOWNLOAD 
                "${CHECKSUM_URL}"
                "${CHECKSUM_PATH}"
                STATUS CHECKSUM_DOWNLOAD_STATUS
                SHOW_PROGRESS
            )
            
            list(GET CHECKSUM_DOWNLOAD_STATUS 0 CHECKSUM_STATUS_CODE)
            if(NOT CHECKSUM_STATUS_CODE EQUAL 0)
                list(GET CHECKSUM_DOWNLOAD_STATUS 1 CHECKSUM_ERROR_MSG)
                message(FATAL_ERROR 
                    "ATFE Configuration Error: Failed to download SHA256SUMS.\n"
                    "URL: ${CHECKSUM_URL}\n"
                    "Error: ${CHECKSUM_ERROR_MSG}\n"
                    "Please download manually and place overlay in COMPILER_ROOT_PATH."
                )
            endif()
            
            # Extract expected checksum for the overlay file
            file(READ "${CHECKSUM_PATH}" CHECKSUM_CONTENT)
            if(CHECKSUM_CONTENT MATCHES "([0-9a-f]+)[ \t]+${OVERLAY_FILENAME}")
                set(EXPECTED_CHECKSUM "${CMAKE_MATCH_1}")
            else()
                message(FATAL_ERROR 
                    "ATFE Configuration Error: Checksum for ${OVERLAY_FILENAME} not found in SHA256SUMS.\n"
                    "This may indicate version mismatch or unsupported runtime library.\n"
                    "Please verify ATFE version ${CLANG_VERSION} supports '${ATFE_RUNTIME_LIB}'."
                )
            endif()
            
            # Download the overlay archive
            message(STATUS "ATFE: Downloading ${OVERLAY_FILENAME}...")
            file(DOWNLOAD 
                "${OVERLAY_URL}"
                "${ARCHIVE_PATH}"
                STATUS DOWNLOAD_STATUS
                SHOW_PROGRESS
            )
            
            list(GET DOWNLOAD_STATUS 0 DOWNLOAD_STATUS_CODE)
            if(NOT DOWNLOAD_STATUS_CODE EQUAL 0)
                list(GET DOWNLOAD_STATUS 1 DOWNLOAD_ERROR_MSG)
                message(FATAL_ERROR 
                    "ATFE Configuration Error: Failed to download overlay.\n"
                    "URL: ${OVERLAY_URL}\n"
                    "Error: ${DOWNLOAD_ERROR_MSG}\n"
                    "Please download manually and extract to COMPILER_ROOT_PATH."
                )
            endif()
            
            # Verify checksum
            file(SHA256 "${ARCHIVE_PATH}" ACTUAL_CHECKSUM)
            if(NOT ACTUAL_CHECKSUM STREQUAL EXPECTED_CHECKSUM)
                message(FATAL_ERROR 
                    "ATFE Configuration Error: Checksum verification failed.\n"
                    "File: ${OVERLAY_FILENAME}\n"
                    "Expected: ${EXPECTED_CHECKSUM}\n"
                    "Actual:   ${ACTUAL_CHECKSUM}\n"
                    "The downloaded file may be corrupted. Please try again or download manually."
                )
            endif()
            
            message(STATUS "ATFE: Checksum verified successfully")
            
            # Extract to COMPILER_ROOT_PATH
            message(STATUS "ATFE: Extracting overlay to ${ATFE_COMPILER_ROOT_PATH}...")
            if(PLATFORM STREQUAL "windows")
                execute_process(
                    COMMAND "${CMAKE_COMMAND}" -E tar xf "${ARCHIVE_PATH}"
                    WORKING_DIRECTORY "${ATFE_COMPILER_ROOT_PATH}"
                    RESULT_VARIABLE EXTRACT_RESULT
                    ERROR_VARIABLE EXTRACT_ERROR
                )
            else()
                execute_process(
                    COMMAND tar xf "${ARCHIVE_PATH}" -C "${ATFE_COMPILER_ROOT_PATH}"
                    RESULT_VARIABLE EXTRACT_RESULT
                    ERROR_VARIABLE EXTRACT_ERROR
                )
            endif()
            
            if(NOT EXTRACT_RESULT EQUAL 0)
                message(FATAL_ERROR 
                    "ATFE Configuration Error: Failed to extract overlay.\n"
                    "Archive: ${ARCHIVE_PATH}\n"
                    "Error: ${EXTRACT_ERROR}\n"
                    "Please extract manually to COMPILER_ROOT_PATH."
                )
            endif()
            
            message(STATUS "ATFE: Overlay installed successfully")
            
            # Cleanup archive
            file(REMOVE "${ARCHIVE_PATH}" "${CHECKSUM_PATH}")
            
            # Re-check sysroot existence
            if(EXISTS "${SYSROOT_PATTERN1}")
                set(SYSROOT_PATH "${SYSROOT_PATTERN1}")
            elseif(EXISTS "${SYSROOT_PATTERN2}")
                set(SYSROOT_PATH "${SYSROOT_PATTERN2}")
            else()
                message(FATAL_ERROR 
                    "ATFE Configuration Error: Sysroot still not found after extraction.\n"
                    "Expected: ${SYSROOT_PATTERN1} or ${SYSROOT_PATTERN2}\n"
                    "The overlay may not have the expected directory structure."
                )
            endif()
        else()
            message(FATAL_ERROR 
                "ATFE Configuration Error: Sysroot for '${ATFE_RUNTIME_LIB}' not found.\n"
                "Checked paths:\n"
                "  1. ${SYSROOT_PATTERN1}\n"
                "  2. ${SYSROOT_PATTERN2}\n"
                "Auto-download is disabled (ATFE_AUTO_DOWNLOAD=OFF).\n"
                "Please install the '${ATFE_RUNTIME_LIB}' overlay manually or enable auto-download."
            )
        endif()
    endif()
    
    # Make sysroot path relative to COMPILER_ROOT_PATH/bin/ for portability
    file(RELATIVE_PATH SYSROOT_RELATIVE 
        "${ATFE_COMPILER_ROOT_PATH}/bin" 
        "${SYSROOT_PATH}"
    )
    
    # ============================================================================
    # CONFIG FILE COMPOSITION
    # ============================================================================
    
    # Determine CRT libraries based on variant
    if(ATFE_CRT_VARIANT STREQUAL "semihost")
        set(CRT_LIBS "-lcrt0-rdimon\n-lrdimon")
    elseif(ATFE_CRT_VARIANT STREQUAL "nosys")
        set(CRT_LIBS "-lcrt0-nosys")
    else()
        # default
        set(CRT_LIBS "-lcrt0")
    endif()
    
    # Compose config file content
    set(CONFIG_CONTENT "# ATFE Configuration File\n")
    string(APPEND CONFIG_CONTENT "# Generated: ${CMAKE_CURRENT_LIST_FILE}\n")
    string(APPEND CONFIG_CONTENT "# Target Arch: ${ATFE_TARGET_ARCH}\n")
    string(APPEND CONFIG_CONTENT "# Float ABI: ${ATFE_MFLOAT_ABI}\n")
    string(APPEND CONFIG_CONTENT "# FPU: ${ATFE_MFPU}\n")
    string(APPEND CONFIG_CONTENT "# Runtime Library: ${ATFE_RUNTIME_LIB}\n")
    string(APPEND CONFIG_CONTENT "# CRT Variant: ${ATFE_CRT_VARIANT}\n")
    string(APPEND CONFIG_CONTENT "# COMPILER_ROOT_PATH: ${ATFE_COMPILER_ROOT_PATH}\n")
    string(APPEND CONFIG_CONTENT "# Sysroot: ${SYSROOT_PATH}\n")
    string(APPEND CONFIG_CONTENT "\n")
    string(APPEND CONFIG_CONTENT "--target=${ATFE_TARGET_ARCH}\n")
    string(APPEND CONFIG_CONTENT "-march=${ATFE_MARCH}\n")
    string(APPEND CONFIG_CONTENT "-mcpu=${ATFE_MCPU}\n")
    string(APPEND CONFIG_CONTENT "-mfloat-abi=${ATFE_MFLOAT_ABI}\n")
    
    if(NOT ATFE_MFPU STREQUAL "none")
        string(APPEND CONFIG_CONTENT "-mfpu=${ATFE_MFPU}\n")
    endif()
    
    string(APPEND CONFIG_CONTENT "--sysroot=../${SYSROOT_RELATIVE}\n")
    string(APPEND CONFIG_CONTENT "-nostartfiles\n")
    string(APPEND CONFIG_CONTENT "${CRT_LIBS}\n")
    
    # ============================================================================
    # MD5-BASED REGENERATION CHECK
    # ============================================================================
    
    # Create output directory
    set(CONFIG_DIR "${CMAKE_CURRENT_LIST_DIR}/.atfe_config")
    file(MAKE_DIRECTORY "${CONFIG_DIR}")
    
    # Generate variant-specific filename
    set(CONFIG_FILENAME "${ATFE_TARGET_ARCH}_${ATFE_RUNTIME_LIB}_${ATFE_CRT_VARIANT}_${ATFE_MFLOAT_ABI}.cfg")
    set(CONFIG_FILE_PATH "${CONFIG_DIR}/${CONFIG_FILENAME}")
    
    # Compute MD5 of new content (excluding timestamp/hash header lines)
    string(REGEX REPLACE "# Generated:.*\n" "" CONFIG_CONTENT_NO_TIMESTAMP "${CONFIG_CONTENT}")
    string(MD5 NEW_CONTENT_HASH "${CONFIG_CONTENT_NO_TIMESTAMP}")
    
    # Check if regeneration is needed
    set(NEEDS_REGENERATION TRUE)
    if(EXISTS "${CONFIG_FILE_PATH}")
        file(READ "${CONFIG_FILE_PATH}" EXISTING_CONTENT)
        if(EXISTING_CONTENT MATCHES "# Content Hash: ([a-f0-9]+)")
            set(EXISTING_HASH "${CMAKE_MATCH_1}")
            if(EXISTING_HASH STREQUAL NEW_CONTENT_HASH)
                set(NEEDS_REGENERATION FALSE)
                message(STATUS "ATFE: Config file unchanged, skipping regeneration: ${CONFIG_FILENAME}")
            endif()
        endif()
    endif()
    
    # Write config file if needed
    if(NEEDS_REGENERATION)
        string(TIMESTAMP CURRENT_TIMESTAMP UTC)
        string(REGEX REPLACE "# Generated:.*\n" "# Generated: ${CURRENT_TIMESTAMP} UTC\n" 
            CONFIG_CONTENT_FINAL "${CONFIG_CONTENT}")
        
        # Insert hash header after timestamp
        string(REGEX REPLACE "(# Generated: [^\n]+\n)" 
            "\\1# Content Hash: ${NEW_CONTENT_HASH}\n" 
            CONFIG_CONTENT_FINAL "${CONFIG_CONTENT_FINAL}")
        
        file(WRITE "${CONFIG_FILE_PATH}" "${CONFIG_CONTENT_FINAL}")
        message(STATUS "ATFE: Generated config file: ${CONFIG_FILENAME}")
    endif()
    
    # Return absolute path via output variable
    set(${ATFE_OUTPUT_VAR} "${CONFIG_FILE_PATH}" PARENT_SCOPE)
    
endfunction()
