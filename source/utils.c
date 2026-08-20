#include "include/utils.h"

#include <hardware/maika.h>
#include <hardware/paddr.h>

#include "include/clib.h"
#include "include/compile_time.h"
#include "include/types.h"

void delay_nx(int n, int x) {
    volatile int i, j;
    for (i = 0; i < n; i++)
        for (j = 0; j < x; j++)
            ;
}

__attribute__((noinline))
uint32_t get_build_timestamp(void) {
    return (uint32_t)UNIX_TIMESTAMP;
}

void setup_ints(void) {
    cbus_write(3, 0);
    cbus_write(4, 0x07777777);
    cbus_write(5, 0x777f);
    cbus_write(6, 0);
    cbus_write(7, 0);
    cbus_write(0, 0x600);
    cbus_write(2, 0x100);
    asm(
        "ldc $0, $psw\n"
        "or3 $0, $0, 0x110\n"
        "stc $0, $psw\n"
    );
    ((maika_s*)MAIKA_OFFSET)->aio.control_0 |=
        (MAIKA_AIO_CONTROL0_ARM2CRY0 | MAIKA_AIO_CONTROL0_ARM2CRY1 | MAIKA_AIO_CONTROL0_ARM2CRY2 | MAIKA_AIO_CONTROL0_ARM2CRY3);
}

bool intr_mask(uint32_t num, bool change, bool set) {
    uint32_t mask = 1 << (num & 0x1f);
    uint32_t reg = cbus_read(0x2);
    if (change) {
        if (set)
            reg |= mask;
        else
            reg &= ~mask;
        cbus_write(0x2, reg);
    }
    return !!(reg & mask);
}

int stub() {
    return 0xD15AB2ED;
}