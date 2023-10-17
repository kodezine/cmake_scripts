

# This cmake code injects preprocessor defines to
# define software versions for CANOpen Objects at build time
#
# The versions are derived from git tags of the TS7x_MotorController_MK3 or TS7x_Bootloader_MK3
# repository. Thus, in case of an isolated build of this repository,
# the build must not fail because of the absence of certain #defines
function(setFirmwareVersion)

    find_package(Git QUIET REQUIRED)
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" describe --always HEAD
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        RESULT_VARIABLE res
        OUTPUT_VARIABLE GIT_VERSION_OUTPUT
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE)

    set_property(GLOBAL APPEND
        PROPERTY CMAKE_CONFIGURE_DEPENDS
        "${CMAKE_SOURCE_DIR}/.git/index")

    # temporary for testing
    string(REGEX REPLACE "^([0-9]+)\\.([0-9]+)\\.([0-9]+)\\.([0-9]+).*$"
    "\\1;\\2;\\3;\\4" _ver_parts "${GIT_VERSION_OUTPUT}")
    # Cover the case that git describe does return for a "validly" tagged git repo
    # make sure we do not end up in cmake index error
    list(LENGTH _ver_parts _length)
    if ( _length EQUAL 4)
        list(GET _ver_parts 0 MAJOR_VERSION)
        list(GET _ver_parts 1 MINOR_VERSION)
        list(GET _ver_parts 2 PATCH_VERSION)
        list(GET _ver_parts 3 BUILD_LEVEL)
    else()
        set(MAJOR_VERSION "0")
        set(MINOR_VERSION "0")
        set(PATCH_VERSION "0")
        set(BUILD_LEVEL "0")
    endif()

    message(STATUS "Software version: ${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.${BUILD_LEVEL} (obtained from last git tag)")

    add_definitions(-DMAJOR_VERSION=${MAJOR_VERSION})
    add_definitions(-DMINOR_VERSION=${MINOR_VERSION})
    add_definitions(-DPATCH_VERSION=${PATCH_VERSION})
    add_definitions(-DBUILD_LEVEL=${BUILD_LEVEL})

endfunction()
