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

/**
  \brief System Clock Frequency (Core Clock)
*/
extern uint32_t SystemCoreClock;

/**
  \brief Setup the microcontroller system.

   Initialize the System and update the SystemCoreClock variable.
 */
extern void SystemInit(void);
#ifndef __PROGRAM_START

/**
  \brief   Initializes data and bss sections
  \details This default implementations initialized all data and additional bss
           sections relying on .copy.table and .zero.table specified properly
           in the used linker script.
 */
__STATIC_FORCEINLINE __NO_RETURN void __cmsis_start(void)
{
    extern void _start(void) __NO_RETURN;

    typedef struct __copy_table
    {
        uint32_t const* src;
        uint32_t*       dest;
        uint32_t        wlen;
    } __copy_table_t;

    typedef struct __zero_table
    {
        uint32_t* dest;
        uint32_t  wlen;
    } __zero_table_t;

    extern const __copy_table_t __copy_table_start__;
    extern const __copy_table_t __copy_table_end__;
    extern const __zero_table_t __zero_table_start__;
    extern const __zero_table_t __zero_table_end__;

    for (__copy_table_t const* pTable = &__copy_table_start__; pTable < &__copy_table_end__; ++pTable)
    {
        for (uint32_t i = 0u; i < pTable->wlen; ++i)
        {
            pTable->dest[i] = pTable->src[i];
        }
    }

    for (__zero_table_t const* pTable = &__zero_table_start__; pTable < &__zero_table_end__; ++pTable)
    {
        for (uint32_t i = 0u; i < pTable->wlen; ++i)
        {
            pTable->dest[i] = 0u;
        }
    }

    _start();
}

    #define __PROGRAM_START __cmsis_start
#endif

#ifndef __INITIAL_SP
    #define __INITIAL_SP __StackTop
#endif

#ifndef __STACK_LIMIT
    #define __STACK_LIMIT __StackLimit
#endif

#ifndef __VECTOR_TABLE
    #define __VECTOR_TABLE __Vectors
#endif

#ifndef __VECTOR_TABLE_ATTRIBUTE
    #define __VECTOR_TABLE_ATTRIBUTE __attribute__((used, section(".vectors")))
#endif

/**
  \brief  Update SystemCoreClock variable.

   Updates the SystemCoreClock with current core Clock retrieved from cpu registers.
 */
extern void SystemCoreClockUpdate(void);

#ifdef __cplusplus
}
#endif
