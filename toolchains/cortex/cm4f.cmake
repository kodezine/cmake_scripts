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
