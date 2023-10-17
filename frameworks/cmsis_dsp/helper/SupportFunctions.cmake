set(CMSIS_DSP_Source_SupportFunctions_PATH      ${cmsis_dsp_SOURCE_DIR}/Source/SupportFunctions)

# Set some variables
if ((NOT ARMAC5) AND (NOT DISABLEFLOAT16))
    set(ArmAC5 true)
endif()

set(SupportFunctions_SOURCES
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_barycenter_f32.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_bitonic_sort_f32.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_bubble_sort_f32.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_copy_f32.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_copy_f64.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_copy_q15.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_copy_q31.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_copy_q7.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_f16_to_float.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_f16_to_q15.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_fill_f32.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_fill_f64.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_fill_q15.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_fill_q31.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_fill_q7.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_f64_to_float.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_f64_to_q31.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_f64_to_q15.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_f64_to_q7.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_float_to_f64.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_float_to_q15.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_float_to_q31.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_float_to_q7.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_heap_sort_f32.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_insertion_sort_f32.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_merge_sort_f32.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_merge_sort_init_f32.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_q15_to_f64.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_q15_to_float.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_q15_to_q31.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_q15_to_q7.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_q31_to_f64.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_q31_to_float.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_q31_to_q15.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_q31_to_q7.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_q7_to_f64.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_q7_to_float.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_q7_to_q15.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_q7_to_q31.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_quick_sort_f32.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_selection_sort_f32.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_sort_f32.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_sort_init_f32.c
    ${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_weighted_sum_f32.c
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_copy_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_fill_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_f16_to_q15.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_q15_to_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_float_to_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_f16_to_float.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_weighted_sum_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_barycenter_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_f16_to_f64.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_SupportFunctions_PATH}/arm_f64_to_f16.c>
)

set(ArmAC5)
