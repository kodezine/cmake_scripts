include(CMakePrintHelpers)

# Function to show compiler version
function(showCompilerVersion)
    execute_process(COMMAND "${CMAKE_C_COMPILER}" -dumpversion
        OUTPUT_VARIABLE CVERSION
        ERROR_VARIABLE CVERSION
    )
    set(COMPILERVERSION ${CVERSION} PARENT_SCOPE)
    cmake_print_variables(CVERSION)
    cmake_print_variables(CMAKE_C_COMPILER)
endfunction(showCompilerVersion)

# Function to set compiler options (Private)
function(setTargetCompileOptions PROJECTNAME)
    target_compile_options( ${${PROJECTNAME}}
    PUBLIC
    ${COMPILER_SPECIFIC_CFLAGS}
    # -std=c11
    -c
    -fno-rtti
    -funsigned-char
    -fshort-enums
    -fshort-wchar
    -gdwarf-3                                   # defaulting to legacy debug tables for armgdb debuggers
    -ffunction-sections
    -Wno-packed
    -Wno-missing-variable-declarations
    -Wno-missing-prototypes
    -Wno-missing-noreturn
    -Wno-sign-conversion
    -Wno-nonportable-include-path
    -Wno-reserved-id-macro
    -Wno-unused-macros
    -Wno-documentation-unknown-command
    -Wno-documentation
    -Wno-parentheses-equality
    -Wno-reserved-identifier
    "$<$<CONFIG:Debug>:-O1>"                    # Optimized for debugging
    )
endfunction(setTargetCompileOptions)

# Function to set linker options (Private)
function(setTargetLinkOptions PROJECTNAME)
    target_link_options( ${${PROJECTNAME}}
        PUBLIC
        ${COMPILER_SPECIFIC_LD_FLAGS}
        -Wl,-Map=${${PROJECTNAME}}.map -Xlinker --cref
        -L${${${PROJECTNAME}}_LLVM_LINKER_PATH}
        -T${${${PROJECTNAME}}_LLVM_LINKER_SCRIPT}
    )
    message(STATUS "Linking with ${${${PROJECTNAME}}_LLVM_LINKER_PATH}/${${${PROJECTNAME}}_LLVM_LINKER_SCRIPT}")
    add_custom_command(
        TARGET ${${PROJECTNAME}} POST_BUILD
        COMMAND ${CMAKE_SIZE} --format=berkeley $<TARGET_FILE:${${PROJECTNAME}}>
    )
    add_custom_command(
        TARGET ${${PROJECTNAME}} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O ihex
        $<TARGET_FILE:${${PROJECTNAME}}> ${${PROJECTNAME}}.hex
    )
    add_custom_command(
        TARGET ${${PROJECTNAME}} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O binary
        $<TARGET_FILE:${${PROJECTNAME}}> ${${PROJECTNAME}}.bin
    )
endfunction(setTargetLinkOptions)

# Function to convert the output to hex from axf
function(convertELF_BIN_HEX TARGET_NAME)
    add_custom_command(
        TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O ihex
        $<TARGET_FILE:${TARGET_NAME}> ${TARGET_NAME}.hex
    )
    add_custom_command(
        TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O binary
        $<TARGET_FILE:${TARGET_NAME}> ${TARGET_NAME}.bin
    )
endfunction(convertELF_BIN_HEX)
