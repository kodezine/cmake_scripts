#pragma once
#include "cmsis_compiler.h"
#include <stdint.h>

/**
 * @brief This file needs to be REMOVED or MODIFIED in future once
 * the STMCubeMX starts generating startup in .c format
 * and there exists a "startup_STM32H743XX.c" file complying to
 * CMSIS Version >= 5.9
 * It should be noted that the future will see all startup assembly files
 * replaced with c files for portablity as part of CMSIS Readme
 *
 * The typedef is the only thing missing in the current implementation
 */
#ifdef __cplusplus
extern "C"
{
#endif

/**
 * @brief This constant can be removed as well
 * once things get more clear {BSP has a similar macro }
 */
#ifdef BSP_IRQ_ID_NUM
    #define VECTOR_TABLE_LENGTH (BSP_IRQ_ID_NUM)
#else
    #define VECTOR_TABLE_LENGTH (64) // based on ARM Cortex M7
#endif

/**
  \brief Exception / Interrupt Handler Function Prototype
*/
typedef void (*VECTOR_TABLE_Type)(void);

#ifdef __INITIAL_SP
    #undef __INITIAL_SP
    #define __INITIAL_SP Image$$ARM_LIB_STACKHEAP$$ZI$$Base
#endif

#ifdef __STACK_LIMIT
    #undef __STACK_LIMIT
    #define __STACK_LIMIT Image$$ARM_LIB_STACKHEAP$$ZI$$Limit
#endif
#ifdef __cplusplus
}
#endif
