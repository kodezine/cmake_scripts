# Path to the Basic Math Functions
set(CMSIS_DSP_Source_ComplexMathFunctions_PATH      ${cmsis_dsp_SOURCE_DIR}/Source/ComplexMathFunctions)

if ((NOT ARMAC5) AND (NOT DISABLEFLOAT16))
    set(ArmAC5 true)
endif()

set(ComplexMathFunctions_SOURCES
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mag_q31.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mag_q15.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mag_fast_q15.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_conj_f32.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_conj_q15.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_conj_q31.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_dot_prod_f32.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_dot_prod_q15.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_dot_prod_q31.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mag_f32.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mag_f64.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mag_squared_f32.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mag_squared_f64.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mag_squared_q15.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mag_squared_q31.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mult_cmplx_f32.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mult_cmplx_f64.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mult_cmplx_q15.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mult_cmplx_q31.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mult_real_f32.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mult_real_q15.c
    ${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mult_real_q31.c

    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_conj_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_dot_prod_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mag_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mag_squared_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mult_cmplx_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_ComplexMathFunctions_PATH}/arm_cmplx_mult_real_f16.c>
)

# Unset the variable here
set(ArmAC5)
