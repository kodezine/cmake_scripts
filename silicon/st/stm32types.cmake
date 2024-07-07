
# List of supported devices, add new family, device, etc. here.
set(LIST_SUPPORTED_STM32_TYPES
    "F0"
    "H7"
)

# iterate in the above list to find a match in the above list
foreach (DEVTYPE IN LISTS LIST_SUPPORTED_STM32_TYPES)
    string (TOLOWER ${DEVTYPE} devtype)
    #message ("${DEVTYPE}: ${devtype}")
    foreach (DEVICE IN LISTS LIST_SUPPORTED_STM32_DEVICE)
        #message ("${DEVICE}: ${DEVTYPE}")
        string (FIND ${DEVICE} ${DEVTYPE} testDevType)
        #message (${testDevType})
        if (${testDevType} GREATER_EQUAL "0")
            break ()
        endif ()
    endforeach ()
    if (${testDevType} GREATER_EQUAL "0")
        break ()
    endif ()
endforeach ()

# test if there is a stm32 type that is recognized from the STM32_DEVICE variable
if (${testDevType} GREATER_EQUAL "0")
    set (STM32_TYPE "${devtype}" CACHE STRING "STM32 Device type in lower case" FORCE)
    message (STATUS "${libName}: setting STM32_TYPE as ${STM32_TYPE}")
else ()
    message (FATAL_ERROR "${libName}: failed to find a compatible stm32 device type")
endif ()
