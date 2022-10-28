#ifndef __DEFS_H__
#define __DEFS_H__

// hard definitions

#include "types.h"

//#define SILENT // suppress prints and uart init

#ifndef SILENT
#define UART_BUS 1 // uart bus to print to
#define ENABLE_REGDUMP // enable/disable register dumping on exceptions
//#define REGDUMP_SMALL // only display register number at regdump
#endif

#endif