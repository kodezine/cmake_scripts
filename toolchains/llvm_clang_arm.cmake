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

# set toolchain (TC) path independent of host file system for clang tools
cmake_path (SET TC___C_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/clang${TC_POSTFIX}")
cmake_path (SET TC_CXX_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/clang${TC_POSTFIX}")
cmake_path (SET TC_ASM_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/clang${TC_POSTFIX}")

# set toolchain (TC) path independent of the host file system for LLVM tools
cmake_path (SET TC_ELF_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-objcopy${TC_POSTFIX}")
cmake_path (SET TC_SIZ_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-size${TC_POSTFIX}")
cmake_path (SET TC_CFG_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-config${TC_POSTFIX}")
cmake_path (SET TC_OBJ_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-objdump${TC_POSTFIX}")
cmake_path (SET TC__NM_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-nm${TC_POSTFIX}")
cmake_path (SET TC_ROB_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-readobj${TC_POSTFIX}")

# exclusive for llvm compilers
if (NOT EXISTS $ENV{COMPILER_ROOT_PATH}/bin/${llvm_config_file_name})
  configure_file (${CMAKE_CURRENT_LIST_DIR}/common/.llvm_configs/${llvm_config_file_name}
                  $ENV{COMPILER_ROOT_PATH}/bin/${llvm_config_file_name} COPYONLY)
endif ()
# set target compiler triplet (throws error otherwise)
set (
  FLAGS
  "${llvm_config_file}"
  CACHE STRING "Compiler flags")
set (ASM_FLAGS "-x assembler-with-cpp")

set (CMAKE_C_COMPILER ${TC___C_EXEC} ${FLAGS})
set (CMAKE_ASM_COMPILER ${TC___C_EXEC} ${ASM_FLAGS})
set (CMAKE_CXX_COMPILER ${TC_CXX_EXEC} ${FLAGS} ${CPP_FLAGS})
set (CMAKE_OBJCOPY ${TC_ELF_EXEC})
set (CMAKE_SIZE ${TC_SIZ_EXEC})

# llvm tools
set (CMAKE_LLVM_OBJDUMP ${TC_OBJ_EXEC})
set (CMAKE_LLVM_NM ${TC__NM_EXEC})
set (CMAKE_LLVM_READOBJ ${TC_ROB_EXEC})

set (CMAKE_EXECUTABLE_SUFFIX_ASM ".elf")
set (CMAKE_EXECUTABLE_SUFFIX_C ".elf")
set (CMAKE_EXECUTABLE_SUFFIX_CXX ".elf")
set (CMAKE_EXECUTABLE_SUFFIX ".elf")
# Upfront configured for target compilier triplet for compiler checks
set (CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

include (${CMAKE_CURRENT_LIST_DIR}/common/clang.cmake)
