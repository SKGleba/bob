#include "include/glitch.h"

#include <hardware/paddr.h>
#include <hardware/xbar.h>

#include "include/clib.h"
#include "include/compat.h"
#include "include/crypto.h"
#include "include/debug.h"
#include "include/defs.h"
#include "include/ernie.h"
#include "include/ex.h"
#include "include/gpio.h"
#include "include/jig.h"
#include "include/maika.h"
#include "include/perv.h"
#include "include/rpc.h"
#include "include/spi.h"
#include "include/types.h"
#include "include/uart.h"
#include "include/utils.h"
#include "include/test.h"

__attribute__((noreturn)) void glitch_init(void) {
#ifndef NO_STATUS_LED
    gpio_set_port_mode(0, GPIO_PORT_GAMECARD_LED, GPIO_PORT_MODE_OUTPUT);
    gpio_port_set(0, GPIO_PORT_GAMECARD_LED);
    statusled(STATUS_GLINIT_GPIO);
    gpio_init(true);
#else
    gpio_init(false);
#endif

#ifndef SILENT
    statusled(STATUS_GLINIT_UART);
    uart_init(UART_BUS, UART_RATE);
    for (int i = 0; i < 0x100; i++)
        print("ping pong ding dong "); // spam uart for the glitcher watchdog
    printf("[BOB] glitch_init bob [%X], me @ %X\n", get_build_timestamp(), glitch_init);
#endif

    statusled(STATUS_GLINIT_ERNIE);
    printf("[BOB] ernie init\n");
    ernie_init(true, true);

    statusled(STATUS_GLINIT_JIG);
    printf("[BOB] jig init\n");
    uint32_t msg = 0xCAFEBABE;
    jig_update_shared_buffer((uint8_t*)&msg, 0, 0x10, true);

    // test test stuff
#ifndef GLITCH_SKIP_TEST
    statusled(STATUS_TEST_STARTING);
    printf("[BOB] test test test\n");
    glitch_test();
#endif

    vp 0xe3103040 = 0x10007;  // back up

    // start the rpc server
    statusled(STATUS_GLINIT_RPC);
    printf("[BOB] cleanup, move stack & exit to rpc\n");
    memset32((void*)0x5a000, 0x0, 0x2000);
    asm(
        "movu $1, 0x4fcb8\n"
        "mov $gp, $1\n"
        "movu $0, 0x49ff0\n"
        "mov $sp, $0\n"
        "bsr rpc_loop\n"
        "mov $0, $0\n"
        "jmp vectors_exceptions\n"
    );

    PANIC("GRET", 0);
}