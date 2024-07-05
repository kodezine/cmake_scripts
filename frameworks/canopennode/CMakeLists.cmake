## Minimum version for cmake compatiblity

include(CMakePrintHelpers)
include(FetchContent)

project(
    canopennode-stm32
    VERSION     0.0.1
    LANGUAGES   C ASM CXX
    DESCRIPTION "CANopen node implementation for STM32 based controllers"
)

set(libName canopennode-stm32)
if(NOT DEFINED STM32_BOARD_TYPE)
    message(FATAL_ERROR "${libName} CAN Node needs STM32_BOARD_TYPE to work, e.g. stm32f072rb_disco")
endif()
if(NOT EXISTS ${CANOPEN_OBJECT_DICTIONARY_PATH})
    message(FATAL_ERROR "${libName} CAN-not work without a object dictionary, quiting with pain.")
endif()

set(libName ${libName})
message(STATUS "Building ${libName} with STM32${STM32_TYPE} family board ${STM32_BOARD_TYPE}.a static library")
add_library(${libName} STATIC)

target_sources(${libName}
    PRIVATE
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_Emergency.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_fifo.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_HBconsumer.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_NMT_Heartbeat.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_ODinterface.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_PDO.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_SDOclient.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_SDOserver.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_SYNC.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_TIME.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/crc16-ccitt.c

    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/303/CO_LEDs.c

    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/304/CO_GFC.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/304/CO_SRDO.c

    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/305/CO_LSSmaster.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/305/CO_LSSslave.c

    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/309/CO_gateway_ascii.c

    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/extra/CO_trace.c

    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/storage/CO_storage.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/storage/CO_storageEeprom.c

    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/CANopen.c

    ${canopennode-stm32_SOURCE_DIR}/CANopenNode_STM32/CO_app_STM32.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode_STM32/CO_driver_STM32.c
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode_STM32/CO_storageBlank.c
)

target_include_directories(${libName}
    PUBLIC
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/303
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/304
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/305
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/309
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/extra
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode/storage
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode_STM32
)

target_link_libraries(${libName}
    ${STM32_BOARD_TYPE}
)
setTargetCompileOptions(libName)

set(libName canopennode-od)
message(STATUS "Building ${libName} with object dictionary at ${CANOPEN_OBJECT_DICTIONARY_PATH}")
add_library(${libName} STATIC)

target_sources(${libName}
    PRIVATE
    ${CANOPEN_OBJECT_DICTIONARY_PATH}/OD.c
)

target_include_directories(${libName}
    PUBLIC
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode
    ${canopennode-stm32_SOURCE_DIR}/CANopenNode_STM32
    ${CANOPEN_OBJECT_DICTIONARY_PATH}
)

target_link_libraries(${libName}
    canopennode-stm32
)
setTargetCompileOptions(libName)
