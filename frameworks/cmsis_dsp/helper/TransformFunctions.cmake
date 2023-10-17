set(CMSIS_DSP_Source_TransformFunctions_PATH      ${cmsis_dsp_SOURCE_DIR}/Source/TransformFunctions)

# Set some variables
if ((NOT ARMAC5) AND (NOT DISABLEFLOAT16))
    set(ArmAC5 true)
endif()

if (WRAPPER)
    set(Wrapper true)
endif()

set(TransformFunctions_SOURCES
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_bitreversal.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_bitreversal2.c
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_bitreversal_f16.c>
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix2_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix8_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_init_f32.c
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix2_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_init_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_init_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_f16.c>
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_f64.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_init_f64.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix2_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_init_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix2_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_init_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_dct4_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_dct4_init_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_init_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_init_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_dct4_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_dct4_init_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_init_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_init_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_init_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_dct4_init_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_dct4_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_init_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_init_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_init_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_fast_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_fast_init_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_init_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix8_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_fast_f64.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_fast_init_f64.c
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_fast_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_fast_init_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_init_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix8_f16.c>
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_init_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_init_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_init_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_init_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_init_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_rfft_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_init_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_q31.c
    $<$<BOOL:${Wrapper}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix2_init_q15.c>
    $<$<BOOL:${Wrapper}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix2_init_q31.c>
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_init_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix4_init_q31.c
    # For scipy or wrappers or benchmarks
    $<$<BOOL:${Wrapper}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix2_init_f32.c>
    $<$<AND:$<BOOL:${Wrapper}>,$<BOOL:${ArmAC5}>>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_cfft_radix2_init_f16.c>
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_mfcc_init_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_mfcc_f32.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_mfcc_init_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_mfcc_q31.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_mfcc_init_q15.c
    ${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_mfcc_q15.c
    $<$<BOOL:${ArmC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_mfcc_init_f16.c>
    $<$<BOOL:${ArmC5}>:${CMSIS_DSP_Source_TransformFunctions_PATH}/arm_mfcc_f16.c>
)

set(ArmC5)
set(Wrapper)
