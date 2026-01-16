#pragma once
#if defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6100100)
    #include "vectors_ac6.h"
#elif defined(__GNUC__)
    #if defined(__clang__)
        #include "vectors_llvm.h"
    #else
        #include "vectors_gcc.h"
    #endif
#endif
