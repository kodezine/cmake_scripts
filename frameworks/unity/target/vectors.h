/**
 * @file vectors.h
 * @author Sohal Patel (sohal@kodezine.com)
 * @brief This file is the basic FIQ NVIC vectors for getting the unity framework
 * on the target cortex m hardware
 * @version 0.1
 * @date 2023-09-17
 * @copyright Copyright (c) 2023
 * MIT license
 */
#ifndef VECTORS_H
#define VECTORS_H
#ifdef __cplusplus
extern "C" {
#endif

#if defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6100100)
    //#include "__vectors_ac6.h"
    #error ac6 vectors not supported yet
#elif defined(__GNUC__)
    #if defined(__clang__)
        #include "llvm_clang/vectors_llvm.h"
    #else
        //#include "__vectors_gcc.h"
        #error gcc vectors not supported yet
    #endif
#endif

#ifdef __cplusplus
}
#endif
#endif //VECTORS_H
