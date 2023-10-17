#include <stdint.h>
#include "targetbasedincludes.h"
#include "vectors.h"
#include "cmsis_compiler.h"
/******************************************************************************
 * @file     startup_<Device>.c
 * @brief    CMSIS-Core(M) Device Startup File for
 *           Device <Device>
 * @version  V1.0.0
 * @date     20. January 2021
 ******************************************************************************/
/*
 * Copyright (c) 2009-2021 Arm Limited. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the License); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an AS IS BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*---------------------------------------------------------------------------
  External References
 *---------------------------------------------------------------------------*/
extern uint32_t __INITIAL_SP;
extern uint32_t __STACK_LIMIT;

#if defined(__ARM_FEATURE_CMSE) && (__ARM_FEATURE_CMSE == 3U)
extern uint32_t __STACK_SEAL;
#endif

extern __NO_RETURN void __PROGRAM_START(void);

/*---------------------------------------------------------------------------
  Internal References
 *---------------------------------------------------------------------------*/
__NO_RETURN void Reset_Handler(void);
__NO_RETURN void Default_Handler(void);

/* ToDo: Add Cortex exception handler according the used Cortex-Core */
/*---------------------------------------------------------------------------
  Exception / Interrupt Handler
 *---------------------------------------------------------------------------*/
/* Exceptions */
void NMI_Handler                      (void) __attribute__((weak, alias("Default_Handler")));
void HardFault_Handler                (void) __attribute__((weak));
void MemManage_Handler                (void) __attribute__((weak, alias("Default_Handler")));
void BusFault_Handler                 (void) __attribute__((weak, alias("Default_Handler")));
void UsageFault_Handler               (void) __attribute__((weak, alias("Default_Handler")));
// void SecureFault_Handler                (void) __attribute__ ((weak, alias("Default_Handler")));
// void SecureFault_Handler                (void) __attribute__ ((weak, alias("Default_Handler")));
// void SecureFault_Handler                (void) __attribute__ ((weak, alias("Default_Handler")));
// void SecureFault_Handler                (void) __attribute__ ((weak, alias("Default_Handler")));
void SVC_Handler                      (void) __attribute__((weak, alias("Default_Handler")));
void DebugMon_Handler                 (void) __attribute__((weak, alias("Default_Handler")));
// void SecureFault_Handler              (void) __attribute__ ((weak, alias("Default_Handler")));
void PendSV_Handler                   (void) __attribute__((weak, alias("Default_Handler")));
void SysTick_Handler                  (void) __attribute__((weak, alias("Default_Handler")));

/* Add your device specific interrupt handler */
/*---------------------------------------------------------------------------
  ISR
 *---------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
  Exception / Interrupt Vector table
 *----------------------------------------------------------------------------*/

#if defined(__GNUC__)
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
#endif

/* ToDo: Add Cortex exception vectors according the used Cortex-Core */
extern const VECTOR_TABLE_Type __VECTOR_TABLE[32];
const VECTOR_TABLE_Type __VECTOR_TABLE[32] __VECTOR_TABLE_ATTRIBUTE = {
    (VECTOR_TABLE_Type)(&__INITIAL_SP)                    , /*     Initial Stack Pointer */
    (VECTOR_TABLE_Type)&Reset_Handler                     , /*     Reset Handler */
    (VECTOR_TABLE_Type)&NMI_Handler                       , /* -14 NMI Handler */
    (VECTOR_TABLE_Type)&HardFault_Handler                 , /* -13 Hard Fault Handler */
    (VECTOR_TABLE_Type)&MemManage_Handler                 , /* -12 MPU Fault Handler */
    (VECTOR_TABLE_Type)&BusFault_Handler                  , /* -11 Bus Fault Handler */
    (VECTOR_TABLE_Type)&UsageFault_Handler                , /* -10 Usage Fault Handler */
    (VECTOR_TABLE_Type)0                                  , /*  -9 Secure Fault Handler */
    (VECTOR_TABLE_Type)0                                  , /*     Reserved */
    (VECTOR_TABLE_Type)0                                  , /*     Reserved */
    (VECTOR_TABLE_Type)0                                  , /*     Reserved */
    (VECTOR_TABLE_Type)&SVC_Handler                       , /*  -5 SVCall Handler */
    (VECTOR_TABLE_Type)&DebugMon_Handler                  , /*  -4 Debug Monitor Handler */
    (VECTOR_TABLE_Type)0                                  , /*     Reserved */
    (VECTOR_TABLE_Type)&PendSV_Handler                    , /*  -2 PendSV Handler */
    (VECTOR_TABLE_Type)&SysTick_Handler                   , /*  -1 SysTick Handler */
};

#if defined(__GNUC__)
#pragma GCC diagnostic pop
#endif

/*---------------------------------------------------------------------------
  Reset Handler called on controller reset
 *---------------------------------------------------------------------------*/
__NO_RETURN void Reset_Handler(void)
{
    __set_PSP((uint32_t)(&__INITIAL_SP));

/* ToDo: Initialize stack limit register for Armv8-M Main Extension based processors*/
//    __set_MSP((uint32_t)(&__STACK_LIMIT));
//    __set_PSP((uint32_t)(&__STACK_LIMIT));

/* ToDo: Add stack sealing for Armv8-M based processors */
#if defined(__ARM_FEATURE_CMSE) && (__ARM_FEATURE_CMSE == 3U)
    __TZ_set_STACKSEAL_S((uint32_t *)(&__STACK_SEAL));
#endif

    SystemInit();      /* CMSIS System Initialization */
    __PROGRAM_START(); /* Enter PreMain (C library entry point) */
}

#if defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6010050)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-noreturn"
#endif

/*---------------------------------------------------------------------------
  Hard Fault Handler
 *---------------------------------------------------------------------------*/
void HardFault_Handler(void)
{
    while (1)
        ;
}

/*---------------------------------------------------------------------------
  Default Handler for Exceptions / Interrupts
 *---------------------------------------------------------------------------*/
void Default_Handler(void)
{
    while (1)
        ;
}

#if defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6010050)
#pragma clang diagnostic pop
#endif
