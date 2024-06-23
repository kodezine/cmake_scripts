include(FetchContent)

set(GITHUB_BRANCH_CMOCK "2.5.3")
set(GITHUB_BRANCH_CMOCK_MD5 "fe3d01fdd6c267ffef38164926c7bc3d")

cmake_print_variables(GITHUB_BRANCH_CMOCK)

FetchContent_Declare(
    cmock  # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP true
    URL https://github.com/ThrowTheSwitch/CMock/archive/refs/tags/v${GITHUB_BRANCH_CMOCK}.tar.gz
    URL_HASH MD5=${GITHUB_BRANCH_CMOCK_MD5}
)

FetchContent_GetProperties(cmock)

if(NOT cmock_POPULATED)
    FetchContent_MakeAvailable(cmock)

    configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeLists.cmake ${cmock_SOURCE_DIR}/CMakeLists.txt)
    # Library libcomock.a is in the /build/_deps/cmock-build directory
    add_subdirectory(${cmock_SOURCE_DIR} ${cmock_BINARY_DIR})
endif()

# establish CMOCK environment
set(ENV{CMOCK_DIR} ${cmock_SOURCE_DIR})
set(CMOCK_SCRIPT_PATH $ENV{CMOCK_DIR}/scripts)
set(CMOCK_LIB_PATH $ENV{CMOCK_DIR}/lib)
