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
        -xc
        -D__MICROLIB
        -c
        -fno-rtti
        -funsigned-char
        -fshort-enums
        -fshort-wchar
        -masm=auto
        -gdwarf-4                                   # defaulting to legacy debug tables for armgdb debuggers
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
        -Wno-license-management
        -Wno-parentheses-equality
        -Wno-reserved-identifier
        "$<$<CONFIG:Debug>:-O1>"                    # Optimized for debugging
    )
endfunction(setTargetCompileOptions)

# Function to set linker options (Private)
function(setTargetLinkOptions PROJECTNAME)
    target_link_options( ${${PROJECTNAME}}
        PUBLIC
        --cpu ${ac6_link_flag}
        --library_type=microlib
        --strict
        "$<$<CONFIG:Debug>:--bestdebug>"            # Debug symbols
        "$<$<CONFIG:Release>:--no_debug>"           # No Debug symbols
        --scatter ${${${PROJECTNAME}}_SCATTER_PATH}/${${${PROJECTNAME}}_SCATTER_FILE}
        --summary_stderr
        --info common,debug,sizes,totals,veneers,unused,summarysizes
    )
    message(STATUS "Linking with ${${${PROJECTNAME}}_SCATTER_PATH}/${${${PROJECTNAME}}_SCATTER_FILE}")
endfunction(setTargetLinkOptions)

# Function to convert the output to hex from axf
function(convertELF_BIN_HEX target)
    add_custom_command(TARGET ${target}${SUFFIX} POST_BUILD
        COMMAND ${TC_ELF_EXEC} --bincombined -v --output "${CMAKE_CURRENT_BINARY_DIR}/${target}.bin" "${CMAKE_CURRENT_BINARY_DIR}/${target}.elf"
        COMMAND ${TC_ELF_EXEC} --i32combined -v --output "${CMAKE_CURRENT_BINARY_DIR}/${target}.hex" "${CMAKE_CURRENT_BINARY_DIR}/${target}.elf"
        COMMAND ${TC_ELF_EXEC} -s -v "${CMAKE_CURRENT_BINARY_DIR}/${target}.elf" > "${target}.txt"
    )
endfunction(convertELF_BIN_HEX)
