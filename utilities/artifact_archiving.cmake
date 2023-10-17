# Copyright 2022, Baxter
#
# This cmake file provides tooling and an implemented policy/convention
# to identify build artifacts by file name as precise as possible by name
#
# The build artifact shall reveal
#
# - the the project, purpose and context of the artifact (name, variants)
#   - Mandatory name that uniquely refers to the project, purpose and context
#   - Optional boot (-bl = with bootloader extension)
#   - Optional purpose (demo, test, ...)
#   - Optional feature toggles
# - artifact format (elf, hex, bin, ...)
# - Compiler used for building (like gcc, )
# - Build variant (debug, release)
# - Reference to build source (like git-sha1)
#
# # Policy/Convention
#
# The artifact file name shall follow the industry established pattern
#
#   <artifact description>_<revision identification>.<format identification>
#
# In general the omission method if production-default is used. E.g.:
# - if the armclang compiler shall be used to build the artifafact intended
#   to be deployed in production environment the compiler is omitted.
# - if the armgcc compiler is used the "-gcc" sub-identifier is part of the
#   artifact description
#
# This leads to shorter artifact file names towards production and encuorages
# usage of artifacts that are close to production, while at the same time
# revealing as much as possible information about the artifact just by file name.
#
# ## Artifact description
#
# Is composed of parts in lower case letters and digits.
# The parts are separated by "-" signt
#
# `prefix-base-postfix`
#
# Prefix part:
# - 'demo' for demonstration
# - 'test' for automated testing
# - empty  for production use cases
#
# Base part:
# - is injected as variable APP
# - could be consist of sub parts (again separated by "-") e.g. "mk3-app", "mk3-boot"
#
# Postfix parts:
# - Compiler: armgcc = 'gcc'; armclang => omitted
# - Build variant: debug = 'dg'; release => omittted
# - Code start variant: start by bootloader => 'bl' !!! exception from omission for production default;
#   start without bootloader => omitted
#
# ## Revision identification
#
# The revision identification is composed by the following parts
#
# - upstream reference: static => omitted, guarded => 'guard'; fluid => 'fluid'
# - git reference: (output of `git describe --all`) of the main repo
# - build reference: "build number" if build by CI authority; 'dirty' if build on a developer machine,
#   (Injected by BUILD_NUMBER variable)
#
# ## Format indentification
#
# - 'elf' - Executable and Linking Format, used by the debugger
# - 'hex' - Intel Hex format for flashing
# - 'bin' - Baxter Proprietary bininary format created by binary block converter
#
find_package(Git QUIET REQUIRED)

set( UPSTREAM_DEP "fluid" CACHE STRING "Indicate upstream dependency" )
set( BUILD_ENV_REF "dirty" CACHE STRING "Indicate local or ci build environment")

function(determine_artifact_full_name OUTPUT_VAR APP_NAME UPSTREAM_DEP BUILD_ENV_REF)
    # Determine build type
    if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
        set(BUILD_TYPE "-dbg")
    else()
        # Release build
        set(BUILD_TYPE "")
    endif()
    if (CMAKE_CXX_COMPILER_ID STREQUAL "ARMClang")
        set(COMP_NAME "")
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(COMP_NAME "-gcc")
    else()
        set(COMP_NAME "-anycc")
    endif()
    set(ARTIFACT_NAME ${APP_NAME}${BUILD_TYPE}${COMP_NAME})

    # Determine Version
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" describe --always HEAD
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        RESULT_VARIABLE res
        OUTPUT_VARIABLE GIT_DESCRIBE
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE)
    if ( ${UPSTREAM_DEP} STREQUAL "guarded" )
        set(UPSTREAM_REF "-guard" )
    elseif ( ${UPSTREAM_DEP} STREQUAL "static" )
        set(UPSTREAM_REF "")
    else()
        # is fluid or someting else
        set(UPSTREAM_REF "-fluid")
    endif()
    set(VERSION_IDENTIFICATION "${GIT_DESCRIBE}${UPSTREAM_REF}-${BUILD_ENV_REF}")

    # message( STATUS "Artifact ${ARTIFACT_NAME} version ${VERSION_IDENTIFICATION}")
    set ( ${OUTPUT_VAR} "${ARTIFACT_NAME}_${VERSION_IDENTIFICATION}" PARENT_SCOPE)

endfunction()

function(createNamedArtifacts target basename)
    determine_artifact_full_name ( FULL_ARTIFACT_BASE_NAME ${basename}  ${UPSTREAM_DEP} ${BUILD_ENV_REF} )
    message( STATUS "Build artifact qualified name ${FULL_ARTIFACT_BASE_NAME}")
    add_custom_command( TARGET TARGET ${target}${SUFFIX} POST_BUILD
        COMMAND ${CMAKE_COMMAND} ARGS -E copy "${CMAKE_CURRENT_BINARY_DIR}/${target}.elf" "${CMAKE_CURRENT_BINARY_DIR}/${FULL_ARTIFACT_BASE_NAME}.elf"
        COMMAND ${CMAKE_COMMAND} ARGS -E copy "${CMAKE_CURRENT_BINARY_DIR}/${target}.hex" "${CMAKE_CURRENT_BINARY_DIR}/${FULL_ARTIFACT_BASE_NAME}.hex"
        )
endfunction()
