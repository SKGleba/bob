#ifndef __DEFS_H__
#define __DEFS_H__

// hard definitions

#include "types.h"

#if defined(BOBT_GLITCH)
    #include "defs_glitc.h"
#elif defined(BOBT_FSM)
    #include "defs_fsm.h"
#else
    //#define SILENT // suppress prints
    #define CONFIG_ADD_TRANSLATORS // support older bob configs
    //#define NOKEYS // dont include any keys

    //#define DEBUG_UNUSE // dont include the debug code
    #ifndef DEBUG_UNUSE
        //#define DEBUG_STATUSLED_UNUSE // disable usage of devkit gpo leds as status output
        //#define DEBUG_PRINTS_UNUSE // disable\stub all print functions
        //#define DEBUG_REGDUMP_UNUSE // disable register dumping on exceptions
        //#define DEBUG_REGDUMP_SMALL // only display register number at regdump
        #define DEBUG_REGDUMP_EXC // regdump on exceptions/unk ints
        //#define DEBUG_ROUTER_UNUSE // disable the main debug router
        #define DEBUG_NOLEVELS // disable debug level filtering, all compiled prints will be shown
        //#define DEBUG_ONLYERR // only compile error prints
    #endif

    //#define UART_UNUSE // dont include the uart code
    #ifndef UART_UNUSE
        #define UART_BUS 0 // default uart bus to print to
        #define UART_RATE UART_BAUD_115200 // default uart baud rate
        //#define UART_NOINIT // dont include uart init code
    #endif

    //#define COMPAT_UNUSE // dont include the arm, alice and regina code
    #ifndef COMPAT_UNUSE
        //#define ALICE_UNUSE   // dont include the alice code
        //#define REGINA_UNUSE  // dont include the regina code
    #endif

    //#define CCX_UNUSE // disable the code exec framework
    #define DRAM_UNUSE // dont include the dram init code
    #define SDIF_UNUSE // dont include the storage/sdif code
    #define SDIF_NOINITS // dont include the storage/sdif init functions, requires ctx import
    //#define ERNIE_UNUSE // dont include the ernie code
    //#define I2C_UNUSE // dont include the i2c code

    #define HEAP_UNUSE // no dynamic mem mgr code
    #ifndef HEAP_UNUSE
        //#define HEAP_NODEBUG // disable verbose heap debug prints & funcs
        //#define HEAP_NOSMALL // dont use small block allocator
        #define HEAP_ONINIT 0x4 // initialize heap on init(), with 32 HEAP_ONINIT*4-sized small blocks
    #endif

    //#define GLITCH_UNUSE // dont include the glitch funcs
    #ifndef GLITCH_UNUSE
        #define GLITCH_SKIP_TEST // skip test() on glitch trigger
    #endif

    //#define RPC_UNUSE // dont include the rpc code
    #define RPC_READ_DELAY 0x1000 // delay between RPC checks
    #define RPC_WRITE_DELAY 0x80 // delay before replying to a RPC
    #define RPC_BLOCKED_DELAY 0x2800 // delay between g_status check for unblock
    #define RPC_UART_MODE false // use kermit UART by default for RPC comms
    #define RPC_UART_SCAN_TIMEOUT 0 // default timeout for uart rx scan, 0 to disable timeout

#endif

#endif // __DEFS_H__