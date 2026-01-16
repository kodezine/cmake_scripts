# STM32CubeXX Vector Table Generation from Assembly Files This script parses GCC startup assembly files and generates
# vectors_<device>.c files

include (CMakePrintHelpers)

# Function to find the startup assembly file for the specified device Arguments: DEVICE_LOWER: lowercase device name
# (e.g., "stm32f429xx") OUTPUT_VAR: variable name to store the assembly file path
function (find_startup_assembly_file DEVICE_LOWER OUTPUT_VAR)
  # Construct the path to the GCC startup assembly file
  set (
    ASSEMBLY_FILE_PATH
    "${${libName}_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32${UPPERCASE_STM32_TYPE}xx/Source/Templates/gcc/startup_${DEVICE_LOWER}.s"
  )

  if (EXISTS "${ASSEMBLY_FILE_PATH}")
    set (
      ${OUTPUT_VAR}
      "${ASSEMBLY_FILE_PATH}"
      PARENT_SCOPE)
  else ()
    set (
      ${OUTPUT_VAR}
      ""
      PARENT_SCOPE)
  endif ()
endfunction ()

# Function to parse the startup assembly file and extract IRQ handlers Arguments: ASSEMBLY_FILE: path to the assembly
# file IRQ_DECLARATIONS_VAR: variable name to store handler declarations VECTOR_ENTRIES_VAR: variable name to store
# vector table entries
function (parse_startup_assembly ASSEMBLY_FILE IRQ_DECLARATIONS_VAR VECTOR_ENTRIES_VAR)
  # Read the entire assembly file into lines
  file (STRINGS "${ASSEMBLY_FILE}" ASSEMBLY_LINES)

  # Find the vector table section
  set (IN_VECTOR_TABLE FALSE)
  set (VECTOR_LINES "")

  foreach (LINE ${ASSEMBLY_LINES})
    # Start of vector table
    if (LINE MATCHES "^g_pfnVectors:")
      set (IN_VECTOR_TABLE TRUE)
      continue ()
    endif ()

    # End of vector table
    if (LINE MATCHES "^\\.size[ \t]+g_pfnVectors")
      break ()
    endif ()

    # Collect lines within vector table
    if (IN_VECTOR_TABLE)
      list (APPEND VECTOR_LINES "${LINE}")
    endif ()
  endforeach ()

  if (NOT VECTOR_LINES)
    message (WARNING "${libName}: Could not find vector table section in ${ASSEMBLY_FILE}")
    set (
      ${IRQ_DECLARATIONS_VAR}
      ""
      PARENT_SCOPE)
    set (
      ${VECTOR_ENTRIES_VAR}
      ""
      PARENT_SCOPE)
    return ()
  endif ()

  # Track position (starting from 0 for _estack)
  set (POSITION 0)
  set (IRQ_HANDLERS "")
  set (IRQ_DECLARATIONS "")
  set (VECTOR_ENTRIES "")

  foreach (LINE IN LISTS VECTOR_LINES)
    # Match .word entries (with flexible whitespace)
    if (LINE MATCHES "[ \t]*\\.word[ \t]+(.+)")
      set (HANDLER_NAME "${CMAKE_MATCH_1}")

      # Clean up the handler name (remove comments)
      string (REGEX REPLACE "[ \t]*/\\*.*" "" HANDLER_NAME "${HANDLER_NAME}")
      string (STRIP "${HANDLER_NAME}" HANDLER_NAME)

      # Check if this is a reserved entry (0)
      if (HANDLER_NAME STREQUAL "0")
        set (VECTOR_ENTRIES "${VECTOR_ENTRIES}    /* ${POSITION} */ (VECTOR_TABLE_Type)0, /* Reserved */\n")
        # Check if this is the initial stack pointer (_estack)
      elseif (HANDLER_NAME MATCHES "^_estack$")
        set (
          VECTOR_ENTRIES
          "${VECTOR_ENTRIES}    /* ${POSITION} */ (VECTOR_TABLE_Type)(&__INITIAL_SP), /*     Initial Stack Pointer */\n"
        )
      else ()
        # Check if this is an IRQ handler (external interrupt)
        if (HANDLER_NAME MATCHES ".*_IRQHandler$")
          # Add to unique handler list if not already present
          list (FIND IRQ_HANDLERS "${HANDLER_NAME}" HANDLER_INDEX)
          if (HANDLER_INDEX EQUAL -1)
            list (APPEND IRQ_HANDLERS "${HANDLER_NAME}")
            set (IRQ_DECLARATIONS
                 "${IRQ_DECLARATIONS}void ${HANDLER_NAME}(void) __attribute__((weak, alias(\"Default_Handler\")));\n")
          endif ()
        endif ()
        set (VECTOR_ENTRIES "${VECTOR_ENTRIES}    /* ${POSITION} */ (VECTOR_TABLE_Type)&${HANDLER_NAME},\n")
      endif ()

      math (EXPR POSITION "${POSITION} + 1")
    endif ()
  endforeach ()

  # Fill remaining positions up to 255 with zeros
  while (POSITION LESS 256)
    set (VECTOR_ENTRIES "${VECTOR_ENTRIES}    /* ${POSITION} */ (VECTOR_TABLE_Type)0,\n")
    math (EXPR POSITION "${POSITION} + 1")
  endwhile ()

  # Remove trailing newline and comma from last entry
  string (REGEX REPLACE ",\n$" "" VECTOR_ENTRIES "${VECTOR_ENTRIES}")

  # Return the results
  set (
    ${IRQ_DECLARATIONS_VAR}
    "${IRQ_DECLARATIONS}"
    PARENT_SCOPE)
  set (
    ${VECTOR_ENTRIES_VAR}
    "${VECTOR_ENTRIES}"
    PARENT_SCOPE)
endfunction ()

# Main function to generate the vector table C file This function is called from stm32cubexx.cmake
function (generate_vector_table_source)
  # Derive device name in lowercase
  string (TOLOWER "${STM32_DEVICE}" DEVICE_LOWER)

  # Find the startup assembly file
  find_startup_assembly_file ("${DEVICE_LOWER}" ASSEMBLY_FILE)

  if (NOT ASSEMBLY_FILE)
    message (STATUS "${libName}: Skipping vector generation - startup_${DEVICE_LOWER}.s not found")
    return ()
  endif ()

  message (STATUS "${libName}: Found startup assembly file: ${ASSEMBLY_FILE}")

  # Parse the assembly file
  parse_startup_assembly ("${ASSEMBLY_FILE}" IRQ_HANDLER_DECLARATIONS VECTOR_TABLE_ENTRIES)

  if (NOT IRQ_HANDLER_DECLARATIONS)
    message (STATUS "${libName}: Skipping vector generation - failed to parse ${ASSEMBLY_FILE}")
    return ()
  endif ()

  # Prepare substitution variables
  set (DEVICE_FAMILY_LOWER "stm32${LOWERCASE_STM32_TYPE}xx")
  set (DEVICE_NAME "${STM32_DEVICE}")
  string (TIMESTAMP GENERATION_DATE "%d. %B %Y")

  # Calculate relative path from output to assembly file
  cmake_path (RELATIVE_PATH ASSEMBLY_FILE BASE_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/vectors/src" OUTPUT_VARIABLE
              STARTUP_FILE_REFERENCE)

  # Set the template and output paths
  set (TEMPLATE_FILE "${CMAKE_CURRENT_LIST_DIR}/vectors/src/vectors_template.c.in")
  set (OUTPUT_FILE "${CMAKE_CURRENT_LIST_DIR}/vectors/src/vectors_${DEVICE_LOWER}.c")

  # Configure the template file
  configure_file ("${TEMPLATE_FILE}" "${OUTPUT_FILE}" @ONLY)

  message (STATUS "${libName}: Generated vectors_${DEVICE_LOWER}.c from startup_${DEVICE_LOWER}.s")
  message (STATUS "${libName}: Vector table source available at: ${OUTPUT_FILE}")

  # Store the output file path for potential installation
  set (
    VECTOR_TABLE_SOURCE_FILE
    "${OUTPUT_FILE}"
    PARENT_SCOPE)
endfunction ()
