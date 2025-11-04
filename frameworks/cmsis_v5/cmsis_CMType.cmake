# we check if the Cortex M cpu is available with us in CMSIS 5 we use the CORTEX_TYPE to determine CMSIS_V5_CORTEX_TYPE
# This is from the relative path CMSIS_V5/Device/ARM/ARMxxx
set (
  LIST_OF_ALL_CMSIS_CORTEX_TYPES
  "ARMCA5"
  "ARMCA7"
  "ARMCA9"
  "ARMCM0"
  "ARMCM0plus"
  "ARMCM1"
  "ARMCM3"
  "ARMCM4"
  "ARMCM7"
  "ARMCM23"
  "ARMCM33"
  "ARMCM35P"
  "ARMCM55"
  "ARMCM85"
  # exclude other which are non Cortex cores
)

# set string to represent one of the above patterns
string (TOUPPER $ENV{CORTEX_TYPE} CORTEX_TYPE_UPPERCASE)
# CM4F is within CM4 so rename this type
if (CORTEX_TYPE_UPPERCASE STREQUAL "CM4F")
  set (CORTEX_TYPE_UPPERCASE "CM4")
endif ()
# Add ARM prefix
set (CMSIS_V5_CORTEX_TYPE_STRING "ARM${CORTEX_TYPE_UPPERCASE}")

if (${CMSIS_V5_CORTEX_TYPE_STRING} IN_LIST LIST_OF_ALL_CMSIS_CORTEX_TYPES)
  set (
    CMSIS_V5_ARM_DEVICE
    ${CMSIS_V5_CORTEX_TYPE_STRING}
    CACHE STRING "String to store the CMSIS V5 ARM Cortex Device type" FORCE)
  message (STATUS "${libName}: Device is ${CMSIS_V5_ARM_DEVICE}")
else ()
  message (FATAL_ERROR "${libName}: Device is not in directory of CMSIS V5")
endif ()
