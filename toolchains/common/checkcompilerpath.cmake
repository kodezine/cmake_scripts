# Specify location of toolchain root folder
message (CHECK_START "Searching for COMPILER_ROOT_PATH")
if (NOT EXISTS "$ENV{COMPILER_ROOT_PATH}")
  message (CHECK_FAIL "not found.")
  message (FATAL_ERROR "No valid compiler for this toolchain found, aborting!")
else ()
  message (CHECK_PASS "found ... \"$ENV{COMPILER_ROOT_PATH}\"")
endif ()
