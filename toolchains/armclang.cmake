
include(CMakePrintHelpers)
# check the environment variable for the supported cortex type
include(${CMAKE_CURRENT_LIST_DIR}/cortex/check_cortex_type.cmake)

# set factors based on the cortex type defined
string (TOLOWER $ENV{CORTEX_TYPE} cmType)
include (${CMAKE_CURRENT_LIST_DIR}/cortex/${cmType}.cmake)

# Let's begin with starting the license client tunnel
execute_process(
    COMMAND /home/build/ARM/license-tunnel.sh
    TIMEOUT 10
)

# Specify license variables for armclang
if(NOT EXISTS "$ENV{ARM_PRODUCT_DEF}")
    message(STATUS "Could not find ARM_PRODUCT_DEF in environment ... setting to bronze")
    set(ENV{ARM_PRODUCT_DEF} "/home/build/ARM/bronze.elmap")
else()
    cmake_print_variables($ENV{ARM_PRODUCT_DEF})
endif()

# check if the toolchain path is valid
include (${CMAKE_CURRENT_LIST_DIR}/common/checkcompilerpath.cmake)

# specify location of the cross compiler toolchain
set(TC_ROOT_FOLDER "$ENV{COMPILER_ROOT_PATH}")

# Exports the compile options for each file as compile_commands.json
set (CMAKE_EXPORT_COMPILE_COMMANDS ON)

# set toolchain (TC) path independent of host file system
cmake_path(SET TC___C_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/armclang${TC_POSTFIX}")
cmake_path(SET TC_CXX_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/armclang${TC_POSTFIX}")
cmake_path(SET TC_ASM_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/armclang${TC_POSTFIX}")
cmake_path(SET TC_ELF_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/fromelf${TC_POSTFIX}")

set(FLAGS "${ac6_target} ${cpu_flag} ${fpu_type} ${float_abi}" CACHE STRING "Compiler flags")
set(LINK_FLAGS "${cpu_link_flags}" CACHE STRING "Linker flags")

set(CMAKE_C_COMPILER    ${TC___C_EXEC} ${FLAGS})
set(CMAKE_CXX_COMPILER  ${TC_CXX_EXEC} ${FLAGS})
set(CMAKE_ASM_COMPILER  ${TC_ASM_EXEC} ${FLAGS})

# Upfront configured for target compilier triplet for compiler checks
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

include(${CMAKE_CURRENT_LIST_DIR}/common/ac6.cmake)
