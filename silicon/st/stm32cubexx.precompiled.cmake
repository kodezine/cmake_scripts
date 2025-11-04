# tag will find the precompiled library
message (STATUS "${libName}: Precompiled tag ${PRECOMPILED_TAG_${libName}}")
fetchcontent_declare (
  ${libName} # Recommendation: Stick close to the original name.
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  URL https://github.com/kodezine/${libName}/releases/download/v${PRECOMPILED_TAG_${libName}}/${libName}-${GITHUB_BRANCH_${libName}}-${STM32_DEVICE}-${CMAKE_C_COMPILER_ID}-${CMAKE_C_COMPILER_VERSION}.tar.gz
      FIND_PACKAGE_ARGS
      NAMES
      ${libName})
fetchcontent_makeavailable (${libName})
find_package (${libName})
