# @libName@ Package Configuration File

# Compute the installation prefix relative to this file
get_filename_component (_@libName@_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_DIR}" PATH)
get_filename_component (_@libName@_IMPORT_PREFIX "${_@libName@_IMPORT_PREFIX}" PATH)
get_filename_component (_@libName@_IMPORT_PREFIX "${_@libName@_IMPORT_PREFIX}" PATH)

# Include the targets file
include ("${CMAKE_CURRENT_LIST_DIR}/@libName@Targets.cmake")

# Cleanup temporary variables
unset (_@libName@_IMPORT_PREFIX)

# Check that all required components have been found
if (CMAKE_VERSION VERSION_LESS 3.15)
  set (@libName@_FOUND TRUE)
else ()
  # Modern CMake has better component handling
  check_required_components (@libName@)
endif ()
