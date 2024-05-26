include(CMakePrintHelpers)
include(FetchContent)

set(GITHUB_BRANCH_CANOPENNODESTM32  "HEAD")
cmake_print_variables(GITHUB_BRANCH_CANOPENNODESTM32)

FetchContent_Declare(
    canopennode_stm32                             # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
    GIT_REPOSITORY https://github.com/CANopenNode/CanOpenSTM32.git
    GIT_TAG ${GITHUB_BRANCH_CANOPENNODESTM32}
)

FetchContent_GetProperties(canopennode_stm32)

if(NOT canopennode_stm32_POPULATED)
    FetchContent_Populate(canopennode_stm32)
endif()

configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeLists.cmake ${canopennode_stm32_SOURCE_DIR}/CMakeLists.txt COPYONLY)

add_subdirectory(${canopennode_stm32_SOURCE_DIR})
