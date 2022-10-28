#include "include/types.h"
#include "include/uart.h"
#include "include/clib.h"
#include "include/utils.h"
#include "include/defs.h"
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

void debug_printRange(char* addr, uint32_t size, bool show_addr) {
    if (!size)
        return;

    if (show_addr)
        printf("%X: ", addr);

    char cwc[4];
    cwc[3] = 0;
    for (uint32_t off = 0; off < size; off -= -1) {
        cwc[0] = debug_hexbase[(addr[off] & 0xF0) >> 4];
        cwc[1] = debug_hexbase[addr[off] & 0x0F];
        cwc[2] = ' ';
        print(cwc);
        if ((off & 0xf) == 0xf) {
            print(" \n");
            if (show_addr && off + 1 < size)
                printf("%X: ", addr + off + 1);
        }
    }

    print(" \n");
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

void debug_regdump(void) {
    asm(
        "sw $0, 0x0($gp)\n"
        "sw $1, 0x4($gp)\n"
        "sw $2, 0x8($gp)\n"
        "sw $3, 0xC($gp)\n"
        "sw $4, 0x10($gp)\n"
        "sw $5, 0x14($gp)\n"
        "sw $6, 0x18($gp)\n"
        "sw $7, 0x1C($gp)\n"
        "sw $8, 0x20($gp)\n"
        "sw $9, 0x24($gp)\n"
        "sw $10, 0x28($gp)\n"
        "sw $11, 0x2C($gp)\n"
        "sw $12, 0x30($gp)\n"
        "sw $tp, 0x34($gp)\n"
        "sw $gp, 0x38($gp)\n"
        "sw $sp, 0x3C($gp)\n"
        "ldc $0, $pc\n"
        "sw $0, 0x40($gp)\n"
        "ldc $0, $lp\n"
        "sw $0, 0x44($gp)\n"
        "ldc $0, $sar\n"
        "sw $0, 0x48($gp)\n"
        "ldc $0, 3\n"
        "sw $0, 0x4C($gp)\n"
        "ldc $0, $rpb\n"
        "sw $0, 0x50($gp)\n"
        "ldc $0, $rpe\n"
        "sw $0, 0x54($gp)\n"
        "ldc $0, $rpc\n"
        "sw $0, 0x58($gp)\n"
        "ldc $0, $hi\n"
        "sw $0, 0x5C($gp)\n"
        "ldc $0, $lo\n"
        "sw $0, 0x60($gp)\n"
        "ldc $0, 9\n"
        "sw $0, 0x64($0)\n"
        "ldc $0, 10\n"
        "sw $0, 0x68($gp)\n"
        "ldc $0, 11\n"
        "sw $0, 0x6C($gp)\n"
        "ldc $0, $mb0\n"
        "sw $0, 0x70($gp)\n"
        "ldc $0, $me0\n"
        "sw $0, 0x74($gp)\n"
        "ldc $0, $mb1\n"
        "sw $0, 0x78($gp)\n"
        "ldc $0, $me1\n"
        "sw $0, 0x7C($gp)\n"
        "ldc $0, $psw\n"
        "sw $0, 0x80($gp)\n"
        "ldc $0, $id\n"
        "sw $0, 0x84($gp)\n"
        "ldc $0, $tmp\n"
        "sw $0, 0x88($gp)\n"
        "ldc $0, $epc\n"
        "sw $0, 0x8C($gp)\n"
        "ldc $0, $exc\n"
        "sw $0, 0x90($gp)\n"
        "ldc $0, $cfg\n"
        "sw $0, 0x94($gp)\n"
        "ldc $0, 22\n"
        "sw $0, 0x98($gp)\n"
        "ldc $0, $npc\n"
        "sw $0, 0x9C($gp)\n"
        "ldc $0, $dbg\n"
        "sw $0, 0xA0($gp)\n"
        "ldc $0, $depc\n"
        "sw $0, 0xA4($gp)\n"
        "ldc $0, $opt\n"
        "sw $0, 0xA8($gp)\n"
        "ldc $0, $rcfg\n"
        "sw $0, 0xAC($gp)\n"
        "ldc $0, $ccfg\n"
        "sw $0, 0xB0($gp)\n"
        "ldc $0, 29\n"
        "sw $0, 0xB4($gp)\n"
        "ldc $0, 30\n"
        "sw $0, 0xB8($gp)\n"
        "ldc $0, 31\n"
        "sw $0, 0xBC($gp)\n"
    );

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
#endif