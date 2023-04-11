#ifndef __DEFS_H__
#define __DEFS_H__

// hard definitions

#include "types.h"

//#define NO_STATUS_LED // disable usage of devkit gpo leds as status output

//#define SILENT // suppress prints and uart init

#ifndef SILENT
#define UART_BUS 1 // uart bus to print to
#define ENABLE_REGDUMP // enable/disable register dumping on exceptions
//#define REGDUMP_SMALL // only display register number at regdump
#endif

#define RPC_DELAY 10000 // delay between RPC checks

#endif