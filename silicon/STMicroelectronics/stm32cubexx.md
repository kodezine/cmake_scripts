# STM32CubeXX Library Integration for Kodezine CMake Scripts

## Overview

This document provides comprehensive documentation for the STM32CubeXX library integration within the Kodezine CMake Scripts collection. The STM32CubeXX scripts provide a modern, flexible approach to integrating STMicroelectronics' HAL and LL drivers into embedded projects using CMake.

## Repository Information

- **Repository**: `kodezine/cmake_scripts`
- **Current Branch**: `support-for-stm32f43x-devices`
- **Default Branch**: `main`
- **License**: MIT License (Copyright 2023 sohal)
- **Last Updated**: November 3, 2025

## Recent Changes Summary

### Major Feature Additions

#### 1. New STMicroelectronics Integration Structure

- **Location**: `/silicon/STMicroelectronics/`
- **Purpose**: Modernized approach to STM32 HAL/LL driver integration
- **Migration**: Transitioning from `/silicon/st/` to `/silicon/STMicroelectronics/`

#### 2. STM32F429xx Device Support

- **Branch**: `support-for-stm32f43x-devices`
- **Addition**: Support for STM32F429xx devices in the supported device list
- **Impact**: Expands compatibility to STM32F4 series high-performance devices

#### 3. CPM Package Manager Integration

- **Feature**: Modern dependency management using CPM (CMake Package Manager)
- **Benefit**: Simplified, reproducible builds with automatic dependency resolution
- **Requirement**: Projects must include CPM.cmake

## File Structure and Components

### Core Integration Files

#### 1. `stm32cubexx.cmake` - Main Integration Script

**Purpose**: Primary entry point for STM32CubeXX library integration

**Required Variables**:

- `STM32_TYPE`: Device family (e.g., "f0", "f1", "f4", "l4")
- `STM32_DEVICE`: Specific device (e.g., "STM32F031x6", "STM32F429xx")
- `CORTEX_TYPE`: Cortex type (e.g., "cm0", "cm3", "cm4", "cm7")

**Optional Variables**:

- `GITHUB_BRANCH_stm32cubexx`: GitHub tag format "v1.11.5" (default: "v1.11.5")
- `PRECOMPILED_TAG_stm32cubexx`: Precompiled library tag
- `PRECOMPILED_RESOURCE_stm32cubexx`: Custom precompiled resource URL
- `cmsis_v5_CORE_INCLUDE_PATH` & `cmsis_v5_DEVICE_INCLUDE_PATH`: External CMSIS v5
- `cmsis_v6_CORE_INCLUDE_PATH` & `cmsis_v6_DEVICE_INCLUDE_PATH`: External CMSIS v6
- `STM32CubeMxConfigHeaderFile`: Custom HAL configuration file

**Key Features**:

- Automatic repository detection and fetching from STMicroelectronics GitHub
- Support for both source compilation and precompiled libraries
- Intelligent CMSIS version detection and integration
- Cortex-M processor type validation and configuration

#### 2. `stm32cubexx.devices.cmake` - Supported Devices Registry

**Purpose**: Central registry of all supported STM32 devices

**Currently Supported Devices**:

```cmake
"STM32F031x6"    # STM32F0 series - Cortex-M0
"STM32F072xB"    # STM32F0 series - Cortex-M0
"STM32F303xE"    # STM32F3 series - Cortex-M4F
"STM32F429xx"    # STM32F4 series - Cortex-M4F (NEWLY ADDED)
"STM32G431xx"    # STM32G4 series - Cortex-M4F
"STM32G474xx"    # STM32G4 series - Cortex-M4F
"STM32H7A3xxQ"   # STM32H7 series - Cortex-M7
"STM32H743xx"    # STM32H7 series - Cortex-M7
```

**Validation**: Performs compile-time validation of `STM32_DEVICE` against supported list

#### 3. `stm32cubexx.types.cmake` - Device Family Configuration

**Purpose**: Maps device families to supported STM32 types

**Supported Types**:

```cmake
"F0"  # STM32F0 series
"F3"  # STM32F3 series
"F4"  # STM32F4 series
"G4"  # STM32G4 series
"H7"  # STM32H7 series
```

#### 4. `stm32cubexx.cmsis.cmake` - CMSIS Integration Logic

**Purpose**: Intelligent CMSIS version detection and configuration

**Detection Priority**:

1. External CMSIS v5 (via `cmsis_v5_*` variables)
2. External CMSIS v6 (via `cmsis_v6_*` variables)
3. Internal CMSIS from STM32CubeXX package

**Outputs**:

- `cmsis_CORE_INCLUDE_PATH`: Core CMSIS headers path
- `cmsis_DEVICE_INCLUDE_PATH`: Device-specific CMSIS headers path
- `cmsis`: Selected CMSIS library identifier

#### 5. `stm32cubexx.precompiled.cmake` - Precompiled Library Support

**Purpose**: Integration of precompiled STM32CubeXX libraries

**Features**:

- CPM-based package management
- SHA256 hash verification
- Automatic `find_package()` integration

#### 6. `stm32cubexx.CMakeLists.cmake` - Library Build Configuration

**Purpose**: Complete CMake configuration for building STM32CubeXX static library

**Key Features**:

- Modern CMake target creation with namespace aliases
- Comprehensive header and source file management
- HAL configuration file handling (custom or template)
- Generator expression support for conditional compilation
- Complete installation and packaging support
- CMake export targets for downstream projects

**Target Properties**:

- **Library Name**: `stm32cube${STM32_TYPE}` (e.g., `stm32cubef4`)
- **Alias**: `stm32cube${STM32_TYPE}::framework`
- **Standard**: C11 with no extensions
- **Headers**: All HAL, LL, Legacy, and CMSIS headers
- **Compile Definitions**: `USE_HAL_DRIVER`, `${STM32_DEVICE}`

## Migration Path

### From Legacy `/silicon/st/` Structure

The new `/silicon/STMicroelectronics/` structure provides several advantages over the legacy approach:

#### Improvements

1. **CPM Integration**: Modern dependency management
2. **Better CMSIS Handling**: Intelligent version detection
3. **Simplified Configuration**: Streamlined variable structure
4. **Enhanced Validation**: Comprehensive device and type checking
5. **Modern CMake**: Updated to current CMake best practices

#### Migration Steps

1. Update include paths from `silicon/st/` to `silicon/STMicroelectronics/`
2. Ensure CPM.cmake is available in your project
3. Update variable names if using custom configurations
4. Validate device compatibility with new device registry

### Compatibility Matrix

| Device Family | Legacy Support | New Support | Cortex Type | Status |
|---------------|----------------|-------------|-------------|---------|
| STM32F0xx     | ✅             | ✅          | Cortex-M0   | Stable |
| STM32F3xx     | ✅             | ✅          | Cortex-M4F  | Stable |
| STM32F4xx     | Partial        | ✅          | Cortex-M4F  | **Enhanced** |
| STM32G4xx     | ✅             | ✅          | Cortex-M4F  | Stable |
| STM32H7xx     | ✅             | ✅          | Cortex-M7   | Stable |

## Usage Examples

### Basic Integration

```cmake
# Set required variables
set(STM32_TYPE "f4")
set(STM32_DEVICE "STM32F429xx")
set(ENV{CORTEX_TYPE} "CM4F")

# Include CPM package manager
include(CPM.cmake)

# Include STM32CubeXX integration
include(${CMAKE_SOURCE_DIR}/cmake_scripts/silicon/STMicroelectronics/stm32cubexx.cmake)

# Link to your target
target_link_libraries(your_target PRIVATE stm32cubef4::framework)
```

### Advanced Configuration with External CMSIS

```cmake
# Use external CMSIS v6
set(cmsis_v6_CORE_INCLUDE_PATH "/path/to/cmsis/v6/core")
set(cmsis_v6_DEVICE_INCLUDE_PATH "/path/to/cmsis/v6/device")

# Set specific versions
set(GITHUB_BRANCH_stm32cubef4 "v1.28.0")

# Custom HAL configuration
set(STM32CubeMxConfigHeaderFile "${CMAKE_SOURCE_DIR}/config/stm32f4xx_hal_conf.h")

# Include integration
include(${CMAKE_SOURCE_DIR}/cmake_scripts/silicon/STMicroelectronics/stm32cubexx.cmake)
```

### Using Precompiled Libraries

```cmake
# Set precompiled library configuration
set(PRECOMPILED_TAG_stm32cubef4 "v1.0.0")
set(PRECOMPILED_RESOURCE_stm32cubef4 "https://github.com/kodezine/precompiled/releases/download/v1.0.0/stm32cubef4.tar.gz")

# Include integration (will automatically use precompiled version)
include(${CMAKE_SOURCE_DIR}/cmake_scripts/silicon/STMicroelectronics/stm32cubexx.cmake)
```

## Build System Integration

### CMake Preset Configuration

```json
{
    "configurePresets": [
        {
            "name": "stm32f4-debug",
            "environment": {
                "CORTEX_TYPE": "CM4F",
                "COMPILER_ROOT_PATH": "${env:ARM_TOOLCHAIN_PATH}"
            },
            "cacheVariables": {
                "STM32_TYPE": "f4",
                "STM32_DEVICE": "STM32F429xx",
                "CMAKE_TOOLCHAIN_FILE": "${sourceDir}/cmake_scripts/toolchains/arm_none_eabi_gcc.cmake"
            }
        }
    ]
}
```

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `CORTEX_TYPE` | ARM Cortex processor type | "CM4F" |
| `COMPILER_ROOT_PATH` | Toolchain root directory | "/opt/arm-gnu-toolchain" |

## Error Handling and Troubleshooting

### Common Issues and Solutions

#### 1. CPM Not Found

**Error**: `CPM: not finding CPM, use older scripts or add CPM.cmake to your project`
**Solution**: Include CPM.cmake in your project or use legacy scripts from `/silicon/st/`

#### 2. Unsupported Device

**Error**: `${libName}: ${STM32_DEVICE} is yet not supported`
**Solution**: Check device name against supported list in `stm32cubexx.devices.cmake`

#### 3. Missing Cortex Type

**Error**: `${libName}: needs a cortex type defined`
**Solution**: Set `CORTEX_TYPE` environment variable before configuration

#### 4. Invalid Repository Access

**Solution**: Ensure internet connectivity and GitHub repository access

### Debug Information

The scripts provide comprehensive status messages:

- Library name and version information
- CMSIS detection and selection
- Source vs. precompiled library usage
- Repository fetching status

## Performance Considerations

### Build Time Optimization

1. **Use Precompiled Libraries**: Significantly reduces build time
2. **CPM Caching**: Automatic dependency caching reduces re-download time
3. **Selective HAL Configuration**: Custom HAL config files reduce compilation units

### Memory Footprint

1. **HAL Driver Selection**: Use custom configuration to include only needed drivers
2. **Optimization Levels**: Configure compiler optimization in toolchain
3. **Dead Code Elimination**: Linker garbage collection removes unused code

## Integration with Other Frameworks

### CMSIS Compatibility

- **CMSIS v5**: Full compatibility with external v5 installations
- **CMSIS v6**: Full compatibility with external v6 installations
- **Internal CMSIS**: Uses CMSIS version from STM32CubeXX when no external version found

### Testing Framework Integration

Works seamlessly with:

- **Unity**: Unit testing framework
- **CMock**: Mocking framework for unit tests
- **Segger RTT**: Real-time debugging and logging

### Real-time Framework Support

Compatible with:

- **Quantum Leaps QP/C**: Event-driven framework
- **FreeRTOS**: Real-time operating system
- **ThreadX**: Microsoft real-time kernel

## Future Roadmap

### Planned Enhancements

1. **Device Support Expansion**:
   - STM32L series (low power)
   - STM32U series (ultra-low power)
   - STM32WB series (wireless)
   - STM32MP series (microprocessor)

2. **Tool Integration**:
   - STM32CubeMX project import
   - Automated HAL configuration generation
   - Device-specific linker script generation

3. **Advanced Features**:
   - Multi-target builds
   - Bootloader integration
   - OTA update support
   - Hardware abstraction layers

### Version Compatibility

- **CMake**: Minimum version 3.20 (modern CMake features)
- **CPM**: Latest version recommended
- **STM32CubeXX**: All current LTS versions supported

## Contributing

### Adding New Device Support

1. Update `stm32cubexx.devices.cmake` with new device identifier
2. Update `stm32cubexx.types.cmake` if new family required
3. Test with appropriate toolchain and Cortex type
4. Update documentation

### Submitting Changes

1. Create feature branch from `main`
2. Follow existing code style and patterns
3. Update documentation
4. Submit pull request with comprehensive description

## License and Legal

### License Information

- **License**: MIT License
- **Copyright**: 2023 sohal
- **Repository**: [https://github.com/kodezine/cmake_scripts](https://github.com/kodezine/cmake_scripts)

### Third-party Dependencies

- **STM32CubeXX**: STMicroelectronics (BSD-3-Clause)
- **CMSIS**: ARM Limited (Apache 2.0)
- **CPM.cmake**: TheLartians (MIT)

### Compliance

All integrated libraries maintain their original licenses and attribution requirements.

---

**Document Version**: 1.0
**Last Updated**: November 3, 2025
**Maintainer**: Kodezine Team
**Contact**: [https://github.com/kodezine/cmake_scripts/issues](https://github.com/kodezine/cmake_scripts/issues)
