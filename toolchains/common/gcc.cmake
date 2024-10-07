# Following functions required for CMSIS to build
function(compilerVersion)
    execute_process(COMMAND "${CMAKE_C_COMPILER}" -dumpversion
        OUTPUT_VARIABLE CVERSION
        ERROR_VARIABLE CVERSION
    )
    set(COMPILERVERSION ${CVERSION} PARENT_SCOPE)
    cmake_print_variables(CVERSION)
    cmake_print_variables(CMAKE_C_COMPILER)
endfunction()

# Function to set compiler options (Private)
function(setTargetCompileOptions PROJECTNAME)
    target_compile_options( ${${PROJECTNAME}}
    PUBLIC
    # Other options
    "$<$<CONFIG:Debug>:-g3>" # optimized for maximum debug
    -fdata-sections
    -ffunction-sections
    --specs=nano.specs
    -Wl,--gc-sections
    )
endfunction(setTargetCompileOptions)

# Function to set linker options (Private)
function(setTargetLinkOptions PROJECTNAME)
    target_link_options( ${${PROJECTNAME}}
    PUBLIC
    # Compiler Options
        -g
        -Wl,-Map=${${PROJECTNAME}}.map -Xlinker --cref
        -Wl,--gc-sections
        -Wl,-z,defs
        -Wl,--print-memory-usage
        --specs=nosys.specs
        --specs=nano.specs
        #-nodefaultlibs Can Not Compile without standard libraries
        -lm
        -lc
        -lgcc
        -L${${${PROJECTNAME}}_LINKER_PATH}
        -T${${${PROJECTNAME}}_LINKER_SCRIPT}
    )
    message(STATUS "Linking with ${${${PROJECTNAME}}_LINKER_PATH}/${${${PROJECTNAME}}_LINKER_SCRIPT}")
endfunction(setTargetLinkOptions)

# Function to convert the output to hex from axf
function(convertELF_BIN_HEX TARGET_NAME)
    add_custom_command(
        TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${TARGET_NAME}>
    )
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
