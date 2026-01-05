# Cross Compilation Toolchains

This collection includes a basic cross compiler collection support:

1. [ARM Compiler Version 6](https://developer.arm.com/Tools%20and%20Software/Arm%20Compiler%20for%20Embedded)
    * Clang based `armclang` compiler.
    * for a paid licensed compiler, use [armclang.cmake](./armclang.cmake).
    * for a community licensed compiler, use [armclang-community.cmake](./armclang-community.cmake).
2. [ARM GNU Toolchain](https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain)
    * popular `arm-none-eabi-*`
    * supports also the older [version](https://developer.arm.com/downloads/-/gnu-rm).
    * use [arm-none-eabi-gcc.cmake](./arm-none-eabi-gcc.cmake)
3. [LLVM Embedded Toolchain for ARM](https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm) (Legacy)
    * use [llvm-clang-arm.cmake](./llvm-clang-arm.cmake)
4. [LLVM - GCC Hybrid](https://interrupt.memfault.com/blog/arm-cortexm-with-llvm-clang#update-clang-baremetal)
    * may fail to work, it's reaching end-of-life.
    * use [llvm-clang-gcc.cmake](./llvm-clang-gcc.cmake)
5. [ATFE (Arm Toolchain for Embedded)](https://github.com/arm/arm-toolchain)
    * Modern LLVM/Clang-based toolchain with dynamic configuration
    * Auto-download support for runtime library overlays
    * use [atfe_clang.cmake](./atfe_clang.cmake)
    * See [ATFE Toolchain](#atfe-toolchain) section below for detailed usage

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

## ATFE Toolchain

The ATFE (Arm Toolchain for Embedded) provides a modern LLVM/Clang-based cross-compilation solution for ARM Cortex-M bare-metal development with dynamic configuration generation and automatic runtime library overlay management.

### Overview

ATFE is ARM's official LLVM-based toolchain designed specifically for embedded ARM Cortex-M development. This integration provides:

- **Dynamic Configuration**: Config files are generated at CMake configure time based on your preset selections
- **Auto-Download**: Missing runtime library overlays are automatically downloaded and installed from ARM releases
- **Multi-Runtime Support**: newlib, newlib-nano, and picolibc runtime libraries
- **CRT Variants**: Standard, semihosting, and no-syscall startup configurations
- **Portability**: Configuration files use relative paths for cross-platform compatibility
- **Git-Friendly**: Generated configs are automatically ignored to prevent accidental commits

### Prerequisites

1. **ATFE Installation**: Download and install ATFE from [ARM GitHub Releases](https://github.com/arm/arm-toolchain/releases)
2. **COMPILER_ROOT_PATH**: Must point to your ATFE installation directory
3. **Runtime Overlays** (optional): Auto-downloaded by default, or pre-install for offline environments

### How It Works

The ATFE toolchain integration follows this workflow:

1. **Configuration Phase**:
   - CMake reads cache variables from your preset (runtime library, CRT variant, etc.)
   - Validates COMPILER_ROOT_PATH and checks for clang binary
   - Includes cortex-specific configuration (cm0, cm4f, cm7)

2. **Sysroot Detection**:
   - Searches for runtime library in two patterns:
     - `lib/clang-runtimes/${RUNTIME_LIB}/`
     - `${RUNTIME_LIB}/arm-none-eabi/`

3. **Auto-Download** (if sysroot not found and enabled):
   - Detects clang version (major.minor) from `clang --version`
   - Downloads matching overlay from ARM GitHub releases
   - Verifies SHA256 checksum
   - Extracts to COMPILER_ROOT_PATH
   - Cleans up archive after installation

4. **Config Generation**:
   - Composes `.cfg` file with target architecture, runtime, and CRT settings
   - Stores in `toolchains/common/.atfe_config/` (git-ignored)
   - Only regenerates when content changes (MD5-based check)
   - Uses relative paths from COMPILER_ROOT_PATH/bin/

5. **Compilation**:
   - Clang invoked with `--config=<absolute-path-to-cfg>`
   - All flags and sysroot settings contained in config file

### Cache Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `COMPILER_ROOT_PATH` | PATH | **Required** | Path to ATFE installation (e.g., `/opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3`) |
| `CORTEX_TYPE` | STRING | **Required** | Target Cortex-M variant: `cm0`, `cm4f`, `cm7` |
| `ATFE_RUNTIME_LIB` | STRING | `newlib` | Runtime library: `newlib`, `newlib-nano`, `picolibc` |
| `ATFE_CRT_VARIANT` | STRING | `default` | CRT startup: `default` (-lcrt0), `semihost` (-lcrt0-rdimon -lrdimon), `nosys` (-lcrt0-nosys) |
| `ATFE_AUTO_DOWNLOAD` | BOOL | `ON` | Enable auto-download of missing runtime overlays |

### Example CMakePresets.json

#### Developer Environment (Auto-Download Enabled)

```json
{
  "version": 6,
  "configurePresets": [
    {
      "name": "cortex-m4-atfe-newlib",
      "description": "Cortex-M4 with ATFE toolchain and newlib runtime",
      "cacheVariables": {
        "CMAKE_TOOLCHAIN_FILE": "${sourceDir}/cmake_scripts/toolchains/atfe_clang.cmake",
        "COMPILER_ROOT_PATH": "/opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3",
        "CORTEX_TYPE": "cm4f",
        "ATFE_RUNTIME_LIB": "newlib",
        "ATFE_CRT_VARIANT": "semihost",
        "ATFE_AUTO_DOWNLOAD": "ON"
      }
    },
    {
      "name": "cortex-m0-atfe-nano",
      "description": "Cortex-M0 with ATFE toolchain and newlib-nano runtime",
      "cacheVariables": {
        "CMAKE_TOOLCHAIN_FILE": "${sourceDir}/cmake_scripts/toolchains/atfe_clang.cmake",
        "COMPILER_ROOT_PATH": "/opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3",
        "CORTEX_TYPE": "cm0",
        "ATFE_RUNTIME_LIB": "newlib-nano",
        "ATFE_CRT_VARIANT": "nosys",
        "ATFE_AUTO_DOWNLOAD": "ON"
      }
    },
    {
      "name": "cortex-m7-atfe-picolibc",
      "description": "Cortex-M7 with ATFE toolchain and picolibc runtime",
      "cacheVariables": {
        "CMAKE_TOOLCHAIN_FILE": "${sourceDir}/cmake_scripts/toolchains/atfe_clang.cmake",
        "COMPILER_ROOT_PATH": "/opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3",
        "CORTEX_TYPE": "cm7",
        "ATFE_RUNTIME_LIB": "picolibc",
        "ATFE_CRT_VARIANT": "default",
        "ATFE_AUTO_DOWNLOAD": "ON"
      }
    }
  ]
}
```

#### CI/Docker Environment (Pre-installed Overlays)

```json
{
  "version": 6,
  "configurePresets": [
    {
      "name": "cortex-m4-atfe-ci",
      "description": "CI build with pre-installed overlays",
      "cacheVariables": {
        "CMAKE_TOOLCHAIN_FILE": "${sourceDir}/cmake_scripts/toolchains/atfe_clang.cmake",
        "COMPILER_ROOT_PATH": "/usr/local/atfe",
        "CORTEX_TYPE": "cm4f",
        "ATFE_RUNTIME_LIB": "newlib",
        "ATFE_CRT_VARIANT": "default",
        "ATFE_AUTO_DOWNLOAD": "OFF"
      }
    }
  ]
}
```

### Platform Support

The auto-download feature supports the following platforms:

| Platform | Archive Format | Tested |
|----------|----------------|--------|
| Linux | `.tar.xz` | ✓ |
| Windows | `.zip` | ✓ |
| macOS (Darwin) | `.tar.xz` | ✓ |

### Version Matching

The auto-download system matches clang versions using **major.minor** only, allowing patch version flexibility:

- Clang **21.1.3** → Downloads overlay **21.1.0**
- Clang **22.1.1** → Downloads overlay **22.1.0**

This ensures compatibility while allowing minor toolchain updates without re-downloading overlays.

### Troubleshooting

#### Error: "COMPILER_ROOT_PATH is not set"

**Cause**: COMPILER_ROOT_PATH cache variable not defined.

**Solution**: Add to your CMakePresets.json:
```json
"cacheVariables": {
  "COMPILER_ROOT_PATH": "/opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3"
}
```

#### Error: "COMPILER_ROOT_PATH does not exist"

**Cause**: Path points to non-existent directory.

**Solution**: Verify installation path:
```bash
ls -la /opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3
```

#### Error: "clang binary not found"

**Cause**: COMPILER_ROOT_PATH doesn't contain `bin/clang`.

**Solution**: Ensure path is the root ATFE installation directory, not `bin/`:
- ✓ Correct: `/opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3`
- ✗ Incorrect: `/opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3/bin`

#### Error: "Sysroot for 'newlib' not found"

**Cause**: Runtime overlay not installed and auto-download disabled.

**Solution 1** - Enable auto-download:
```json
"ATFE_AUTO_DOWNLOAD": "ON"
```

**Solution 2** - Manual installation:
1. Download overlay from [ARM Releases](https://github.com/arm/arm-toolchain/releases)
2. Extract to COMPILER_ROOT_PATH:
   ```bash
   cd /opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3
   tar xf ~/Downloads/LLVMEmbeddedToolchainForArm-21.1.0-linux-newlib.tar.xz
   ```

#### Error: "Failed to download overlay"

**Cause**: Network connectivity issues or invalid URL.

**Solution**:
1. Check internet connection
2. Verify ARM GitHub is accessible
3. Download manually from releases page
4. Check the CMake output for the exact URL attempted

#### Error: "Checksum verification failed"

**Cause**: Downloaded file corrupted or incomplete.

**Solution**:
1. Delete the downloaded file from `<build>/_atfe_downloads/`
2. Run CMake configure again to re-download
3. If persists, download manually and verify checksum:
   ```bash
   sha256sum LLVMEmbeddedToolchainForArm-21.1.0-linux-newlib.tar.xz
   ```

#### Error: "Checksum for <file> not found in SHA256SUMS"

**Cause**: Version mismatch or runtime library not supported by this ATFE version.

**Solution**:
1. Verify the runtime library is supported:
   - Check [ARM Releases](https://github.com/arm/arm-toolchain/releases)
   - Look for overlay files matching your runtime library
2. Try a different runtime library (e.g., switch from `picolibc` to `newlib`)
3. Update to a newer ATFE version if the runtime library is newly added

#### Warning: "Config file unchanged, skipping regeneration"

**Cause**: This is informational, not an error.

**Meaning**: Config file content hasn't changed since last generation (MD5 match). This is expected and prevents unnecessary file writes.

#### Build Fails with Linker Errors

**Cause**: CRT variant mismatch with application code.

**Solution**: Ensure CRT variant matches your startup requirements:
- Use `semihost` for debugging with semihosting I/O
- Use `nosys` for applications without syscall implementations
- Use `default` for standard embedded applications

### Advanced Configuration

#### Custom Sysroot Installation

If your ATFE installation uses a non-standard sysroot layout, the generator supports two patterns:

1. **Pattern 1** (Standard): `${COMPILER_ROOT_PATH}/lib/clang-runtimes/${RUNTIME_LIB}/`
2. **Pattern 2** (Alternate): `${COMPILER_ROOT_PATH}/${RUNTIME_LIB}/arm-none-eabi/`

The generator automatically detects which pattern exists.

#### Offline Environments

For air-gapped or offline development:

1. Pre-download all required overlays:
   ```bash
   cd /opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3
   wget https://github.com/arm/arm-toolchain/releases/download/release-21.1.1-ATfE/newlib.tar.xz
   tar xf newlib.tar.xz
   ```

2. Disable auto-download:
   ```json
   "ATFE_AUTO_DOWNLOAD": "OFF"
   ```

#### Inspecting Generated Configs

Generated config files include debug headers:

```bash
cat cmake_scripts/toolchains/common/.atfe_config/armv7em-none-eabi_newlib_semihost_hard.cfg
```

Example output:
```
# ATFE Configuration File
# Generated: 2026-01-05 12:34:56 UTC
# Content Hash: a1b2c3d4e5f6...
# Target Arch: armv7em-none-eabi
# Float ABI: hard
# FPU: fpv4-sp-d16
# Runtime Library: newlib
# CRT Variant: semihost
# COMPILER_ROOT_PATH: /opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3
# Sysroot: /opt/atfe/LLVMEmbeddedToolchainForArm-21.1.3/lib/clang-runtimes/newlib

--target=armv7em-none-eabi
-march=armv7e-m
-mcpu=cortex-m4
-mfloat-abi=hard
-mfpu=fpv4-sp-d16
--sysroot=../lib/clang-runtimes/newlib
-nostartfiles
-lcrt0-rdimon
-lrdimon
```

### Git Integration

The `.atfe_config/` directory is automatically git-ignored to prevent accidental commits of generated configuration files. This is managed by `toolchains/common/.gitignore`.

### Related Files

- [atfe_clang.cmake](./atfe_clang.cmake) - Main toolchain file
- [common/generate_atfe_config.cmake](./common/generate_atfe_config.cmake) - Config generator function
- [cortex/cm0.cmake](./cortex/cm0.cmake) - Cortex-M0 configuration
- [cortex/cm4f.cmake](./cortex/cm4f.cmake) - Cortex-M4F configuration
- [cortex/cm7.cmake](./cortex/cm7.cmake) - Cortex-M7 configuration
