# How To Use the provided toolchains

This folder contains files for toolchains, both common and specific.

## Common Functions in each toolchain

The following is a list of common cmake functions in each toolchain. Future toolchains are obliged to have these as well.

### `showCompilerVersion`

* This function runs an executable command that determines the compiler version.

### `setTargetCompileOptions`

* This function takes one arguement PROJECTNAME that should decompose into real cross compiled `TARGET`, which can be a static library or an executable.
* This function sets the compiler dependent `target_compile_options` and makes them `PUBLIC`.

### `setTargetLinkOptions`

* This function takes one arguement PROJECTNAME that should decompose into real cross compiled `TARGET`, which is an executable.
* This function sets the compiler dependent `target_link_options` and makes them `PUBLIC`.
* This function requires the linking details like file path and filename.

### `convertELF_BIN_HEX`

* This function sets an `add_custom_command` to set various target formats of an executable `TARGET`. Popular formats are elf, bin and hex.

## Description of files

### [ac6.cmake](./ac6.cmake)

This file is used for all `armclang` based toolchains.

#### Settings given

These are the list of various setting that are set/given by this script.

| Name | Type | Value |
| -- | -- | -- |
| `COMPILERVERSION` | string | Value of the compiler version as string |
| `-std` | string | Value of the C/C++ standard for this compiler for compilation |

#### Configuration required

These are the list of various settings/configuration required by the script to function.

| Name | Type | Value |
| -- | -- | -- |
| `--cpu` | string | Value of cortex cpu types defined in [cortex types](./../cortex/cortexTypes.md) for linking |
| `--scatter` | string | Value of scatter file and path to file in format of `${TARGETNAME}_SCATTER_FILE` and `${TARGETNAME}_SCATTER_PATH` respectively |

### [clang.cmake](./clang.cmake)

This file is used for all `clang` based toolchains.

#### Clang Settings given

These are the list of various setting that are set/given by this script.

| Name | Type | Value |
| -- | -- | -- |
| `COMPILERVERSION` | string | Value of the compiler version as string |
| `-std` | string | Value of the C/C++ standard for this compiler for compilation |

#### Clang Configuration required

These are the list of various settings/configuration required by the script to function.

| Name | Type | Value |
| -- | -- | -- |
| `COMPILER_SPECIFIC_CFLAGS` | string | Compiler flags defined in [cortex types](./../cortex/cortexTypes.md) for compilation |
| `COMPILER_SPECIFIC_LD_FLAGS` | string | Value of cortex cpu types defined in [cortex types](./../cortex/cortexTypes.md) for linking |
| `-T` | string | Value of linker file as `${TARGETNAME}_LLVM_LINKER_SCRIPT`|
| `-L` | string | Value of linker file path as `${TARGETNAME}_LLVM_LINKER_PATH`|
