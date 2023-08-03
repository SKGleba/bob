#ifndef __DEBUG_H__
#define __DEBUG_H__

#include "types.h"
#include "defs.h"
#include "uart.h"

// codes 0x1-0x2f are reserved for bob use
#ifdef NO_STATUS_LED
#define statusled(x)
#else
#define statusled(x) debug_setGpoCode(x)
#endif

enum STATUSLED_CODES { // inits, exceptions, command handlers
    STATUS_INIT_CEFW = 1,
    STATUS_INIT_UART,
    STATUS_INIT_TEST,
    STATUS_INIT_ICACHE,
    STATUS_INIT_RESET,
    STATUS_GLINIT_GPIO,
    STATUS_GLINIT_ERNIE,
    STATUS_GLINIT_JIG,
    STATUS_GLINIT_UART,
    STATUS_GLINIT_TEST,
    STATUS_GLINIT_RPC,
    STATUS_CEFW_OFF_ICACHE,
    STATUS_CEFW_CCODE,
    STATUS_CEFW_ON_ICACHE,
    STATUS_CEFW_WAIT,
    STATUS_RESET_HIT,
    STATUS_SWI_HIT,
    STATUS_SWI_QUIT,
    STATUS_IRQ_HIT,
    STATUS_IRQ_QUIT,
    STATUS_ARM_HIT,
    STATUS_ARM_QUIT,
    STATUS_OTHER_INT_HIT,
    STATUS_OTHER_EXC_HIT,
    STATUS_PANIC_HIT,
    STATUS_DBG_HIT,
    STATUS_DBG_QUIT,
    STATUS_COMPAT_RESET_PERV,
    STATUS_COMPAT_CRY2ARM0,
    STATUS_COMPAT_SKSO,
    STATUS_COMPAT_ARMDED,
    STATUS_COMPAT_FEXSM,
    STATUS_COMPAT_HANDLE,
    STATUS_RPC_WAIT,
    STATUS_RPC_CHECK,
    STATUS_RPC_READ,
    STATUS_RPC_EXECUTE,
    STATUS_RPC_WRITE,
    STATUS_RPC_EXIT
};

#ifdef SILENT

#define print(str)
#define printf
#define printn(str, n)
#define printx(x)
#define printp(x)
#define hexdump(addr, length, show_addr)

#else

#define print(str) uart_print(g_uart_bus, (char *)(str))
#define printf debug_printFormat
#define printn(str, n) uart_printn(g_uart_bus, (char *)(str), n)
#define printx(x) debug_printU32((uint32_t)(x), true)
#define printp(x) printf("%X: %X\n", (uint32_t)(x), vp (x))
#define hexdump(addr, length, show_addr) debug_printRange((char*)(addr), length, (int)show_addr)

#endif

void debug_printU32(uint32_t value, int add_nl);
void debug_printFormat(char* base, ...);
void debug_printRange(char* addr, uint32_t size, int show_addr);
void debug_setGpoCode(uint8_t code);

#ifdef ENABLE_REGDUMP
extern void debug_s_regdump(void);
#define regdump debug_s_regdump
#endif

#endif