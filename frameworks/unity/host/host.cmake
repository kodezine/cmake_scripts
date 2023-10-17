include(CMakePrintHelpers)
# Function to setup project executable
function(setUnityTestProjectProperties project_name test_dir)
    # Reconfigure the unity to use this as runner for this project
    set(UNITY_TEST_RUNNER_PATH ${CMAKE_CURRENT_BINARY_DIR}/runner)
    file(MAKE_DIRECTORY ${UNITY_TEST_RUNNER_PATH})
    execute_process(
        COMMAND ruby ${CMOCK_SCRIPT_PATH}/create_runner.rb ${test_dir}/host/${project_name}.c ${UNITY_TEST_RUNNER_PATH}/${project_name}_runner.c
    )
    set(TEST_INCLUDE_DIR "${test_dir}")

    add_executable(${project_name})

    target_sources(${project_name}
        PUBLIC
            ${TEST_INCLUDE_DIR}/host/${project_name}.c
            ${UNITY_TEST_RUNNER_PATH}/${project_name}_runner.c
            ${TEST_MOCK_SOURCES}
            ${TEST_SOURCES}
    )
    target_compile_definitions(${project_name}
        PUBLIC
            UNITY_MAKE_STATIC_GLOBAL
    )

    target_include_directories(${project_name}
        PUBLIC
            $ENV{MOCK_OUT}

        PRIVATE
            ${TEST_MOCK_INCLUDES}
            ${TEST_INCLUDE_DIR}
            ${TEST_INCLUDE_DIR}/..
            ${OTHER_INCLUDE_DIR}
    )

    target_compile_options(${project_name}
        PRIVATE
            -g
            -O0
            -Wall
            -Wshadow
            -fprofile-arcs
            -ftest-coverage
    )


    target_link_options(${project_name}
        PRIVATE
            -fprofile-arcs
    )

    target_link_libraries(${project_name}
        PUBLIC
            cmock
            m #math library
    )

    set_target_properties(${project_name}
        PROPERTIES
            SUFFIX ".out"
    )

    # Register the test bin as a ctest executable test
    add_test(NAME ctest_${project_name}
        COMMAND ${project_name}.out
    )

endfunction()

# Function to setup project library
# useful for making sub-directory tests
function(setUnityTestProjectStaticLibProperties project_name test_dir)
    # Reconfigure the unity to use this as runner for this project
    set(UNITY_TEST_RUNNER_PATH ${CMAKE_CURRENT_BINARY_DIR}/runner)

    set(TEST_INCLUDE_DIR "${test_dir}")

    set(projectlib_name ${project_name}_sl)

    message(STATUS "Creating static library: ${projectlib_name}")

    add_library(${projectlib_name} STATIC)

    target_sources(${projectlib_name}
        PUBLIC
            ${TEST_MOCK_SOURCES}
            ${TEST_SOURCES}
    )
    target_compile_definitions(${projectlib_name}
        PUBLIC
            UNITY_MAKE_STATIC_GLOBAL    # Used by the compiler_attributes to expose static functions
            TESTING                     # Used by many older AO for conditional code injection/removal
    )

    target_include_directories(${projectlib_name}
        PUBLIC
            $ENV{MOCK_OUT}

        PRIVATE
            ${canopen_SOURCE_DIR}/include
            ${canopen_SOURCE_DIR}/target
            ${ql_SOURCE_DIR}/include
            ${TEST_MOCK_INCLUDES}
            ${TEST_INCLUDE_DIR}
            ${TEST_INCLUDE_DIR}/..
            ${OTHER_INCLUDE_DIR}
            ${CMAKE_SOURCE_DIR}/common/inc
            ${CMAKE_SOURCE_DIR}/common/test
            ${CMAKE_SOURCE_DIR}/AO/canopen
    )

    target_compile_options(${projectlib_name}
        PRIVATE
            -g
            -O0
            -Wall
            -Wshadow
            -fprofile-arcs
            -ftest-coverage
            -Wpedantic
    )


    target_link_options(${projectlib_name}
        PRIVATE
            -fprofile-arcs
    )

    target_link_libraries(${projectlib_name}
        PRIVATE
            mock_banshi
            mock_ql_os2
            mock_components
    )

endfunction()
