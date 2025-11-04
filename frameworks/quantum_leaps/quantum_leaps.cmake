include (CMakePrintHelpers)
include (FetchContent)

set (libName "qpc")

set (GITHUB_BRANCH_${libName} "7.2.1")
set (GITHUB_BRANCH_${libName}_MD5 "08a8912195287d740818ca3a9f954c99")

message (STATUS "${libName}: ${GITHUB_BRANCH_${libName}}")

fetchcontent_declare (
  ${libName} # Recommendation: Stick close to the original name.
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  URL https://github.com/QuantumLeaps/${libName}/archive/refs/tags/v${GITHUB_BRANCH_${libName}}.tar.gz
  URL_HASH MD5=${GITHUB_BRANCH_${libName}_MD5})

fetchcontent_getproperties (${libName})

if (NOT ${libName}_POPULATED)
  fetchcontent_makeavailable (${libName})
endif ()

configure_file (${CMAKE_CURRENT_LIST_DIR}/CMakeLists.cmake ${${libName}_SOURCE_DIR}/CMakeLists.txt COPYONLY)

add_subdirectory (${${libName}_SOURCE_DIR})
