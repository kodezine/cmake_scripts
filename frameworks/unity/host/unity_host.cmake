if(EXISTS ${UNITY_PROJECT_CONFIG_FILE})
    message(STATUS "Unity: Custom configuration file used.")
    include(${UNITY_PROJECT_CONFIG_FILE})
else()
    message(STATUS "Unity: UNITY_PROJECT_CONFIG_FILE not defined.")
    message(STATUS "Unity: Default host configuration file used.")
    # include functions for generation of test runner for host
    include(${CMAKE_CURRENT_LIST_DIR}/host.cmake)
endif()
