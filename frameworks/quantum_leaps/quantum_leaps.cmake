include(CMakePrintHelpers)
include(FetchContent)

set(GITHUB_BRANCH_QPC "7.2.1")
set(GITHUB_BRANCH_QPC_MD5 "08a8912195287d740818ca3a9f954c99")

cmake_print_variables(GITHUB_BRANCH_QPC)

FetchContent_Declare(
    qpc                             # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
    URL https://github.com/QuantumLeaps/qpc/archive/refs/tags/v${GITHUB_BRANCH_QPC}.tar.gz
    URL_HASH MD5=${GITHUB_BRANCH_QPC_MD5}
)

FetchContent_GetProperties(qpc)

if(NOT qpc_POPULATED)
    FetchContent_MakeAvailable(qpc)
endif()

configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeLists.cmake ${qpc_SOURCE_DIR}/CMakeLists.txt COPYONLY)

add_subdirectory(${qpc_SOURCE_DIR})
