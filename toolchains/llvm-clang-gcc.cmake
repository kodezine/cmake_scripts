include(CMakePrintHelpers)
# This toolchain is a hybrid as described in
# https://interrupt.memfault.com/blog/arm-cortexm-with-llvm-clang#update-clang-baremetal
# check the environment variable for the supported cortex type
include(${CMAKE_CURRENT_LIST_DIR}/common/checkCORTEX_TYPE.cmake)

# set factors based on the cortex type defined
include(${CMAKE_CURRENT_LIST_DIR}/cortex/$ENV{CORTEX_TYPE}.cmake)

# Specify location of toolchain root folder (clang)
message(CHECK_START "Searching for LLVM_CLANG_ROOT_FOLDER")
if(NOT EXISTS "$ENV{LLVM_CLANG_ROOT_FOLDER}")
    message(CHECK_FAIL "not found.")
    message(FATAL_ERROR "No valid compiler for this toolchain found, aborting!")
else()
    message(CHECK_PASS "found ... \"$ENV{LLVM_CLANG_ROOT_FOLDER}\"")
    set(TC_ROOT_FOLDER "$ENV{LLVM_CLANG_ROOT_FOLDER}")
endif()

# Specify location of toolchain root folder (arm-none-eabi-gcc)
message(CHECK_START "Searching for ARM_GCC_ROOT_FOLDER")
if(NOT EXISTS "$ENV{ARM_GCC_ROOT_FOLDER}")
    message(CHECK_FAIL "not found.")
    message(FATAL_ERROR "The cross compile toolchain with clang did not find a suitable arm-none-eabi-gcc to work with, aborting!")
else()
    message(CHECK_PASS "found ... \"$ENV{ARM_GCC_ROOT_FOLDER}\"")
    set(ARM_GCC_ROOT_FOLDER "$ENV{ARM_GCC_ROOT_FOLDER}")
    execute_process(COMMAND ${ARM_GCC_ROOT_FOLDER}/bin/arm-none-eabi-gcc${TC_POSTFIX} ${cpu_mode} ${cpu_flag} ${float_abi} ${fpu_type} -print-sysroot            OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE ARM_CORTEXM_SYSROOT)
    execute_process(COMMAND ${ARM_GCC_ROOT_FOLDER}/bin/arm-none-eabi-gcc${TC_POSTFIX} ${cpu_mode} ${cpu_flag} ${float_abi} ${fpu_type} -print-multi-directory    OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE ARM_CORTEXM_MULTI_DIR)
    execute_process(COMMAND ${ARM_GCC_ROOT_FOLDER}/bin/arm-none-eabi-gcc${TC_POSTFIX} ${cpu_mode} ${cpu_flag} ${float_abi} ${fpu_type} -print-libgcc-file-name    OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE ARM_CORTEXM_BUILTINS)
    cmake_print_variables(ARM_CORTEXM_SYSROOT ARM_CORTEXM_MULTI_DIR ARM_CORTEXM_BUILTINS)
endif()

# Exports the compile options for each file as compile_commands.json
set (CMAKE_EXPORT_COMPILE_COMMANDS ON)

# set toolchain (TC) path independent of host file system
cmake_path(SET TC___C_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/clang${TC_POSTFIX}")
cmake_path(SET TC_CXX_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/clang${TC_POSTFIX}")
cmake_path(SET TC_ASM_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/clang${TC_POSTFIX}")
cmake_path(SET TC_ELF_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-objcopy${TC_POSTFIX}")
cmake_path(SET TC_SIZ_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-size${TC_POSTFIX}")

# set target compiler triplet (throws error otherwise)
# We do not use the default config files since we use the libraries from GCC set(FLAGS "${llvm_config_file}" CACHE STRING "Compiler flags")
set(FLAGS                           "${llvm_gcc_target} ${llvm_gcc_float_abi} ${llvm_gcc_march} --sysroot=${ARM_CORTEXM_SYSROOT}")
set(COMPILER_SPECIFIC_CFLAGS        ${FLAGS})
set(COMPILER_SPECIFIC_LD_FLAGS      "-L${ARM_CORTEXM_SYSROOT}/lib/${ARM_CORTEXM_MULTI_DIR} ${ARM_CORTEXM_BUILTINS}")
set(ASM_FLAGS                       "-x assembler-with-cpp")

set(CMAKE_C_COMPILER                ${TC___C_EXEC} ${FLAGS})
set(CMAKE_ASM_COMPILER              ${TC___C_EXEC} ${ASM_FLAGS})
set(CMAKE_CXX_COMPILER              ${TC_CXX_EXEC} ${FLAGS} ${CPP_FLAGS})
set(CMAKE_OBJCOPY                   ${TC_ELF_EXEC})
set(CMAKE_SIZE                      ${TC_SIZ_EXEC})

set(CMAKE_EXECUTABLE_SUFFIX_ASM     ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C       ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX     ".elf")
set(CMAKE_EXECUTABLE_SUFFIX         ".elf")
# Upfront configured for target compilier triplet for compiler checks
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

include(${CMAKE_CURRENT_LIST_DIR}/common/clang.cmake)
