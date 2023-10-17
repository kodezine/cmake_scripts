set(CMSIS_DSP_Source_FastMathFunctions_PATH      ${cmsis_dsp_SOURCE_DIR}/Source/FastMathFunctions)

# Set some variables
if ((NOT ARMAC5) AND (NOT DISABLEFLOAT16))
    set(ArmAC5 true)
endif()

set(FastMathFunctions_SOURCES
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_cos_f32.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_cos_q15.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_cos_q31.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_sin_f32.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_sin_q15.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_sin_q31.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_sqrt_q31.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_sqrt_q15.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_vlog_f32.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_vlog_f64.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_vexp_f32.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_vexp_f64.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_vlog_q31.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_vlog_q15.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_divide_q15.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_divide_q31.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_atan2_f32.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_atan2_q31.c
    ${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_atan2_q15.c
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_vlog_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_vexp_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_vinverse_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_FastMathFunctions_PATH}/arm_atan2_f16.c>
)

set(ArmAC5)
