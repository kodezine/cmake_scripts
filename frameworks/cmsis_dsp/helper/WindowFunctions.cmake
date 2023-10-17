set(CMSIS_DSP_Source_WindowFunctions_PATH      ${cmsis_dsp_SOURCE_DIR}/Source/WindowFunctions)

# Set some variables
if ((NOT ARMAC5) AND (NOT DISABLEFLOAT16))
    set(ArmAC5 true)
endif()

set(WindowFunctions_SOURCES
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_welch_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_bartlett_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hamming_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hanning_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall3_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall4_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall3a_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall3b_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall4a_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_blackman_harris_92db_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall4b_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall4c_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft90d_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft95_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft116d_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft144d_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft169d_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft196d_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft223d_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft248d_f64.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_welch_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_bartlett_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hamming_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hanning_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall3_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall4_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall3a_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall3b_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall4a_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_blackman_harris_92db_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall4b_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_nuttall4c_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft90d_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft95_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft116d_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft144d_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft169d_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft196d_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft223d_f32.c
${CMSIS_DSP_Source_WindowFunctions_PATH}/arm_hft248d_f32.c
)

set(ArmAC5)

