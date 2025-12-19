# ======================================================================== GPIO Structure Auto-Generation
# ========================================================================
# Generate cpb_gpio_struct.h and cpb_gpio_struct.c from main.h GPIO defines
#
# This script parses main.h for GPIO pin/port define pairs and generates: - cpb_gpio_struct.h: Enum definitions and
# structure typedefs - cpb_gpio_struct.c: Const array with designated initializers
#
# Required variables to be set by caller: - MAIN_HEADER: Path to main.h file containing GPIO defines - GPIO_STRUCT_DIR:
# Output directory for generated files
# ========================================================================

set (GPIO_STRUCT_HEADER "${GPIO_STRUCT_DIR}/cpb_gpio_struct.h")
set (GPIO_STRUCT_SOURCE "${GPIO_STRUCT_DIR}/cpb_gpio_struct.c")

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
  "#ifndef CPB_GPIO_STRUCT_H\n"
  "#define CPB_GPIO_STRUCT_H\n"
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
  "    eCPB_GPIO_COUNT\n"
  "} cpb_gpio_e;\n"
  "\n"
  "/* GPIO pin structure */\n"
  "typedef struct\n"
  "{\n"
  "    GPIO_TypeDef *pPort;\n"
  "    uint32_t uPin;\n"
  "} cpb_gpio_t;\n"
  "\n"
  "/* GPIO pins array */\n"
  "extern const cpb_gpio_t cpb_gpio_pins[eCPB_GPIO_COUNT];\n"
  "\n"
  "#ifdef __cplusplus\n"
  "}\n"
  "#endif\n"
  "\n"
  "#endif /* CPB_GPIO_STRUCT_H */\n")

# Generate source file
file (
  WRITE "${GPIO_STRUCT_SOURCE}"
  "/* AUTO-GENERATED FILE - DO NOT EDIT MANUALLY */\n"
  "/* Generated from: ${MAIN_HEADER} */\n"
  "/* Generation time: ${GENERATION_TIMESTAMP} */\n"
  "\n"
  "#include \"main.h\"\n"
  "#include \"cpb_gpio_struct.h\"\n"
  "\n"
  "/* GPIO pins array with designated initializers */\n"
  "const cpb_gpio_t cpb_gpio_pins[eCPB_GPIO_COUNT] = \n"
  "{\n")

# Add array initializers with designated initializers
foreach (GPIO_NAME ${GPIO_NAMES})
  file (APPEND "${GPIO_STRUCT_SOURCE}" "    [e${GPIO_NAME}] = {${GPIO_NAME}_GPIO_Port, ${GPIO_NAME}_Pin},\n")
endforeach ()

file (APPEND "${GPIO_STRUCT_SOURCE}" "};\n")

message (STATUS "Generated GPIO structures: ${ENUM_INDEX} pins found")
