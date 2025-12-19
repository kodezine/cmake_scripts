# ======================================================================== GPIO Structure Auto-Generation
# ========================================================================
# Generate gpio_struct.h and gpio_struct.c from main.h GPIO defines
#
# This script parses main.h for GPIO pin/port define pairs and generates: - gpio_struct.h: Enum definitions and
# structure typedefs - gpio_struct.c: Const array with designated initializers
#
# Required variables to be set by caller: - MAIN_HEADER: Path to main.h file containing GPIO defines - GPIO_STRUCT_DIR:
# Output directory for generated files
#
# Optional variables: - GPIO_STRUCT_HEADER_NAME: Output header filename (default: gpio_struct.h) -
# GPIO_STRUCT_SOURCE_NAME: Output source filename (default: gpio_struct.c) - GPIO_ENUM_PREFIX: Prefix for enum type name
# (default: gpio) - GPIO_STRUCT_PREFIX: Prefix for structure type name (default: gpio)
# ========================================================================

# Check for user-defined filenames, use defaults if not provided
if (NOT DEFINED GPIO_STRUCT_HEADER_NAME)
  set (GPIO_STRUCT_HEADER_NAME "gpio_struct.h")
endif ()

if (NOT DEFINED GPIO_STRUCT_SOURCE_NAME)
  set (GPIO_STRUCT_SOURCE_NAME "gpio_struct.c")
endif ()

if (NOT DEFINED GPIO_ENUM_PREFIX)
  set (GPIO_ENUM_PREFIX "gpio")
endif ()

if (NOT DEFINED GPIO_STRUCT_PREFIX)
  set (GPIO_STRUCT_PREFIX "gpio")
endif ()

# Construct full paths
set (GPIO_STRUCT_HEADER "${GPIO_STRUCT_DIR}/${GPIO_STRUCT_HEADER_NAME}")
set (GPIO_STRUCT_SOURCE "${GPIO_STRUCT_DIR}/${GPIO_STRUCT_SOURCE_NAME}")

# Generate uppercase versions for header guards and count names
string (TOUPPER "${GPIO_ENUM_PREFIX}" GPIO_ENUM_PREFIX_UPPER)
string (TOUPPER "${GPIO_STRUCT_HEADER_NAME}" HEADER_GUARD_BASE)
string (REGEX REPLACE "\\." "_" HEADER_GUARD "${HEADER_GUARD_BASE}")

# Read main.h file
file (STRINGS "${MAIN_HEADER}" MAIN_H_CONTENTS)

# Extract GPIO pin defines (lines with #define XXX_Pin)
set (GPIO_NAMES "")
foreach (LINE ${MAIN_H_CONTENTS})
  if (LINE MATCHES "^#define[ \t]+([A-Za-z0-9_]+)_Pin[ \t]+GPIO_PIN_[0-9]+")
    string (REGEX REPLACE "^#define[ \t]+([A-Za-z0-9_]+)_Pin.*" "\\1" PIN_NAME "${LINE}")
    list (APPEND GPIO_NAMES "${PIN_NAME}")
  endif ()
endforeach ()

# Get current timestamp
string (TIMESTAMP GENERATION_TIMESTAMP "%Y-%m-%d %H:%M:%S")

# Generate header file
file (
  WRITE "${GPIO_STRUCT_HEADER}"
  "/* AUTO-GENERATED FILE - DO NOT EDIT MANUALLY */\n"
  "/* Generated from: ${MAIN_HEADER} */\n"
  "/* Generation time: ${GENERATION_TIMESTAMP} */\n"
  "\n"
  "#ifndef ${HEADER_GUARD}\n"
  "#define ${HEADER_GUARD}\n"
  "\n"
  "#ifdef __cplusplus\n"
  "extern \"C\" {\n"
  "#endif\n"
  "\n"
  "#include \"stm32f4xx_hal.h\"\n"
  "\n"
  "/* GPIO pin enumeration */\n"
  "typedef enum\n"
  "{\n")

# Add enum values
set (ENUM_INDEX 0)
foreach (GPIO_NAME ${GPIO_NAMES})
  if (ENUM_INDEX EQUAL 0)
    file (APPEND "${GPIO_STRUCT_HEADER}" "    e${GPIO_NAME} = 0,\n")
  else ()
    file (APPEND "${GPIO_STRUCT_HEADER}" "    e${GPIO_NAME},\n")
  endif ()
  math (EXPR ENUM_INDEX "${ENUM_INDEX} + 1")
endforeach ()

file (
  APPEND "${GPIO_STRUCT_HEADER}"
  "    e${GPIO_ENUM_PREFIX_UPPER}_COUNT\n"
  "} ${GPIO_ENUM_PREFIX}_e;\n"
  "\n"
  "/* GPIO pin structure */\n"
  "typedef struct\n"
  "{\n"
  "    GPIO_TypeDef *pPort;\n"
  "    uint32_t uPin;\n"
  "} ${GPIO_STRUCT_PREFIX}_t;\n"
  "\n"
  "/* GPIO pins array */\n"
  "extern const ${GPIO_STRUCT_PREFIX}_t ${GPIO_STRUCT_PREFIX}_pins[e${GPIO_ENUM_PREFIX_UPPER}_COUNT];\n"
  "\n"
  "#ifdef __cplusplus\n"
  "}\n"
  "#endif\n"
  "\n"
  "#endif /* ${HEADER_GUARD} */\n")

# Generate source file
file (
  WRITE "${GPIO_STRUCT_SOURCE}"
  "/* AUTO-GENERATED FILE - DO NOT EDIT MANUALLY */\n"
  "/* Generated from: ${MAIN_HEADER} */\n"
  "/* Generation time: ${GENERATION_TIMESTAMP} */\n"
  "\n"
  "#include \"main.h\"\n"
  "#include \"${GPIO_STRUCT_HEADER_NAME}\"\n"
  "\n"
  "/* GPIO pins array with designated initializers */\n"
  "const ${GPIO_STRUCT_PREFIX}_t ${GPIO_STRUCT_PREFIX}_pins[e${GPIO_ENUM_PREFIX_UPPER}_COUNT] = \n"
  "{\n")

# Add array initializers with designated initializers
foreach (GPIO_NAME ${GPIO_NAMES})
  file (APPEND "${GPIO_STRUCT_SOURCE}" "    [e${GPIO_NAME}] = {${GPIO_NAME}_GPIO_Port, ${GPIO_NAME}_Pin},\n")
endforeach ()

file (APPEND "${GPIO_STRUCT_SOURCE}" "};\n")

message (STATUS "Generated GPIO structures: ${ENUM_INDEX} pins found in ${GPIO_STRUCT_HEADER_NAME}")
