# CMSIS version 5 from ARM
This folder contains recepie to use ARM CMSIS v5 library with cmake.
The options to use this library is
a. Bring raw sources from GitHub repository from ARM
b. Bring precompiled package from GitHub repository from Kodezine

## Library Name and Specifications
The `${libName}` is `cmsis_v5` all in lower cases.
The library version is the ARM GitHub version without the `v`, i.e.
| Repo Tag | CMake Variable Name | Variable Value |
| -- | -- | -- |
| `v5.9.0` | `GITHUB_BRANCH_${libName}` | `5.9.0` |

## Usage
### Build from sources
#### Steps
1. Provide a valid value of `GITHUB_BRANCH_cmsis_v5` as described above.`
#### Example
```cmake
# setup the cmsis version
set(GITHUB_BRANCH_cmsis_v5 "5.9.0" CACHE STRING "String value for cmsis version 5")
# include the script for using cmsis
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_cmsis_v5.cmake)
```
### Use precompiled tag
#### Steps
1. Provide a valid value of `GITHUB_BRANCH_cmsis_v5` as described above.`
2. Set the variable `PRECOMPILED_TAG_cmsis_v5` to a valid tag value to the precompiled releases.
#### Example
```cmake
# setup the cmsis version
set(GITHUB_BRANCH_cmsis_v5 "5.9.0" CACHE STRING "String value for cmsis version 5")
# setup the precompiled lib
set(PRECOMPILED_TAG_cmsis_v5 "0.1.1" CACHE STRING "String value for cmsis version 5 precompiled tag")
# include the script for using cmsis
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_cmsis_v5.cmake)
```
### CMake Variable Exports
The library provides the interface to the library with following variables

| CMake Variable | Value |
| -- | -- |
| `cmsis_v5_CORE_INCLUDE_PATH` | Path to the Core include directory |
| `cmsis_v5_DEVICE_INCLUDE_DIR` | Path to the Devic include directory |
