# path is set
set(CMSIS_DSP_Source_QuaternionMathFunctions_PATH   ${cmsis_dsp_SOURCE_DIR}/Source/QuaternionMathFunctions)

set(QuaternionMathFunctions_SOURCES
    ${CMSIS_DSP_Source_QuaternionMathFunctions_PATH}/arm_quaternion_norm_f32.c
    ${CMSIS_DSP_Source_QuaternionMathFunctions_PATH}/arm_quaternion_inverse_f32.c
    ${CMSIS_DSP_Source_QuaternionMathFunctions_PATH}/arm_quaternion_conjugate_f32.c
    ${CMSIS_DSP_Source_QuaternionMathFunctions_PATH}/arm_quaternion_normalize_f32.c
    ${CMSIS_DSP_Source_QuaternionMathFunctions_PATH}/arm_quaternion_product_single_f32.c
    ${CMSIS_DSP_Source_QuaternionMathFunctions_PATH}/arm_quaternion_product_f32.c
    ${CMSIS_DSP_Source_QuaternionMathFunctions_PATH}/arm_quaternion2rotation_f32.c
    ${CMSIS_DSP_Source_QuaternionMathFunctions_PATH}/arm_rotation2quaternion_f32.c
)
