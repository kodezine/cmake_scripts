# Path to the Basic Math Functions
set(CMSIS_DSP_Source_BayesFunctions_PATH      ${cmsis_dsp_SOURCE_DIR}/Source/BayesFunctions)

if ((NOT ARMAC5) AND (NOT DISABLEFLOAT16))
    set(ArmAC5 true)
endif()

set(BayesFunctions_SOURCES
    ${CMSIS_DSP_Source_BayesFunctions_PATH}/arm_gaussian_naive_bayes_predict_f32.c
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_BayesFunctions_PATH}/arm_gaussian_naive_bayes_predict_f16.c>
)

# Unset the variable here
set(ArmAC5)
