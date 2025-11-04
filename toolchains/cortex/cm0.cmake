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
