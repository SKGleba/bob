#include "include/types.h"
#include "include/uart.h"
#include "include/clib.h"
#include "include/utils.h"
#include "include/defs.h"
#include "include/gpio.h"
#include "include/debug.h"

#ifndef DEBUG_ROUTER_UNUSE
void dbgr_print(char *str, int len) {
    switch (g_debug_route) {
        case DEBUG_ROUTE_UART:
            if (len)
                uart_printn(DBGR_UART_BUS, str, len);
            else
                uart_print(DBGR_UART_BUS, str);
            break;
        default:
            break;
    }
    return;
}

int dbgr_scan(void *out, int n, bool str, unsigned int timeout) {
    switch (g_debug_route) {
        case DEBUG_ROUTE_UART:
            if (str)
                return uart_scanns(DBGR_UART_BUS, (char *)out, n, timeout);
            else
                return uart_scann(DBGR_UART_BUS, (uint8_t *)out, n, timeout);
            break;
        default:
            break;
    }
    return 0;
}

void dbgr_flush(bool tx) {
    switch (g_debug_route) {
        case DEBUG_ROUTE_UART:
            if (!tx)
                uart_rxfifo_flush(DBGR_UART_BUS);
            break;
        default:
            break;
    }
    return;
}
#endif

#ifndef DEBUG_PRINTS_UNUSE
static const char debug_hexbase[] = "0123456789ABCDEF";
void debug_printHU64(uint64_t value, unsigned int nob, bool upper) {
    char a_buf[16];
    int nonzb = 1;
    for (int i = 0; i < 8; i++) {
        char l = debug_hexbase[value & 0x0F];
        char h = debug_hexbase[(value & 0xF0) >> 4];
        a_buf[15 - i * 2] = (!upper && l >= 'A') ? (l + 0x20) : l;
        a_buf[14 - i * 2] = (!upper && h >= 'A') ? (h + 0x20) : h;
        if (value & 0xFF) {
            if (value & 0xF0)
                nonzb = (i * 2) + 2;
            else
                nonzb = (i * 2) + 1;
        }
        value >>= 8;
    }

    if (nob > 16)
        nob = 16;
    else if (!nob)
        nob = nonzb;

    dbgr_print(a_buf + (16 - nob), nob);
}

void debug_printDI32(int value, unsigned int nob) {
    char a_buf[10];
    uint32_t uvalue = (value < 0) ? (0U - (uint32_t)(value)) : (uint32_t)value;
    int nonzb = 1;
    for (int i = 0; i < 10; i++) {
        a_buf[9 - i] = debug_hexbase[uvalue % 10];
        if (uvalue)
            nonzb = i + 1;
        uvalue /= 10;
    }
    if (nob > 10)
        nob = 10;
    else if (!nob)
        nob = nonzb;

    if (value < 0)
        dbgr_print("-", 1);
    dbgr_print(a_buf + (10 - nob), nob);
}

// dumbed down printf
void debug_printFormat(char* base, ...) {
    int base_len = strlen(base);
    if (!base_len)
        return;

    va_list args;
    va_start(args, base);

    int v_pos = 0, i = 0;
    for (i = 0; i < base_len; i++) {
        if (base[i] != '%')
            continue;
        
        dbgr_print(base + v_pos, i - v_pos);
        
        int ogi = i;
        i++;

        // TODO var pad ch
        unsigned int nob = 0;
        while (base[i] <= '9' && base[i] >= '0') {
            nob = (nob * 10) + (base[i] - '0');
            i++;
        }

L_printf_cswitch:
        switch (base[i]) {
        case 'l':
            if (base[i + 1] == 'l') { // ll=64bit
                i++;
                switch (base[i + 1]) {
                case 'X':
                case 'x':
                    debug_printHU64(va_arg(args, uint64_t), nob, (base[i + 1] == 'X'));
                    break;
                default:
                    continue;
                }
                i++;
            } else {
                i++;
                goto L_printf_cswitch;
            }
            break;
        case 'X':
        case 'x':
            debug_printHU64((uint64_t)va_arg(args, uint32_t), nob, (base[i] == 'X'));
            break;
        case 's':
            dbgr_print((char*)va_arg(args, char*), nob);
            break;
        case 'd':
            debug_printDI32(va_arg(args, int), nob);
            break;
        case 'c':
            dbgr_print((char*)&(char){va_arg(args, int)}, 1);
            break;
        default:
            dbgr_print(base + ogi, i - ogi + 1);
            break;
        }

        i++;
        v_pos = i;
    }

    va_end(args);

    dbgr_print(base + v_pos, i - v_pos);
}

static void printRange32(uint32_t* addr, uint32_t size, bool show_addr, char delim) {
    if (!size)
        return;

    if (show_addr)
        debug_printFormat("%08X: ", addr);

    uint32_t data = 0;
    for (uint32_t off = 0; off < size; off -= -4) {
        data = addr[(off >> 2)];
        for (int i = 0; i < 4; i++) {
            debug_printFormat("%02X%c", (data & 0xFF), delim);
            data >>= 8;
        }
        if ((off & 0xc) == 0xc) {
            dbgr_print("\n", 1);
            if (show_addr && off + 4 < size)
                debug_printFormat("%08X: ", addr + (off >> 2) + 1);
        }
    }

    dbgr_print("\n", 1);
}

static void printRange8(char* addr, uint32_t size, bool show_addr, char delim) {
    if (!size)
        return;

    if (show_addr)
        debug_printFormat("%08X: ", addr);

    for (uint32_t off = 0; off < size; off -= -1) {
        debug_printFormat("%c%c%c", debug_hexbase[(addr[off] & 0xF0) >> 4], debug_hexbase[addr[off] & 0x0F], delim);
        if ((off & 0xf) == 0xf) {
            dbgr_print("\n", 1);
            if (show_addr && off + 1 < size)
                debug_printFormat("%08X: ", addr + off + 1);
        }
    }

    dbgr_print("\n", 1);
}

static void printRangeSS(uint8_t* addr, uint32_t size, bool show_addr) {
    if (!size)
        return;

    if (show_addr)
        debug_printFormat("%08X: ", addr);

    for (uint32_t off = 0; off < size; off -= -1) {
        debug_printFormat("%c%c", debug_hexbase[(addr[off] & 0xF0) >> 4], debug_hexbase[addr[off] & 0x0F]);
    }

    dbgr_print("\n", 1);
}

void debug_printRange(uint32_t addr, uint32_t size, bool show_addr, char delim) {
    if (!size)
        return;

    if (delim) {
        if (((uint32_t)addr | (uint32_t)size) & 3)
            printRange8((char*)addr, size, show_addr, delim);
        else
            printRange32((uint32_t*)addr, size, show_addr, delim);
    } else
        printRangeSS((uint8_t*)addr, size, show_addr);
}

#else

void debug_printFormat(char* base, ...) {
    WARN("[BOB] debug_printFormat called when disabled!");
    _MEP_SYNC_BUS_
}

#endif

#ifndef DEBUG_STATUSLED_UNUSE
void debug_setGpoCode(uint8_t code) {
    volatile unsigned int* gpio_regs = GPIO_REGS(0);
    gpio_regs[3] = 0xff0000;
    gpio_regs[0xD];
    gpio_regs[2] = (code & 0xff) << 0x10;
    gpio_regs[0xD];
}
#endif

#ifndef DEBUG_REGDUMP_UNUSE
#ifndef DEBUG_REGDUMP_SMALL
static const char* regdump_registers[48] = {
    "$0", "$1", "$2", "$3", "$4", "$5", "$6", "$7",
    "$8", "$9", "$10", "$11", "$12", "$tp", "$gp", "$sp",
    "$pc", "$lp", "$sar", "3", "$rpb", "$rpe", "$rpc", "$hi",
    "$lo", "9", "10", "11", "$mb0", "$me0", "$mb1", "$me1",
    "$psw", "$id", "$tmp", "$epc", "$exc", "$cfg", "22", "$npc",
    "$dbg", "$depc", "$opt", "$rcfg", "$ccfg", "29", "30", "31"
};
#endif

void debug_c_regdump(uint32_t *regs) {
    ERROR("CORE:\n");
    for (int i = 0; i < 48; i++) {
        if (i == 16)
            ERROR("\nCONTROL:\n");
#ifdef DEBUG_REGDUMP_SMALL
        ERRORF(" %d: 0x%08X\n", i, regs[i]);
#else
        ERRORF(" %s: 0x%08X\n", regdump_registers[i], regs[i]);
#endif
    }
}

#else

void debug_c_regdump(void) {
    WARN("[BOB] regdump called when disabled!");
    _MEP_SYNC_BUS_
}

#endif