#ifndef __DEBUG_H__
#define __DEBUG_H__

#include "types.h"
#include "defs.h"
#include "utils.h"
#include "uart.h"

// codes 0x1-0x2f are reserved for bob use
#ifdef NO_STATUS_LED
#define statusled(x)
#else
#define statusled(x) debug_setGpoCode(x)
#endif

enum STATUSLED_CODES {  // inits, exceptions, command handlers
    STATUS_INIT_CFG = 1,
    STATUS_INIT_UART,
    STATUS_INIT_ICACHE,
    STATUS_INIT_RESET,
    STATUS_GLINIT_GPIO,
    STATUS_GLINIT_ERNIE,
    STATUS_GLINIT_JIG,
    STATUS_GLINIT_UART,
    STATUS_GLINIT_RPC,
    STATUS_TEST_STARTING,
    STATUS_CEFW_OFF_ICACHE,
    STATUS_CEFW_CCODE,
    STATUS_CEFW_ON_ICACHE,
    STATUS_CEFW_NEXT,
    STATUS_CEFW_DONE_WAIT,
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
    STATUS_RPC_EXIT,
    STATUS_RPC_BLOCKED,
    STATUS_RPC_BLOCKED2
};

#ifdef SILENT

#define print(str)
#define printf
#define printn(str, n)
#define printx(x)
#define printp(x)
#define _hexdump(addr, length)
#define _hexdump_addr(addr, length, show_addr)
#define _hexdump_full(addr, length, show_addr, delim)

#else

#define print(str) uart_print(UART_BUS_COUNT, (char *)(str))
#define printf debug_printFormat
#define printn(str, n) uart_printn(UART_BUS_COUNT, (char *)(str), n)
#define printx(x) debug_printU32((uint32_t)(x), true)
#define printp(x) printf("%X: %X\n", (uint32_t)(x), vp (x))
#define _hexdump(addr, length) debug_printRange((uint32_t)addr, length, 1, ' ')
#define _hexdump_addr(addr, length, show_addr) debug_printRange((uint32_t)addr, length, show_addr, ' ')
#define _hexdump_full(addr, length, show_addr, delim) debug_printRange((uint32_t)addr, length, show_addr, delim)

#endif

#define hexdump(...) FUN_VAR4(__VA_ARGS__, _hexdump_full, _hexdump_addr, _hexdump)(__VA_ARGS__)

// get a "\r\n" terminated string from debug uart
#define scans(string_buf, max_len) uart_scanns(UART_BUS_COUNT, (char *)string_buf, max_len, 0)
#define scans_timeout(string_buf, max_len, timeout) uart_scanns(UART_BUS_COUNT, (char *)string_buf, max_len, timeout)

// get [count] bytes from debug uart
#define scanb(bytes_buf, count) uart_scann(UART_BUS_COUNT, (uint8_t *)bytes_buf, count, 0)
#define scanb_timeout(bytes_buf, count, timeout) uart_scann(UART_BUS_COUNT, (uint8_t *)bytes_buf, count, timeout)

#define rxflush() uart_rxfifo_flush(UART_BUS_COUNT)

#ifndef DEBUG_UNUSE
void debug_printU32(uint32_t value, int add_nl);
void debug_printRange(uint32_t addr, uint32_t size, int show_addr, char delim);
void debug_setGpoCode(uint8_t code);
#else
#define debug_printU32(value, add_nl) stub()
#define debug_printRange(addr, size, show_addr, delim) stub()
#define debug_setGpoCode(code) stub()
#endif

void debug_printFormat(char *base, ...);

#ifdef ENABLE_REGDUMP
extern void debug_s_regdump(void);
#define regdump debug_s_regdump
#endif

#endif