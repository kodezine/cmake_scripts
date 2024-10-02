# Cross Compilation Toolchains

This collection includes a basic cross compiler collection support:
1. [ARM Compiler Version 6](https://developer.arm.com/Tools%20and%20Software/Arm%20Compiler%20for%20Embedded)
    * Clang based `armclang` compiler.
    * for a paid licensed compiler, toolchain script to be used is [here](./armclang.cmake).
    * for a community licensed compiler, toolchain script to be used is [here](./armclang-community.cmake).
2. [ARM GNU Toolchain](https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain)
    * popular `arm-none-eabi-*`
    * supports also the older [version](https://developer.arm.com/downloads/-/gnu-rm).
    * toolchain script to be used is [here](./arm-none-eabi-gcc.cmake)
3. [LLVM Embedded Toolchain for ARM](https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm)
    * toolchain script to be used is [here](./llvm-clang-arm.cmake)
4. [LLVM - GCC Hybrid](https://interrupt.memfault.com/blog/arm-cortexm-with-llvm-clang#update-clang-baremetal)
    * may fail to work, it's reaching end-of-life.
    * toolchain script to be used is [here](./llvm-clang-gcc.cmake)
## How to Use the toolchains
Please specify the environment variable for `COMPILER_ROOT_PATH` to point to the toolchain directory.
```json
    "configurePresets": [
        {
            "hidden": true,
            "name": "llvm",
            "environment": {
                "COMPILER_ROOT_PATH": "$env{HOME}/llvm_arm"
            },
            "cacheVariables": {
                "GITHUB_BRANCH_toolchain": "HEAD",
                "CMAKE_TOOLCHAIN_FILE": "${sourceDir}/_deps/cmake_scripts-src/toolchains/llvm_clang_arm.cmake"
            }
        },
    ...
    ]
```
