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

#include "include/main.h"

static bob_config options;

void test(void);

bool ce_framework(bool bg) {
    if (options.ce_framework_parms[bg]) {
        if ((options.ce_framework_parms[bg]->magic == 0x14FF) && (options.ce_framework_parms[bg]->status == 0x34)) {
            options.ce_framework_parms[bg]->status = 0x69;
            
            uint32_t(*ccode)(uint32_t arg, volatile uint8_t * status_addr) = (void*)(options.ce_framework_parms[bg]->codepaddr);

            statusled(STATUS_CEFW_OFF_ICACHE);
            bool icache_stat = enable_icache(false);

            statusled(STATUS_CEFW_CCODE);
            options.ce_framework_parms[bg]->resp = ccode(options.ce_framework_parms[bg]->arg, &options.ce_framework_parms[bg]->status);

            statusled(STATUS_CEFW_ON_ICACHE);
            enable_icache(icache_stat);

            options.ce_framework_parms[bg]->status = options.ce_framework_parms[bg]->exp_status;
            
            statusled(STATUS_CEFW_WAIT);
            return true;
        }
    } else if (bg)
        _MEP_SLEEP_

    return false;
}

void init(bob_config* arg_config) {

    _MEP_INTR_DISABLE_ // disable interrupts

    statusled(STATUS_INIT_CEFW);

    // foreground framework (only runs from arm request)
    options.ce_framework_parms[0] = arg_config->ce_framework_parms[0];
    if (options.ce_framework_parms[0]) {
        options.ce_framework_parms[0]->resp = 0;
        if (options.ce_framework_parms[0]->exp_status)
            options.ce_framework_parms[0]->status = options.ce_framework_parms[0]->exp_status;
        *(uint32_t*)0xE0000010 = 0xFFFFFFFF;
    }

    // background framework (runs when idle)
    options.ce_framework_parms[1] = arg_config->ce_framework_parms[1];
    if (options.ce_framework_parms[1]) {
        options.ce_framework_parms[1]->resp = 0;
        options.ce_framework_parms[1]->status = options.ce_framework_parms[1]->exp_status;
    }

#ifndef SILENT
    statusled(STATUS_INIT_UART);
    uart_init(UART_BUS, UART_RATE);
    printf("[BOB] init bob [%X], me @ %X\n", get_build_timestamp(), init);
#endif

    statusled(STATUS_INIT_TEST);

    // test test stuff
    test();

    statusled(STATUS_INIT_ICACHE);

    // enable and clean icache
    enable_icache(true);
    memset((void*)0x00300000, 0, 0x00010000);

    statusled(STATUS_INIT_RESET);

    // jump to reset (dynamic)
    asm("jmp vectors_exceptions\n");
}

void test(void) {
    printf("[BOB] test test test\n");

    set_dbg_mode(true);

    printf("[BOB] killing arm...\n");
    vp XBAR_CONFIG_REG(XBAR_MAIN_XBAR, XBAR_CFG_FAMILY_ACCESS_CONTROL, XBAR_TA_MXB_DEV_LPDDR0, XBAR_ACCESS_CONTROL_WHITELIST) = 0;
    vp XBAR_CONFIG_REG(XBAR_MAIN_XBAR, XBAR_CFG_FAMILY_ACCESS_CONTROL, XBAR_TA_MXB_DEV_SPAD32K, XBAR_ACCESS_CONTROL_WHITELIST) = 0;
    delay(10000);

    printf("[BOB] arm is dead, test gpios\n");
    statusled(0x31);
    hexdump(0x00040000, 0x80, true);
    statusled(0x32);
    regdump();
    statusled(0x69);
    for (uint32_t d_addr = 0x40000; d_addr < 0x40080; d_addr += 0x10)
        jig_update_shared_buffer(d_addr, 0, 0x10, true);
    statusled(0x48);

    printf("[BOB] all tests done\n");

    delay(20 * 1000 * 5);

    //while (1) {};
}