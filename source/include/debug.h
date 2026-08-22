#ifndef __DEBUG_H__
#define __DEBUG_H__

#include "types.h"
#include "defs.h"
#include "utils.h"
#include "uart.h"

#ifdef DEBUG_UNUSE
#define DEBUG_STATUSLED_UNUSE
#define DEBUG_PRINTS_UNUSE
#define DEBUG_REGDUMP_UNUSE
#define DEBUG_ROUTER_UNUSE
#define DEBUG_NOLEVELS // dont need to set it but eh
#endif
#ifdef DEBUG_PRINTS_UNUSE
#define DEBUG_REGDUMP_UNUSE
#endif

enum DEBUG_ROUTES {
    DEBUG_ROUTE_UART = 0,
    DEBUG_ROUTE_NONE
};
#define DBGR_UART_BUS UART_BUS_COUNT // default bus for uart debug route
extern int g_debug_route;

enum DEBUG_LEVELS {
    DEBUG_LEVEL_NONE = 0,
    DEBUG_LEVEL_ERROR,
    DEBUG_LEVEL_WARN,
    DEBUG_LEVEL_INFO
};
extern int g_debug_level;
#ifndef DEBUG_NOLEVELS
#define DBG_GATE(_l, ...) if (g_debug_level >= _l) { __VA_ARGS__; }
#else
#define DBG_GATE(_l, ...) { __VA_ARGS__; }
#endif

enum STATUSLED_CODES {  // inits, exceptions, command handlers
    STATUS_INIT_CFG = 1,
    STATUS_INIT_UART,
    STATUS_INIT_HEAP,
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
#define printf(...)
#define printn(str, n)
#define printx(x)
#define printp(x)
#define _hexdump(addr, length)
#define _hexdump_addr(addr, length, show_addr)
#define _hexdump_full(addr, length, show_addr, delim)

#define ERRORFL(...)
#define ERRORF(...)
#define ERROR(...)
#define WARNFL(...)
#define WARNF(...)
#define WARN(...)
#define INFOFL(...)
#define INFOF(...)
#define INFO(...)

#else

#define print(_str) dbgr_print(_str, 0)
#define printn(_str, _n) dbgr_print(_str, _n)
#define printf debug_printFormat
#define printfl(_str, ...) printf("%s:%d: " _str, __FUNCTION__, __LINE__, __VA_ARGS__)
#define printx(_x) printf("0x%08X\n", (uint32_t)(_x))
#define printp(_x) printf("0x%08X: %08X\n", (uint32_t)(_x), vp (_x))
#define _hexdump(addr, length) debug_printRange((uint32_t)addr, length, 1, ' ')
#define _hexdump_addr(addr, length, show_addr) debug_printRange((uint32_t)addr, length, show_addr, ' ')
#define _hexdump_full(addr, length, show_addr, delim) debug_printRange((uint32_t)addr, length, show_addr, delim)

#define ERROR(_s) DBG_GATE(DEBUG_LEVEL_ERROR, print(_s))
#define ERRORF(...) DBG_GATE(DEBUG_LEVEL_ERROR, printf(__VA_ARGS__))
#define ERRORFL(_s, ...) DBG_GATE(DEBUG_LEVEL_ERROR, printfl(_s, __VA_ARGS__))

#ifndef DEBUG_ONLYERR
#define WARN(_s) DBG_GATE(DEBUG_LEVEL_WARN, print(_s))
#define WARNF(...) DBG_GATE(DEBUG_LEVEL_WARN, printf(__VA_ARGS__))
#define WARNFL(_s, ...) DBG_GATE(DEBUG_LEVEL_WARN, printfl(_s, __VA_ARGS__))
#define INFO(_s) DBG_GATE(DEBUG_LEVEL_INFO, print(_s))
#define INFOF(...) DBG_GATE(DEBUG_LEVEL_INFO, printf(__VA_ARGS__))
#define INFOFL(_s, ...) DBG_GATE(DEBUG_LEVEL_INFO, printfl(_s, __VA_ARGS__))
#else
#define WARN(_s)
#define WARNF(...)
#define WARNFL(_s, ...)
#define INFO(_s)
#define INFOF(...)
#define INFOFL(_s, ...)
#endif

#endif

#define hexdump(...) FUN_VAR4(__VA_ARGS__, _hexdump_full, _hexdump_addr, _hexdump)(__VA_ARGS__)

// get a "\r\n" terminated string from debug uart
#define scans(string_buf, max_len) dbgr_scan((char *)string_buf, max_len, true, 0)
#define scans_timeout(string_buf, max_len, timeout) dbgr_scan((char *)string_buf, max_len, true, timeout)

// get [count] bytes from debug uart
#define scanb(bytes_buf, count) dbgr_scan((uint8_t *)bytes_buf, count, false, 0)
#define scanb_timeout(bytes_buf, count, timeout) dbgr_scan((uint8_t *)bytes_buf, count, false, timeout)

#define rxflush() dbgr_flush(false)

// NO STUBBING - if disabled but used, enforce a compile error
#ifndef DEBUG_ROUTER_UNUSE
void dbgr_print(char *str, int len);
int dbgr_scan(void *out, int n, bool str, unsigned int timeout);
void dbgr_flush(bool tx);
#endif

#ifndef DEBUG_PRINTS_UNUSE
void debug_printHU64(uint64_t value, unsigned int nob, bool upper);
void debug_printDI32(int value, unsigned int nob);
void debug_printRange(uint32_t addr, uint32_t size, int show_addr, char delim);
#else
#define debug_printHU64(value, nob, upper) stub()
#define debug_printDI32(value, nob) stub()
#define debug_printRange(addr, size, show_addr, delim) stub()
#endif

// codes 0x1-0x2f are reserved for bob use
#ifdef DEBUG_STATUSLED_UNUSE
#define statusled(x)
#define debug_setGpoCode(code) stub()
#else
void debug_setGpoCode(uint8_t code);
#define statusled(x) debug_setGpoCode(x)
#endif

void debug_printFormat(char *base, ...);

#ifndef DEBUG_REGDUMP_UNUSE
extern void debug_s_regdump(void);
#define regdump debug_s_regdump
#endif

#endif