find_program(SREC_CAT "srec_cat")

function(__determine_binary_format
    SRC_FILE_SUFFIX
    RET_FILE_TYPE
)
  string(TOLOWER ${SRC_FILE_SUFFIX} FILE_SUFFIX_LC )
  if ( FILE_SUFFIX_LC STREQUAL "hex")
    set(${RET_FILE_TYPE} "intel")
    set(${RET_FILE_TYPE} ${${RET_FILE_TYPE}} PARENT_SCOPE)
    #return(PROPAGATE ${RET_FILE_TYPE}) #requires CMake >= 3.25
  elseif (FILE_SUFFIX_LC STREQUAL "bin")
    set(${RET_FILE_TYPE} "binary")
    set(${RET_FILE_TYPE} ${${RET_FILE_TYPE}} PARENT_SCOPE)
    #return(PROPAGATE ${RET_FILE_TYPE}) #requires CMake >= 3.25
  endif()
endfunction()

function(__construct_path
    TARGET_NAME
    TARGET_PATH
)
  set(${TARGET_PATH} $<TARGET_FILE_DIR:${TARGET_NAME}>$<TARGET_FILE_PREFIX:${TARGET_NAME}>/$<TARGET_FILE_BASE_NAME:${TARGET_NAME}>)
  set(${TARGET_PATH} ${${TARGET_PATH}} PARENT_SCOPE)

  #return(PROPAGATE ${TGT_PATH})  #requires CMake >= 3.25
endfunction()

#Function to sign a portion of a binary or hex format file with it's crc
#TARGET_NAME    The CMake target's name to use
#FILE_SUFFIX    The suffix to use. Will be used to determine if this is intel or binary format
#START_ADDR     The starting address for CRC calculation
#END_ADDR       The end_address (inclusive) for CRC
#CRC_ADDR       The position the CRC is written to
#CRC_ALGO       The algorithm used by srec_cat (STM32, ...)
#EXAMPLE: sign_binary_crc(${appName} hex 0x8000000 0x0803FFFC 0x0803FFFC STM32)
function(sign_binary_crc
         TARGET_NAME
         FILE_SUFFIX
         START_ADDR
         END_ADDR
         CRC_ADDR
         CRC_ALGO
)
  __construct_path(${TARGET_NAME} TGT_PATH)
  __determine_binary_format(${FILE_SUFFIX} FILE_TYPE)

  if (NOT SREC_CAT)
    message(WARNING "srec_cat not found in path. Not signing ${TARGET_NAME}" )
  else()
    message(STATUS "Output will be signed by CRC: ${TARGET_NAME}.${FILE_SUFFIX}" )
    #srec_cat  <input hex file path> -fill <pattern to fill holes in hex file> <address range over which holes need to fill> -crop<range of  address range over which CRC to be calculated> -crc32_Big_endian <address to store CRC> -crop <address range where CRC is stored> -o --hex-dump
    add_custom_command(
        TARGET ${TARGET_NAME} POST_BUILD
        COMMAND srec_cat "${TGT_PATH}.${FILE_SUFFIX}" -${FILE_TYPE}
                         -fill 0xFF ${START_ADDR} ${END_ADDR}
                         -crop ${START_ADDR} ${END_ADDR}
                         -${CRC_ALGO} ${CRC_ADDR}
                         #-crop ${CRC_ADDR}
                         -o "${TGT_PATH}_signed.${FILE_SUFFIX}" -${FILE_TYPE}
        VERBATIM
    )
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E echo "Signed ${TGT_PATH}.${FILE_SUFFIX}"
    )
  endif()
endfunction()

function(convertBinary
    TARGET_NAME
    TARGET_NAME_SUFFIX
    SRC_FILE_SUFFIX
    TGT_FILE_SUFFIX
    OFFSET
)
  __construct_path(${TARGET_NAME} TGT_PATH)
  __determine_binary_format(${SRC_FILE_SUFFIX} SRC_FILE_TYPE)
  __determine_binary_format(${TGT_FILE_SUFFIX} TGT_FILE_TYPE)


 if (NOT SREC_CAT)
    message(WARNING "srec_cat not found in path. Not converting ${TARGET_NAME}" )
  else()
    message(STATUS "Output will be converted: ${TARGET_NAME}.${FILE_SUFFIX}" )
      add_custom_command(
        TARGET ${TARGET_NAME} POST_BUILD
        COMMAND srec_cat "${TGT_PATH}${TARGET_NAME_SUFFIX}.${SRC_FILE_SUFFIX}" -${SRC_FILE_TYPE}
                         -offset ${OFFSET}
                         -o "${TGT_PATH}${TARGET_NAME_SUFFIX}.${TGT_FILE_SUFFIX}" -${TGT_FILE_TYPE}
        VERBATIM
    )
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E echo "converted ${TGT_PATH}${TARGET_NAME_SUFFIX}.${SRC_FILE_SUFFIX} to ${TGT_PATH}${TARGET_NAME_SUFFIX}.${TGT_FILE_SUFFIX}  "
    )
  endif()
endfunction()
