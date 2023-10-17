
set(CMSIS_DSP_Source_ControllerFunctions_PATH      ${cmsis_dsp_SOURCE_DIR}/Source/ControllerFunctions)

set(ControllerFunctions_SOURCES
    ${CMSIS_DSP_Source_ControllerFunctions_PATH}/arm_pid_init_f32.c
    ${CMSIS_DSP_Source_ControllerFunctions_PATH}/arm_pid_init_q15.c
    ${CMSIS_DSP_Source_ControllerFunctions_PATH}/arm_pid_init_q31.c
    ${CMSIS_DSP_Source_ControllerFunctions_PATH}/arm_pid_reset_f32.c
    ${CMSIS_DSP_Source_ControllerFunctions_PATH}/arm_pid_reset_q15.c
    ${CMSIS_DSP_Source_ControllerFunctions_PATH}/arm_pid_reset_q31.c
    ${CMSIS_DSP_Source_ControllerFunctions_PATH}/arm_sin_cos_f32.c
    ${CMSIS_DSP_Source_ControllerFunctions_PATH}/arm_sin_cos_q31.c
)
