# Minimum version for cmake compatiblity
include (CMakePrintHelpers)
include (FetchContent)

project (
  qpc
  VERSION 0.0.1
  LANGUAGES C ASM CXX
  DESCRIPTION "CANopen node implementation for STM32 based controllers")
# Extract information for QPC framework
if (CMAKE_C_COMPILER_ID STREQUAL "ARMClang" OR CMAKE_C_COMPILER_ID STREQUAL "Clang")
  set (
    QPC_COMPILER_NAME
    "armclang"
    CACHE STRING "QPC port directory based on armclang compiler")
elseif (CMAKE_C_COMPILER_ID STREQUAL "GNU")
  set (
    QPC_COMPILER_NAME
    "gnu"
    CACHE STRING "QPC port directory based on gnu c compiler")
else ()
  message (FATAL_ERROR "QPC can not be integrated with this compiler...")
endif ()

if (QPC_TYPE STREQUAL "QK")
  message (STATUS "${QPC_TYPE} is for QK type work")
elseif (QPC_TYPE STREQUAL "QV")
  message (STATUS "${QPC_TYPE} is for QV type work")
elseif (QPC_TYPE STREQUAL "QXK")
  message (STATUS "${QPC_TYPE} is for QXK type work")
else ()
  set (QPC_TYPE "QK")
  message (STATUS "${QPC_TYPE} is for QK type work")
endif ()

cmake_print_variables (QPC_COMPILER_NAME)
if (NOT DEFINED qpc_SOURCE_DIR)
  message (FATAL_ERROR "QPC Framework not downloaded.")
endif ()

cmake_print_variables (qpc_SOURCE_DIR)

set (
  qpc_qf_SOURCES
  ${qpc_SOURCE_DIR}/src/qf/qep_hsm.c
  ${qpc_SOURCE_DIR}/src/qf/qep_msm.c
  ${qpc_SOURCE_DIR}/src/qf/qf_act.c
  ${qpc_SOURCE_DIR}/src/qf/qf_actq.c
  ${qpc_SOURCE_DIR}/src/qf/qf_defer.c
  ${qpc_SOURCE_DIR}/src/qf/qf_dyn.c
  ${qpc_SOURCE_DIR}/src/qf/qf_mem.c
  ${qpc_SOURCE_DIR}/src/qf/qf_ps.c
  ${qpc_SOURCE_DIR}/src/qf/qf_qact.c
  ${qpc_SOURCE_DIR}/src/qf/qf_qeq.c
  ${qpc_SOURCE_DIR}/src/qf/qf_qmact.c
  ${qpc_SOURCE_DIR}/src/qf/qf_time.c)

set (qpc_qk_SOURCES ${qpc_SOURCE_DIR}/src/qk/qk.c)

set (
  qpc_qs_SOURCES
  ${qpc_SOURCE_DIR}/src/qs/qs.c
  # ${qpc_SOURCE_DIR}/src/qs/qs_64bit.c
  ${qpc_SOURCE_DIR}/src/qs/qs_fp.c
  ${qpc_SOURCE_DIR}/src/qs/qs_rx.c
  # ${qpc_SOURCE_DIR}/src/qs/qstamp.c ${qpc_SOURCE_DIR}/src/qs/qutest.c
)

set (qpc_qv_SOURCES ${qpc_SOURCE_DIR}/src/qv/qv.c)

set (qpc_qxk_SOURCES ${qpc_SOURCE_DIR}/src/qxk/qxk.c ${qpc_SOURCE_DIR}/src/qxk/qxk_mutex.c
                     ${qpc_SOURCE_DIR}/src/qxk/qxk_sema.c ${qpc_SOURCE_DIR}/src/qxk/qxk_xthr.c)

set (qpc_ports_qk_PATH "${qpc_SOURCE_DIR}/ports/arm-cm/qk/${QPC_COMPILER_NAME}")
set (qpc_ports_arm-cm_qk_SOURCES ${qpc_ports_qk_PATH}/qk_port.c)

add_library (${PROJECT_NAME} STATIC)

target_sources (${PROJECT_NAME} PRIVATE ${qpc_qf_SOURCES} ${qpc_qk_SOURCES} ${qpc_ports_arm-cm_qk_SOURCES})

target_include_directories (${PROJECT_NAME} PRIVATE ${qpc_ports_qk_PATH})

target_include_directories (${PROJECT_NAME} SYSTEM PUBLIC $<BUILD_INTERFACE:${qpc_SOURCE_DIR}/include>
                                                          $<BUILD_INTERFACE:${qpc_SOURCE_DIR}/ports/arm-cm/qk/gnu>)

# Add target compile options based on toolchain
set (libName ${PROJECT_NAME})
settargetcompileoptions (libName)
