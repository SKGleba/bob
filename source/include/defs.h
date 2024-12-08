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

#define RPC_READ_DELAY 0x1000 // delay between RPC checks
#define RPC_WRITE_DELAY 0x80 // delay before replying to a RPC
#define RPC_BLOCKED_DELAY 0x2800 // delay between g_status check for unblock
#define RPC_UART_MODE false // use kermit UART by default for RPC comms
#define RPC_UART_SCAN_TIMEOUT 0 // default timeout for uart rx scan, 0 to disable timeout

#define GLITCH_SKIP_TEST // skip test() on glitch trigger

//#define DRAM_UNUSE // dont include the dram init code (-1kb)
//#define SDIF_UNUSE // dont include the storage/sdif code (-6kb)
//#define SDIF_NOINITS // dont include the storage/sdif init functions (-2kb), requires ctx import
//#define COMPAT_UNUSE // dont include the arm, alice and regina code (-5kb)

#ifndef COMPAT_UNUSE
//#define ALICE_UNUSE   // dont include the alice code (-2kb)
//#define REGINA_UNUSE  // dont include the regina code (-1kb)
#endif

#endif