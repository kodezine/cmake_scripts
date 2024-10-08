include(CMakePrintHelpers)
# check the environment variable for the supported cortex type
include(${CMAKE_CURRENT_LIST_DIR}/cortex/check_cortex_type.cmake)

# set factors based on the cortex type defined
string (TOLOWER $ENV{CORTEX_TYPE} cmType)
include (${CMAKE_CURRENT_LIST_DIR}/cortex/${cmType}.cmake)

# check if the toolchain path is valid
include (${CMAKE_CURRENT_LIST_DIR}/common/checkcompilerpath.cmake)

# set postfix
set (TC_POSTFIX ".exe")

# specify location of the cross compiler toolchain
set(TC_ROOT_FOLDER "$ENV{COMPILER_ROOT_PATH}")

# Exports the compile options for each file as compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# set toolchain (TC) path independent of host file system
cmake_path(SET TC___C_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/armclang${TC_POSTFIX}")
cmake_path(SET TC_CXX_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/armclang${TC_POSTFIX}")
cmake_path(SET TC_ASM_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/armclang${TC_POSTFIX}")
cmake_path(SET TC_ELF_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/fromelf${TC_POSTFIX}")

# set target compiler triplet (throws error otherwise)
set(FLAGS "${ac6_target} ${cpu_flag} ${fpu_type} ${float_abi}" CACHE STRING "Compiler flags")
set(LINK_FLAGS "${ac6_link_flag}" CACHE STRING "Linker flags")
set(ASM_FLAGS "${ac6_target} ${cpu_flag} ${fpu_type} ${float_abi}" CACHE STRING "ASM flags")

set(CMAKE_C_COMPILER                ${TC___C_EXEC} ${FLAGS})
set(CMAKE_ASM_COMPILER              ${TC___C_EXEC} ${ASM_FLAGS})
set(CMAKE_CXX_COMPILER              ${TC_CXX_EXEC} ${FLAGS} ${CPP_FLAGS})

# Upfront configured for target compilier triplet for compiler checks
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

include(${CMAKE_CURRENT_LIST_DIR}/common/ac6.cmake)
