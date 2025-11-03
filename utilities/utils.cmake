# Get all subdirectories under ${current_dir} and store them
# in ${result} variable
macro(subdirlist result current_dir)
    file(GLOB children ${current_dir}/*)
    set(dirlist "")

    foreach(child ${children})
        if (IS_DIRECTORY ${child})
            list(APPEND dirlist ${child})
        endif()
    endforeach()

    set(${result} ${dirlist})
endmacro()

# Prepend ${CMAKE_CURRENT_SOURCE_DIR} to a ${directory} name
# and save it in PARENT_SCOPE ${variable}
macro(prepend_cur_dir variable directory)
    set(${variable} ${CMAKE_CURRENT_SOURCE_DIR}/${directory})
endmacro()

# Add custom command to print firmware size in Berkley format
function(firmware_size target)
    add_custom_command(TARGET ${target}${SUFFIX} POST_BUILD
        COMMAND ${CMAKE_SIZE_UTIL} -B
        "${CMAKE_CURRENT_BINARY_DIR}/${target}${CMAKE_EXECUTABLE_SUFFIX}"
    )
endfunction()

# Add a command to generate firmare in a provided format
function(generate_object target newsuffix type)
    add_custom_command(TARGET ${target}${SUFFIX} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O${type}
        "${CMAKE_CURRENT_BINARY_DIR}/${target}${CMAKE_EXECUTABLE_SUFFIX}" "${CMAKE_CURRENT_BINARY_DIR}/${target}${newsuffix}"
    )
endfunction()

# Add a command to generate firmare listing
function(generate_lst target)
    add_custom_command(TARGET ${target}${SUFFIX} POST_BUILD
        COMMAND ${CMAKE_OBJDUMP} -St
        "${CMAKE_CURRENT_BINARY_DIR}/${target}${CMAKE_EXECUTABLE_SUFFIX}" >"${CMAKE_CURRENT_BINARY_DIR}/${target}.lst"
    )
endfunction()

function(generate_mocks mock_headers working_dir perl_sh_dir create_mocks_dir)
    file(MAKE_DIRECTORY ${working_dir})
    foreach(element IN LISTS DEBOUNCER_AO_MOCKS)
        execute_process(
            COMMAND cp ${element} ${working_dir}
        )
    endforeach()
    file(GLOB MOCKRAW  ${working_dir}/*.h)
    foreach(element IN LISTS MOCKRAW)
        execute_process(
            COMMAND sh ${perl_sh_dir}/perl.sh ${element} ${element}.tmp
        )
        execute_process(
            COMMAND mv ${element}.tmp ${element}
        )
    endforeach()

    foreach(element IN LISTS MOCKRAW)
        execute_process(
            COMMAND ruby ${create_mocks_dir}/create_mocks.rb ${element}
        )
    endforeach()

endfunction()
