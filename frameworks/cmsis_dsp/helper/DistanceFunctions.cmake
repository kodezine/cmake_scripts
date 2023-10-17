set(CMSIS_DSP_Source_DistanceFunctions_PATH      ${cmsis_dsp_SOURCE_DIR}/Source/DistanceFunctions)

# Set some variables
if ((NOT ARMAC5) AND (NOT DISABLEFLOAT16))
    set(ArmAC5 true)
endif()

set(DistanceFunctions_SOURCES
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_boolean_distance.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_braycurtis_distance_f32.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_canberra_distance_f32.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_chebyshev_distance_f32.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_chebyshev_distance_f64.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_cityblock_distance_f32.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_cityblock_distance_f64.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_correlation_distance_f32.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_cosine_distance_f32.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_cosine_distance_f64.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_dice_distance.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_euclidean_distance_f32.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_euclidean_distance_f64.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_hamming_distance.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_jaccard_distance.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_jensenshannon_distance_f32.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_kulsinski_distance.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_minkowski_distance_f32.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_rogerstanimoto_distance.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_russellrao_distance.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_sokalmichener_distance.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_sokalsneath_distance.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_yule_distance.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_dtw_distance_f32.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_dtw_path_f32.c
    ${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_dtw_init_window_q7.c

    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_braycurtis_distance_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_canberra_distance_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_chebyshev_distance_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_cityblock_distance_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_correlation_distance_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_cosine_distance_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_euclidean_distance_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_jensenshannon_distance_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_DistanceFunctions_PATH}/arm_minkowski_distance_f16.c>
)

target_include_directories(${PROJECT_NAME} PRIVATE ${CMSIS_DSP_Source_DistanceFunctions_PATH})

set(ArmAC5)
