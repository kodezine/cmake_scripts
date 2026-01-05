# Cortex M4F based flags for compilation and linking
set (
  cpu_flag
  "-mcpu=cortex-m4"
  CACHE STRING "Cortex CPU")
set (
  cpu_mode
  "-mthumb"
  CACHE STRING "ARM Mode")
set (
  ac6_target
  "--target=arm-arm-none-eabi"
  CACHE STRING "AC6 Target")
set (ac6_link_flag "Cortex-M4.fp.sp")
set (
  fpu_type
  "-mfpu=fpv4-sp-d16"
  CACHE STRING "Floating Point Type")
set (
  float_abi
  "-mfloat-abi=hard"
  CACHE STRING "ABI For floating point")
set (
  llvm_config_file_name
  "armv7m_hard_fpv4_sp_d16.cfg"
  CACHE STRING "LLVM configuration file name")
set (
  llvm_config_file
  "--config=${llvm_config_file_name}"
  CACHE STRING "LLVM configuration file")

# ATFE (Arm Toolchain for Embedded) Configuration
set (
  ATFE_RUNTIME_LIB
  "newlib"
  CACHE STRING "ATFE runtime library (newlib, newlib-nano, picolibc)")
set_property (CACHE ATFE_RUNTIME_LIB PROPERTY STRINGS "newlib" "newlib-nano" "picolibc")

set (
  ATFE_CRT_VARIANT
  "default"
  CACHE STRING "ATFE CRT variant (default, semihost, nosys)")
set_property (CACHE ATFE_CRT_VARIANT PROPERTY STRINGS "default" "semihost" "nosys")

set (
  ATFE_AUTO_DOWNLOAD
  ON
  CACHE BOOL "Enable auto-download of missing ATFE runtime overlays")

# Generate ATFE config file if COMPILER_ROOT_PATH is defined
if (DEFINED COMPILER_ROOT_PATH)
  include (${CMAKE_CURRENT_LIST_DIR}/../common/generate_atfe_config.cmake)

  generate_atfe_config (
    COMPILER_ROOT_PATH
    "${COMPILER_ROOT_PATH}"
    TARGET_ARCH
    "armv7em-none-eabi"
    MARCH
    "armv7e-m"
    MCPU
    "cortex-m4"
    MFLOAT_ABI
    "hard"
    MFPU
    "fpv4-sp-d16"
    RUNTIME_LIB
    "${ATFE_RUNTIME_LIB}"
    CRT_VARIANT
    "${ATFE_CRT_VARIANT}"
    AUTO_DOWNLOAD
    "${ATFE_AUTO_DOWNLOAD}"
    OUTPUT_VAR
    atfe_config_file_path)

  set (
    atfe_config_file_name
    "${atfe_config_file_path}"
    CACHE STRING "ATFE configuration file path")
endif ()
