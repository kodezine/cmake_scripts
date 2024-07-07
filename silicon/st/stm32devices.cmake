# a list of all supported stm32 devices as compile definitions in cubemx
set (LIST_SUPPORTED_STM32_DEVICE
    "STM32F031x6"
    "STM32F072xB"
    "STM32H7A3xxQ"
    "STM32H743xx"
)

# check if there exists a cache variable within the supported list
if (NOT ${STM32_DEVICE} IN_LIST LIST_SUPPORTED_STM32_DEVICE)
    message (FATAL_ERROR "${libName}: ${STM32_DEVICE} is yet not supported")
endif ()
