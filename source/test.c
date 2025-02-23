#include <hardware/paddr.h>
#include <hardware/xbar.h>

#include "include/defs.h"
#include "include/debug.h"
#include "include/clib.h"
#include "include/compat.h"
#include "include/ernie.h"
#include "include/gpio.h"
#include "include/jig.h"
#include "include/maika.h"
#include "include/rpc.h"
#include "include/crypto.h"
#include "include/perv.h"
#include "include/i2c.h"
#include "include/uart.h"
#include "include/config.h"

#include "include/test.h"

// default init test function
void dfl_test(int arg) {
    printf("[BOB] test test test\n");

    if (arg & 1)
        set_dbg_mode(true);

    _MEP_SYNC_BUS_;

    printf("[BOB] killing arm...\n");
    compat_killArm(false);

    printf("[BOB] arm is dead, disable the OLED screen...\n");
    gpio_port_clear(0, GPIO_PORT_OLED);

    printf("[BOB] set max clock\n");
    vp 0xe3103040 = 0x10007;

    printf("[BOB] test test stuff\n");
    rpc_loop();

    printf("[BOB] all tests done\n");
}


// glitch init test function
void glitch_test(void) {
#ifndef SILENT
    statusled(0x31);
    hexdump(0x40000, 0x20000, true);
#endif

    statusled(0x32);
    for (uint32_t d_addr = 0x40000; d_addr < 0x60000; d_addr += 0x10)
        jig_update_shared_buffer((uint8_t*)d_addr, 0, 0x10, true);

    statusled(0x33);
    delay_nx(0x10000, 200);
}