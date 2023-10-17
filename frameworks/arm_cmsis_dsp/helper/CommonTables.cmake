set(CMSIS_DSP_Source_CommonTables_PATH      ${cmsis_dsp_SOURCE_DIR}/Source/CommonTables)

# Set some variables
if ((NOT ARMAC5) AND (NOT DISABLEFLOAT16))
    set(ArmAC5 true)
endif()

if (NEON OR NEONEXPERIMENTAL)
    set(ArmIsNeon true)
endif()

if (HELIUM OR MVEF)
    set(ArmIsHelium true)
endif()

if (WRAPPER)
    set(ArmIsWrapper true)
endif()

set(CommonTables_SOURCES
    ${CMSIS_DSP_Source_CommonTables_PATH}/arm_common_tables.c
    ${CMSIS_DSP_Source_CommonTables_PATH}/arm_const_structs.c
    ${CMSIS_DSP_Source_CommonTables_PATH}/arm_const_structs_f16.c
    $<$<BOOL:${ArmIsNeon}>:${CMSIS_DSP_Source_CommonTables_PATH}/arm_cl_tables.c>
    $<$<BOOL:${ArmIsHelium}>:${CMSIS_DSP_Source_CommonTables_PATH}/arm_mve_tables_f16.c>
    $<$<BOOL:${ArmIsHelium}>:${CMSIS_DSP_Source_CommonTables_PATH}/arm_mve_tables.c>
)

# do some definitions based on wrapper flag
target_compile_definitions(${PROJECT_NAME}
    PUBLIC
        $<$<BOOL:${ArmIsWrapper}>:ARM_TABLE_BITREV_1024>
        $<$<BOOL:${ArmIsWrapper}>:ARM_TABLE_TWIDDLECOEF_F32_4096>
        $<$<BOOL:${ArmIsWrapper}>:ARM_TABLE_TWIDDLECOEF_Q31_4096>
        $<$<BOOL:${ArmIsWrapper}>:ARM_TABLE_TWIDDLECOEF_Q15_4096>
        $<$<AND:$<BOOL:${ArmIsWrapper}>,$<BOOL:${ArmAC5}>>:ARM_TABLE_TWIDDLECOEF_F16_4096>
)

# Unset the variable here
set(ArmAC5)
set(ArmIsNeon)
set(ArmIsHelium)
set(ArmIsWrapper)
