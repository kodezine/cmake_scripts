
#ifndef UNITY_CONFIG_H
#define UNITY_CONFIG_H
/** Unity based output on Segger RTT */
#include "SEGGER_RTT.h"

#define UNITY_OUTPUT_CHAR(a)                    SEGGER_RTT_PutChar(0, (char)a) /* RS232_putc(a) */
#define UNITY_OUTPUT_CHAR_HEADER_DECLARATION    SEGGER_RTT_(unsigned int, char) /* RS232_putc(int) */
#define UNITY_OUTPUT_START()                    SEGGER_RTT_Init() /* RS232_config(115200,1,8,0) */
#define UNITY_OUTPUT_COMPLETE()                 SEGGER_RTT_printf(0, "\nSTOP.\n\n"); \
                                               for (;;) { \
                                                ; \
                                                }
#if 0
#define UNITY_INCLUDE_EXEC_TIME
#define UNITY_EXEC_TIME_START()                 { Unity.CurrentTestStartTime = *((unsigned *)0xE000101C); }


#define UNITY_EXEC_TIME_STOP()                  { Unity.CurrentTestStopTime  = *((unsigned *)0xE000101C); }
#define UNITY_PRINT_EXEC_TIME()                 { \
            UNITY_UINT execTimeMs = (Unity.CurrentTestStopTime - Unity.CurrentTestStartTime); \
            UnityPrint(" ("); \
            UnityPrintNumberUnsigned(execTimeMs); \
            UnityPrint(" cycles)"); \
        }
#define UNITY_TIME_TYPE unsigned
#endif
#endif
