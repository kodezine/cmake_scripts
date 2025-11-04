# a list of all supported stm32 devices as compile definitions in cubemx
set (
  LIST_SUPPORTED_STM32_DEVICE
  "STM32F031x6"
  "STM32F072xB"
  "STM32F303xE"
  "STM32F429xx"
  "STM32G431xx"
  "STM32G474xx"
  "STM32H7A3xxQ"
  "STM32H743xx")

# check if there exists a cache variable within the supported list
if (${STM32_DEVICE} IN_LIST LIST_SUPPORTED_STM32_DEVICE)
  message (STATUS "${libName}: ${STM32_DEVICE} is supported")
else ()
  message (FATAL_ERROR "${libName}: ${STM32_DEVICE} is yet not supported")
endif ()
