#ifndef __DEFS_H__
#define __DEFS_H__

#include "types.h"

#if(false) // suppress prints
#define SILENT

#else

// uart bus to print to
#define UART_TX_BUS 1

#if(true) // enable/disable register dumping on exceptions
#define ENABLE_REGDUMP
    #if(false) // if set, only display register number
    #define REGDUMP_SMALL
    #endif
#endif

#endif

#endif