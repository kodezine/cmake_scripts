/**
 * @file vectors_llvm.h
 * @author Sohal (sohal@kodezine.com)
 * @brief File that has llvm clang based CMSIS adaptations
 * @version 0.1
 * @date 2023-09-17
 *
 * @copyright Copyright (c) 2023
 * MIT license
 */

#ifndef VECTORS_LLVM
#define VECTORS_LLVM
#ifdef __cplusplus
extern "C"
{
#endif
#include <stdint.h>
/**
  \brief Exception / Interrupt Handler Function Prototype
*/
typedef void (*VECTOR_TABLE_Type)(void);
#ifndef __PROGRAM_START
    #define __PROGRAM_START _start
#endif

#ifndef __StackTop
    #define __StackTop __stack
#endif //__StackTop

#ifndef __StackLimit
    #define __StackLimit __stack_size
#endif //__StackLimit
#ifndef __VECTOR_TABLE
    #define __VECTOR_TABLE __Vectors
#endif

#ifndef __VECTOR_TABLE_ATTRIBUTE
    #define __VECTOR_TABLE_ATTRIBUTE __attribute__((used, section(".vectors")))
#endif

#ifndef __INITIAL_SP
    #define __INITIAL_SP __StackTop
#endif

#ifndef __STACK_LIMIT
    #define __STACK_LIMIT __StackLimit
#endif

#ifndef weak
    #define weak __weak__
#endif

#ifndef alias
    #define alias __alias__
#endif

#ifdef __cplusplus
}
#endif
#endif // VECTORS_LLVM
