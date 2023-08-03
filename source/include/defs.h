#ifndef __DEFS_H__
#define __DEFS_H__

// hard definitions

#include "types.h"

#define NO_STATUS_LED // disable usage of devkit gpo leds as status output

//#define SILENT // suppress prints and uart init

#ifndef SILENT
#define UART_BUS 0 // default uart bus to print to
#define ENABLE_REGDUMP // enable/disable register dumping on exceptions
//#define REGDUMP_SMALL // only display register number at regdump
#endif

#define RPC_READ_DELAY 10000 // delay between RPC checks
#define RPC_WRITE_DELAY 512 // delay before replying to a RPC
#define RPC_BLOCKED_DELAY 256 // delay between g_status check for unblock

#endif