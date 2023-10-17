## Cortex Types based settings

The various files here provide a consistent value to necessary flags and settings required for all supported compilers, based on target architecture.

| Name | Compiler | M0 | M4F | M7 |
| -- | -- | -- | -- | -- |
| `cpu_flag` | `gcc` | `-mcpu=cortex-m0` | `-mcpu=cortex-m4f` |  `-mcpu=cortex-m7` |
| `cpu_mode` | `gcc` | `-mthumb` | `-mthumb` |  `-mthumb` |
| `ac6_target` | `ac6` | `--target=arm-arm-none-eabi` | `--target=arm-arm-none-eabi` |  `--target=arm-arm-none-eabi` |
| `ac6_link_flag` | `ac6` | `Cortex-M0` | `Cortex-M4F` | `Cortex-M7.fp.dp` |
| `fpu_type` | `ac6`/`gcc` | :information_source: | `-mfpu=fpv4-sp-d16` | `-mfpu=fpv5-d16` |
| `float_abi` | `ac6`/`gcc` | :information_source: | `-mfloat-abi=hard` | `-mfloat-abi=hard` |
| `llvm_config_file_name` | `llvm-clang` | `armv6m_soft_nofp.cfg` | `armv7em_hard_fpv4_d16.cfg` | `armv7em_hard_fpv5_d16.cfg` |
| `llvm_gcc_float_abi` | `llvm-gcc` | `-mfloat-abi=soft` | :warning: | :warning: |
| `llvm_gcc_march` | `llvm-gcc` | `-march=armv6m` | :warning: | :warning: |


:information_source: _: flag/setting not set_
:warning: : _not supported_
