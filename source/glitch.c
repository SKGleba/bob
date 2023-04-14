#include "include/types.h"

#include "include/defs.h"
#include "include/uart.h"
#include "include/maika.h"
#include "include/debug.h"
#include "include/ex.h"
#include "include/crypto.h"
#include "include/ernie.h"
#include "include/xbar.h"
#include "include/utils.h"
#include "include/clib.h"
#include "include/jig.h"
#include "include/gpio.h"
#include "include/perv.h"
#include "include/spi.h"
#include "include/rpc.h"

#include "include/glitch.h"

void glitch_test(void) {
    statusled(0x31);
    for (uint32_t d_addr = 0x40000; d_addr < 0x60000; d_addr += 0x10)
        jig_update_shared_buffer(d_addr, 0, 0x10, true);

#ifndef SILENT
    statusled(0x32);
    hexdump(0x40000, 0x20000, true);
#endif

    statusled(0x33);

    delay(20 * 1000 * 5);
}

void glitch_init(void) {
    _MEP_INTR_DISABLE_ // disable interrupts

#ifndef NO_STATUS_LED
    gpio_port_set(0, GPIO_PORT_PS_LED);
    statusled(STATUS_GLINIT_GPIO);
    gpio_init(true);
#else
    gpio_init(false);
#endif

    statusled(STATUS_GLINIT_ERNIE);
    ernie_init(true);

    statusled(STATUS_GLINIT_JIG);
    uint32_t msg = 0xCAFEBABE;
    jig_update_shared_buffer(&msg, 0, 4, true);

#ifndef SILENT
    statusled(STATUS_GLINIT_UART);
    uart_init(UART_BUS, UART_RATE);
    printf("[BOB] glitch_init bob [%X], me @ %X\n", get_build_timestamp(), glitch_init);
#endif

    // test test stuff
    statusled(STATUS_GLINIT_TEST);
    glitch_test();

    // start the rpc server
    statusled(STATUS_GLINIT_RPC);
    rpc_loop();
}