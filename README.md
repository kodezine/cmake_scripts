# Kodezine's CMake Collection

A comprehensive, modular collection of CMake scripts designed specifically for **embedded systems development**. This repository provides reusable CMake modules for popular frameworks, silicon vendor libraries, cross-compilation toolchains, and development utilities.

## 🎯 Overview

This collection simplifies embedded development by providing:

- **Plug-and-play CMake modules** for popular embedded frameworks
- **Cross-compilation toolchain support** for ARM Cortex-M processors
- **Silicon vendor integration** (STMicroelectronics, with more coming)
- **Modern CMake practices** with FetchContent and CPM package manager
- **Quality assurance** through automated testing and pre-commit hooks

Each folder contains comprehensive documentation to help you get started quickly.

## Build Status & Quality Checks

[![Pre-commit Checks](https://github.com/kodezine/cmake_scripts/workflows/Pre-commit%20Checks/badge.svg)](https://github.com/kodezine/cmake_scripts/actions/workflows/pre-commit.yml)

[Static Libraries](./.readme/Debug.svg) <img src="./.readme/Debug.svg" alt="Debug Build Status">

## Requirements

### Minimum CMake Version

- **CMake 3.20+** - Required for modern CMake features and FetchContent improvements
- **CPM Package Manager** - For dependency management (automatically downloaded)

### Supported Platforms

- **Host OS**: Linux, macOS, Windows (with WSL recommended)
- **Target Architectures**: ARM Cortex-M0, M3, M4F, M7
- **Toolchains**: GCC, Clang, ARM Compiler 6

### Dependencies

```bash
# For development (optional)
pip install pre-commit cmake-format
npm install -g markdownlint-cli
```

## 📚 [frameworks](./frameworks/)

Popular embedded frameworks with CMake integration:

### Core Libraries

- **[CMSIS v5/v6](https://arm-software.github.io/CMSIS_5/General/html/index.html)** - ARM Cortex Microcontroller Software Interface Standard
- **[CMSIS-DSP](https://github.com/ARM-software/CMSIS-DSP)** - Digital Signal Processing library optimized for ARM Cortex-M

### Testing & Debugging

- **[Unity](http://www.throwtheswitch.org/unity)** - Unit testing framework for embedded C
- **[CMock](http://www.throwtheswitch.org/cmock)** - Mock function generation for unit testing
- **[Segger RTT](https://wiki.segger.com/RTT)** - Real-Time Transfer for debugging and logging

### Real-time Systems

- **[CANopen Node](./frameworks/canopennode/)** - CANopen protocol implementation
- **[Quantum Leaps](./frameworks/quantum_leaps/)** - QP/C event-driven framework

All frameworks support both **source compilation** and **precompiled libraries** for faster builds.

## 🔬 [silicon](./silicon/)

Silicon vendor HAL/LL driver integration with automatic fetching and configuration:

### [STMicroelectronics](./silicon/STMicroelectronics/)

**Modern STM32 integration** with CPM package manager support:

- **Supported Families**: STM32F0, F3, F4, G4, H7 series
- **Device Coverage**: 8+ validated devices (STM32F031x6, F072xB, F303xE, F429xx, G431xx, G474xx, H7A3xxQ, H743xx)
- **CMSIS Integration**: Automatic CMSIS v5/v6 detection and linking
- **HAL Configuration**: Custom or template-based configuration support

📖 **Documentation**: [STM32CubeXX Integration Guide](./silicon/STMicroelectronics/stm32cubexx.md)

#### Legacy Support

- **[Legacy STM32](./silicon/st/)** - Original STM32 integration (maintenance mode)

*Additional silicon vendors coming soon...*

## 🔧 [toolchains](./toolchains/)

Cross-compilation toolchains for ARM Cortex-M development:

### Supported Toolchains

- **[ARM GNU Toolchain](./toolchains/arm_none_eabi_gcc.cmake)** - Popular `arm-none-eabi-gcc` (free)
- **[ARM Compiler 6](./toolchains/armclang.cmake)** - Professional `armclang` (commercial)
- **[ARM Compiler 6 Community](./toolchains/armclang_community.cmake)** - Community edition
- **[LLVM Embedded](./toolchains/llvm_clang_arm.cmake)** - LLVM-based ARM toolchain

### Processor Support

- **Cortex-M0/M0+** - Entry-level microcontrollers
- **Cortex-M3** - Mainstream performance
- **Cortex-M4F** - DSP and floating-point
- **Cortex-M7** - High-performance with cache

📖 **Setup Guide**: [Toolchain Configuration](./toolchains/toolchains.md)

## 🛠️ [utilities](./utilities/)

Development and build utilities for embedded projects:

- **[Firmware Tools](./utilities/utils.cmake)** - Size reporting, object generation (bin/hex), listing files
- **[Version Management](./utilities/extract_version.cmake)** - Automatic version extraction from Git tags
- **[Flash Programming](./utilities/flasher.cmake)** - J-Link integration for firmware flashing
- **[Archive Creation](./utilities/artifact_archiving.cmake)** - Build artifact management
- **[SRecord Tools](./utilities/srecord.cmake)** - Motorola S-record file handling

These utilities integrate seamlessly with the embedded development workflow.

## 🚀 Quick Start

### 1. Add to Your Project

```cmake
# Add as a Git submodule
git submodule add https://github.com/kodezine/cmake_scripts.git cmake_scripts

# Or use FetchContent (CMake 3.14+)
include(FetchContent)
FetchContent_Declare(cmake_scripts
    GIT_REPOSITORY https://github.com/kodezine/cmake_scripts.git
    GIT_TAG main
)
FetchContent_MakeAvailable(cmake_scripts)
```

### 2. Basic STM32 Project Setup

```cmake
cmake_minimum_required(VERSION 3.20)

# Set target configuration
set(STM32_TYPE "f4")
set(STM32_DEVICE "STM32F429xx")
set(ENV{CORTEX_TYPE} "CM4F")
set(ENV{COMPILER_ROOT_PATH} "/opt/arm-gnu-toolchain")

# Include CPM package manager
include(cmake_scripts/CPM.cmake)

# Set toolchain before project()
set(CMAKE_TOOLCHAIN_FILE cmake_scripts/toolchains/arm_none_eabi_gcc.cmake)

project(my_embedded_project C CXX ASM)

# Add STM32 HAL/LL drivers
include(cmake_scripts/silicon/STMicroelectronics/stm32cubexx.cmake)

# Add your executable
add_executable(firmware main.c)
target_link_libraries(firmware PRIVATE stm32cubef4::framework)
```

### 3. Environment Setup

```bash
# Set required environment variables
export CORTEX_TYPE="CM4F"
export COMPILER_ROOT_PATH="/opt/arm-gnu-toolchain"

# Configure and build
cmake -B build -S .
cmake --build build
```

## 📋 Supported Device Matrix

| Family | Devices | Cortex Core | Status |
|--------|---------|-------------|---------|
| STM32F0 | F031x6, F072xB | Cortex-M0 | ✅ Stable |
| STM32F3 | F303xE | Cortex-M4F | ✅ Stable |
| STM32F4 | F429xx | Cortex-M4F | 🆕 Enhanced |
| STM32G4 | G431xx, G474xx | Cortex-M4F | ✅ Stable |
| STM32H7 | H7A3xxQ, H743xx | Cortex-M7 | ✅ Stable |

## 📖 Documentation

- **[STM32 Integration Guide](./silicon/STMicroelectronics/stm32cubexx.md)** - Comprehensive STM32 setup
- **[Toolchain Setup](./toolchains/toolchains.md)** - Cross-compilation configuration
- **[Workflow Documentation](./.github/workflows/README.md)** - CI/CD and quality checks
- **[Framework Guides](./frameworks/)** - Individual framework documentation

## Code Quality & Contributing

This repository maintains high code quality standards through automated checks:

- **Pre-commit hooks**: Automatic code formatting and linting
- **GitHub Actions**: Continuous integration with quality checks
- **Multi-language support**: CMake, C/C++, Python, Markdown, YAML validation
- **Security scanning**: Automated vulnerability detection

### Local Development Setup

```bash
# Install pre-commit hooks
pip install pre-commit
pre-commit install

# Run all checks locally
pre-commit run --all-files
```

### Workflow Status

- **Pre-commit Checks**: Comprehensive quality assurance including security scanning
- **Quick Pre-commit**: Fast feedback loop for development
- **CMake Quality Checks**: Embedded systems and CMake-specific validation

See [.github/workflows/README.md](./.github/workflows/README.md) for detailed workflow documentation.

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines:

### How to Contribute

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Setup** pre-commit hooks (`pre-commit install`)
4. **Make** your changes with proper documentation
5. **Test** locally (`pre-commit run --all-files`)
6. **Commit** with conventional commit messages
7. **Submit** a Pull Request

### Adding New Devices/Frameworks

- Update device lists in respective `.cmake` files
- Add comprehensive documentation
- Include usage examples
- Test with multiple toolchains
- Follow existing code patterns

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

### Third-party Licenses

- **STM32CubeXX**: STMicroelectronics (BSD-3-Clause)
- **CMSIS**: ARM Limited (Apache 2.0)
- **Frameworks**: Individual licenses apply (see respective repositories)

## 🌟 Acknowledgments

- **ARM Limited** - For CMSIS and development tools
- **STMicroelectronics** - For STM32 HAL/LL drivers
- **ThrowTheSwitch.org** - For Unity and CMock testing frameworks
- **Embedded community** - For feedback and contributions

## 📞 Support & Contact

- **Issues**: [GitHub Issues](https://github.com/kodezine/cmake_scripts/issues)
- **Discussions**: [GitHub Discussions](https://github.com/kodezine/cmake_scripts/discussions)
- **Documentation**: [Wiki](https://github.com/kodezine/cmake_scripts/wiki)
- **Organization**: [Kodezine](https://github.com/kodezine)

---

Made with ❤️ for the embedded systems community
