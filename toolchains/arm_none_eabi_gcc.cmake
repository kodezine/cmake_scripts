include (CMakePrintHelpers)
# check the environment variable for the supported cortex type
include (${CMAKE_CURRENT_LIST_DIR}/cortex/check_cortex_type.cmake)

# set factors based on the cortex type defined
string (TOLOWER $ENV{CORTEX_TYPE} cmType)
include (${CMAKE_CURRENT_LIST_DIR}/cortex/${cmType}.cmake)

# check if the toolchain path is valid
include (${CMAKE_CURRENT_LIST_DIR}/common/checkcompilerpath.cmake)

# specify location of the cross compiler toolchain
set (TC_ROOT_FOLDER "$ENV{COMPILER_ROOT_PATH}")

# Exports the compile options for each file as compile_commands.json
set (CMAKE_EXPORT_COMPILE_COMMANDS ON)

set (TC_PREFIX "arm-none-eabi-")

# set toolchain (TC) path independent of host file system
set (TC___C_EXEC "${TC_ROOT_FOLDER}/bin/${TC_PREFIX}gcc${TC_POSTFIX}")
set (TC_CXX_EXEC "${TC_ROOT_FOLDER}/bin/${TC_PREFIX}g++${TC_POSTFIX}")
set (TC_GDB_EXEC "${TC_ROOT_FOLDER}/bin/${TC_PREFIX}gdb${TC_POSTFIX}")
set (TC_OBJ_EXEC "${TC_ROOT_FOLDER}/bin/${TC_PREFIX}objcopy${TC_POSTFIX}")
set (TC_SIZ_EXEC "${TC_ROOT_FOLDER}/bin/${TC_PREFIX}size${TC_POSTFIX}")

set (
  FLAGS
  "${cpu_flag} ${cpu_mode} ${fpu_type} ${float_abi}"
  CACHE STRING "Compiler flags")
set (
  LINK_FLAGS
  "${cpu_flags} ${cpu_mode}"
  CACHE STRING "Linker flags")
set (ASM_FLAGS "-x assembler-with-cpp")

set (CMAKE_C_COMPILER ${TC___C_EXEC} ${FLAGS})
set (CMAKE_ASM_COMPILER ${TC___C_EXEC} ${ASM_FLAGS})
set (CMAKE_CXX_COMPILER ${TC_CXX_EXEC} ${FLAGS} ${CPP_FLAGS})
set (CMAKE_OBJCOPY ${TC_OBJ_EXEC})
set (CMAKE_SIZE ${TC_SIZ_EXEC})

set (CMAKE_EXECUTABLE_SUFFIX_ASM ".elf")
set (CMAKE_EXECUTABLE_SUFFIX_C ".elf")
set (CMAKE_EXECUTABLE_SUFFIX_CXX ".elf")
set (CMAKE_EXECUTABLE_SUFFIX ".elf")
# Upfront configured for target compilier triplet for compiler checks
set (CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

include (${CMAKE_CURRENT_LIST_DIR}/common/gcc.cmake)
