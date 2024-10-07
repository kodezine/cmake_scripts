
# Configure flasher script for the project
set(BINARY ${PROJECT_NAME}.hex)
set(FLASH_START 0x08000000)
configure_file(${CMAKE_CURRENT_LIST_DIR}/jflash.in ${CMAKE_CURRENT_BINARY_DIR}/jflash.jlink)
configure_file(${CMAKE_CURRENT_LIST_DIR}/jerase.jlink ${CMAKE_CURRENT_BINARY_DIR}/jerase.jlink)

set(BINARY ${PROJECT_NAME}_bl.hex)
# Note: The bootloader booted derivate is flashed to the same address without the bootloader offset
set(FLASH_START 0x08000000)
configure_file(${CMAKE_CURRENT_LIST_DIR}/jflash.in ${CMAKE_CURRENT_BINARY_DIR}/jflash_bl.jlink)


if(DEFINED ENV{DEBUGGER_IP})
    if($ENV{DEBUGGER_IP} STREQUAL "NO_JLINK_PRO_DEBUGGER")
        unset(DEBUGGER_IP)
    else()
        message(STATUS "JTAG Debugger IP address overwritten by environment variable)" $ENV{DEBUGGER_IP})
        set(DEBUGGER_IP $ENV{DEBUGGER_IP})
    endif()
endif()

if(DEBUGGER_IP)
    message(STATUS "Segger_JLink: JTAG TCP/IP Connection @ ${DEBUGGER_IP}")
    set(IF "ip" "${DEBUGGER_IP}")
else()
    message(STATUS "Segger_JLink: JTAG USB Connection")
    set(IF)
endif()

if(JLINK_DEVICE)
    set(DEV "${JLINK_DEVICE}")
else()
    set(DEV "STM32H743XI")
endif()

message (STATUS "Segger_JLink: ready for ${DEV}")

message(STATUS "Configure the flasher binary for host system: ${CMAKE_HOST_SYSTEM_NAME}")
if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
    set(FLASHER "JLink.exe")
else()
    set(FLASHER "JLinkExe")
endif()

# JLink flash command
add_custom_target(flash_${PROJECT_NAME}
    COMMAND ${FLASHER} ${IF} -device ${DEV} -jtagconf -1,-1 -CommanderScript ${CMAKE_CURRENT_BINARY_DIR}/jflash.jlink
    DEPENDS ${PROJECT_NAME}
)

# JLink flash command
add_custom_target(flash_${PROJECT_NAME}_bl
    COMMAND ${FLASHER} ${IF} -device ${DEV} -jtagconf -1,-1 -CommanderScript ${CMAKE_CURRENT_BINARY_DIR}/jflash_bl.jlink
    DEPENDS ${PROJECT_NAME}
)

# JLink erase command
add_custom_target(erase_${PROJECT_NAME}
    COMMAND ${FLASHER} ${IF} -device ${DEV} -jtagconf -1,-1 -CommanderScript ${CMAKE_CURRENT_BINARY_DIR}/jerase.jlink
    DEPENDS ${PROJECT_NAME}
)
