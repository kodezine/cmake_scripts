# Cortex M0 based flags for compilation and linking
set (
  cpu_flag
  "-mcpu=cortex-m0"
  CACHE STRING "Cortex CPU")
set (
  cpu_mode
  "-mthumb"
  CACHE STRING "ARM Mode")
set (
  ac6_target
  "--target=arm-arm-none-eabi"
  CACHE STRING "AC6 Target")
set (ac6_link_flag "Cortex-M0")
set (fpu_type "")
set (float_abi "")
set (
  llvm_config_file_name
  "armv6m_soft_nofp.cfg"
  CACHE STRING "LLVM configuration file name")
set (
  llvm_config_file
  "--config=${llvm_config_file_name}"
  CACHE STRING "LLVM configuration file")
set (
  llvm_gcc_target
  "--target=armv6m-none-eabi"
  CACHE STRING "ARM string ")
set (
  llvm_gcc_float_abi
  "-mfloat-abi=soft"
  CACHE STRING "llvm gcc abi")
set (
  llvm_gcc_march
  "-march=armv6m"
  CACHE STRING "ARM Cache")

# ATFE (Arm Toolchain for Embedded) Configuration
set (
  ATFE_RUNTIME_LIB
  "newlib"
  CACHE STRING "ATFE runtime library (newlib, newlib-nano, picolibc)")
set_property(CACHE ATFE_RUNTIME_LIB PROPERTY STRINGS "newlib" "newlib-nano" "picolibc")

set (
  ATFE_CRT_VARIANT
  "default"
  CACHE STRING "ATFE CRT variant (default, semihost, nosys)")
set_property(CACHE ATFE_CRT_VARIANT PROPERTY STRINGS "default" "semihost" "nosys")

set (
  ATFE_AUTO_DOWNLOAD
  ON
  CACHE BOOL "Enable auto-download of missing ATFE runtime overlays")

# Generate ATFE config file if COMPILER_ROOT_PATH is defined
if(DEFINED COMPILER_ROOT_PATH)
    include(${CMAKE_CURRENT_LIST_DIR}/../common/generate_atfe_config.cmake)
    
    generate_atfe_config(
        COMPILER_ROOT_PATH "${COMPILER_ROOT_PATH}"
        TARGET_ARCH "armv6m-none-eabi"
        MARCH "armv6-m"
        MCPU "cortex-m0"
        MFLOAT_ABI "soft"
        MFPU "none"
        RUNTIME_LIB "${ATFE_RUNTIME_LIB}"
        CRT_VARIANT "${ATFE_CRT_VARIANT}"
        AUTO_DOWNLOAD "${ATFE_AUTO_DOWNLOAD}"
        OUTPUT_VAR atfe_config_file_path
    )
    
    set (
      atfe_config_file_name
      "${atfe_config_file_path}"
      CACHE STRING "ATFE configuration file path")
endif()
