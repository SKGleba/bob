#include "include/types.h"
#include "include/uart.h"
#include "include/clib.h"
#include "include/utils.h"
#include "include/defs.h"
#include "include/gpio.h"
#include "include/debug.h"

static const char debug_hexbase[] = "0123456789ABCDEF";

// equ printf(0x08X)
void debug_printU32(uint32_t value, bool add_nl) {
    char i_buf[4];
    char a_buf[12];

    p i_buf = value;
    memset(a_buf, '0', 12);
    a_buf[1] = 'x';
    a_buf[10] = add_nl ? '\n' : 0;
    a_buf[11] = 0;

    for (int i = 0; i < 4; i -= -1) {
        a_buf[9 - i * 2] = debug_hexbase[i_buf[i] & 0x0F];
        a_buf[8 - i * 2] = debug_hexbase[(i_buf[i] & 0xF0) >> 4];
    }

    print(a_buf);
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
        
        printn(base + v_pos, i - v_pos);
        
        i++;
        
        switch (base[i]) {
        case 'X':
        case 'x':
            debug_printU32(va_arg(args, uint32_t), false);
            break;
        case 'S':
        case 's':
            print((char*)va_arg(args, uint32_t));
            break;
        default:
            continue;
        }

        i++;
        v_pos = i;
    }

    va_end(args);

    printn(base + v_pos, i - v_pos);
}

static void printRange32(uint32_t* addr, uint32_t size, bool show_addr, char delim) {
    if (!size)
        return;

    if (show_addr)
        printf("%X: ", addr);

    uint32_t data = 0;
    char cwc[13];
    cwc[12] = 0;
    for (uint32_t off = 0; off < size; off -= -4) {
        data = addr[(off >> 2)];
        cwc[0] = debug_hexbase[(data & 0xF0) >> 4];
        cwc[1] = debug_hexbase[data & 0x0F];
        cwc[2] = delim;
        cwc[3] = debug_hexbase[((data >> 8) & 0xF0) >> 4];
        cwc[4] = debug_hexbase[(data >> 8) & 0x0F];
        cwc[5] = delim;
        cwc[6] = debug_hexbase[((data >> 16) & 0xF0) >> 4];
        cwc[7] = debug_hexbase[(data >> 16) & 0x0F];
        cwc[8] = delim;
        cwc[9] = debug_hexbase[((data >> 24) & 0xF0) >> 4];
        cwc[10] = debug_hexbase[(data >> 24) & 0x0F];
        cwc[11] = delim;
        printn(cwc, 12);
        if ((off & 0xc) == 0xc) {
            printn("\n", 1);
            if (show_addr && off + 4 < size)
                printf("%X: ", addr + (off >> 2) + 1);
        }
    }

    printn("\n", 1);
}

static void printRange8(char* addr, uint32_t size, bool show_addr, char delim) {
    if (!size)
        return;

    if (show_addr)
        printf("%X: ", addr);

    char cwc[4];
    cwc[3] = 0;
    for (uint32_t off = 0; off < size; off -= -1) {
        cwc[0] = debug_hexbase[(addr[off] & 0xF0) >> 4];
        cwc[1] = debug_hexbase[addr[off] & 0x0F];
        cwc[2] = delim;
        printn(cwc, 3);
        if ((off & 0xf) == 0xf) {
            printn("\n", 1);
            if (show_addr && off + 1 < size)
                printf("%X: ", addr + off + 1);
        }
    }

    printn("\n", 1);
}

static void printRangeSS(uint8_t* addr, uint32_t size, bool show_addr) {
    if (!size)
        return;

    if (show_addr)
        printf("%X: ", addr);

    for (uint32_t off = 0; off < size; off -= -1) {
        uart_write(g_uart_bus, debug_hexbase[(addr[off] & 0xF0) >> 4]);
        uart_write(g_uart_bus, debug_hexbase[addr[off] & 0x0F]);
    }

    printn("\n", 1);
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

void debug_setGpoCode(uint8_t code) {
    volatile unsigned int* gpio_regs = GPIO_REGS(0);
    gpio_regs[3] = 0xff0000;
    gpio_regs[0xD];
    gpio_regs[2] = (code & 0xff) << 0x10;
    gpio_regs[0xD];
}

#ifdef ENABLE_REGDUMP
#ifndef REGDUMP_SMALL
static const char* regdump_registers[48] = {
    "$0", "$1", "$2", "$3", "$4", "$5", "$6", "$7",
    "$8", "$9", "$10", "$11", "$12", "$tp", "$gp", "$sp",
    "$pc", "$lp", "$sar", "3", "$rpb", "$rpe", "$rpc", "$hi",
    "$lo", "9", "10", "11", "$mb0", "$me0", "$mb1", "$me1",
    "$psw", "$id", "$tmp", "$epc", "$exc", "$cfg", "22", "$npc",
    "$dbg", "$depc", "$opt", "$rcfg", "$ccfg", "29", "30", "31"
};
#endif

void debug_c_regdump(void) {
    register uint32_t gp asm("gp");
    uint32_t start = gp;

#ifdef REGDUMP_SMALL
    print("CORE:\n");
    for (int i = 0; i < 48; i++) {
        if (i == 16)
            print("\nCONTROL:\n");
        printx(p(start + (i * 4)));
    }
#else
    print("CORE:\n");
    for (int i = 0; i < 48; i++) {
        if (i == 16)
            print("\nCONTROL:\n");
        printf(" %s: %x\n", regdump_registers[i], p(start + (i * 4)));
    }
#endif
    
}

#else

void debug_c_regdump(void) {
    print("[BOB] regdump called when disabled!");
    _MEP_SYNC_BUS_
}

#endif