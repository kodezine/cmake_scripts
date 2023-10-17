set(CMSIS_DSP_Source_SVMFunctions_PATH      ${cmsis_dsp_SOURCE_DIR}/Source/SVMFunctions)

# Set some variables
if ((NOT ARMAC5) AND (NOT DISABLEFLOAT16))
    set(ArmAC5 true)
endif()

set(SVMFunctions_SOURCES
    ${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_linear_init_f32.c
    ${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_rbf_init_f32.c
    ${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_linear_predict_f32.c
    ${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_rbf_predict_f32.c
    ${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_polynomial_init_f32.c
    ${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_sigmoid_init_f32.c
    ${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_polynomial_predict_f32.c
    ${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_sigmoid_predict_f32.c
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_linear_init_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_rbf_init_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_linear_predict_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_rbf_predict_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_polynomial_init_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_sigmoid_init_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_polynomial_predict_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SVMFunctions_PATH}/arm_svm_sigmoid_predict_f16.c>
)

set(ArmAC5)
