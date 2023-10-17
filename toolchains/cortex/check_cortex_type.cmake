include(CMakePrintHelpers)
set(LIST_SUPPORTED_CORTEX_TYPE
    "CM0"
    "CM4F"
    "CM7"
)
if (NOT ($ENV{CORTEX_TYPE} IN_LIST LIST_SUPPORTED_CORTEX_TYPE))
    message(FATAL_ERROR "Define a CORTEX TYPE in just before engaging this script")
endif ()

set(CMAKE_SYSTEM_NAME Generic)

# The system processor is of the ARM family; this makes the CMSIS happy
set(CMAKE_SYSTEM_PROCESSOR arm)

# Specify toolchain postfix extension
if(WIN32)
    set(TC_POSTFIX ".exe")
endif()
