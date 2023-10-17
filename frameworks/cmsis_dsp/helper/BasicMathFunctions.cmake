
# Path to the Basic Math Functions
set(CMSIS_DSP_Source_BasicMathFunctions_PATH        ${cmsis_dsp_SOURCE_DIR}/Source/BasicMathFunctions)


if ((NOT ARMAC5) AND (NOT DISABLEFLOAT16))
    set(ArmAC5 true)
endif()

set(SRCF64
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_abs_f64.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_add_f64.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_dot_prod_f64.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_mult_f64.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_negate_f64.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_offset_f64.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_scale_f64.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_sub_f64.c
)

set(SRCF32
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_abs_f32.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_add_f32.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_clip_f32.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_dot_prod_f32.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_mult_f32.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_negate_f32.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_offset_f32.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_scale_f32.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_sub_f32.c
)

set(SRCF16
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_abs_f16.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_add_f16.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_clip_f16.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_dot_prod_f16.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_mult_f16.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_negate_f16.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_offset_f16.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_scale_f16.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_sub_f16.c
)

set(SRCQ31
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_abs_q31.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_add_q31.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_clip_q31.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_dot_prod_q31.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_mult_q31.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_negate_q31.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_offset_q31.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_scale_q31.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_shift_q31.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_sub_q31.c
)

set(SRCQ15
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_abs_q15.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_add_q15.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_clip_q15.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_dot_prod_q15.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_mult_q15.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_negate_q15.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_offset_q15.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_scale_q15.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_shift_q15.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_sub_q15.c
)

set(SRCQ7
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_abs_q7.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_add_q7.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_clip_q7.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_dot_prod_q7.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_mult_q7.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_negate_q7.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_offset_q7.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_scale_q7.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_shift_q7.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_sub_q7.c
)

set(SRCU32
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_and_u32.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_not_u32.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_or_u32.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_xor_u32.c
)

set(SRCU16
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_and_u16.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_not_u16.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_or_u16.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_xor_u16.c
)

set(SRCU8
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_and_u8.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_or_u8.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_not_u8.c
    ${CMSIS_DSP_Source_BasicMathFunctions_PATH}/arm_xor_u8.c
)

set(BasicMathFunctions_SOURCES
    $<$<BOOL:${ArmAC5}>:${SRCF16}>
    ${SRCF64}
    ${SRCF32}
    ${SRCQ31}
    ${SRCQ15}
    ${SRCQ7}
    ${SRCU32}
    ${SRCU16}
    ${SRCU8}
)

# Unset the variable here
set(ArmAC5)
