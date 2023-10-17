set(CMSIS_DSP_Source_InterpolationFunctions_PATH      ${cmsis_dsp_SOURCE_DIR}/Source/InterpolationFunctions)

# Set some variables
if ((NOT ARMAC5) AND (NOT DISABLEFLOAT16))
    set(ArmAC5 true)
endif()

set(InterpolationFunctions_SOURCES
    ${CMSIS_DSP_Source_InterpolationFunctions_PATH}/arm_bilinear_interp_f32.c
    ${CMSIS_DSP_Source_InterpolationFunctions_PATH}/arm_bilinear_interp_q15.c
    ${CMSIS_DSP_Source_InterpolationFunctions_PATH}/arm_bilinear_interp_q31.c
    ${CMSIS_DSP_Source_InterpolationFunctions_PATH}/arm_bilinear_interp_q7.c
    ${CMSIS_DSP_Source_InterpolationFunctions_PATH}/arm_linear_interp_f32.c
    ${CMSIS_DSP_Source_InterpolationFunctions_PATH}/arm_linear_interp_q15.c
    ${CMSIS_DSP_Source_InterpolationFunctions_PATH}/arm_linear_interp_q31.c
    ${CMSIS_DSP_Source_InterpolationFunctions_PATH}/arm_linear_interp_q7.c
    ${CMSIS_DSP_Source_InterpolationFunctions_PATH}/arm_spline_interp_f32.c
    ${CMSIS_DSP_Source_InterpolationFunctions_PATH}/arm_spline_interp_init_f32.c
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_InterpolationFunctions_PATH}/arm_bilinear_interp_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_InterpolationFunctions_PATH}/arm_linear_interp_f16.c>
)

set(ArmAC5)
