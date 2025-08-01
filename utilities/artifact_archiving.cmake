
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
