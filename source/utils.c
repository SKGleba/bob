#include "include/types.h"
#include "include/clib.h"
#include "include/compile_time.h"
#include "include/utils.h"

void delay(int n) {
    volatile int i, j;
    for (i = 0; i < n; i++)
        for (j = 0; j < 200; j++)
            ;
}

__attribute__((noinline, optimize("O0")))
int cbus_read(uint16_t cb_line) {
    asm(
        "movu $3, cbr+2\n"
        "sh %[cb_line], ($3)\n"
        ".word 0x0\n"
        ".word 0x0\n"
        ".word 0x0\n"
        ".word 0x0\n"
        ".global cbr\n"
        "cbr:\n"
        ".word 0xf014\n"
        :
        : [cb_line] "r" (cb_line)
        : "$3", "$0"
    );
    register uint32_t ret asm("$0");
    return ret;
}

__attribute__((noinline, optimize("O0")))
void cbus_write(uint16_t cb_line, uint32_t data) {
    asm(
        "movu $3, cbw+2\n"
        "sh %[cb_line], ($3)\n"
        "mov %[data], $2\n"
        ".word 0x0\n"
        ".word 0x0\n"
        ".word 0x0\n"
        ".word 0x0\n"
        ".global cbw\n"
        "cbw:\n"
        ".word 0xf204\n"
        :
        : [data] "r" (data),
        [cb_line] "r" (cb_line)
        : "$2", "$3"
    );
}

__attribute__((noinline, optimize("O0")))
void set_dbg_mode(bool debug_mode) {
    if (!debug_mode) {
        asm(
            "ldc $0, $lp\n"
            "stc $0, $depc\n"
            "mov $0, $0\n" // per standard - no dret after stc ->depc
            "dret\n"
        );
    } else
        asm("dbreak\n");
}

__attribute__((noinline))
uint32_t get_build_timestamp(void) {
    return (uint32_t)UNIX_TIMESTAMP;
}

__attribute__((noinline, optimize("O0")))
bool enable_icache(bool cache) {
    register volatile uint32_t cfg asm("cfg");
    if (cache)
        cfg = (cfg & ~0x2) | 0x2;
    else
        cfg = cfg & ~0x2;
    
    _MEP_SYNC_BUS_
        
    return !!(cfg & 0x2);
}