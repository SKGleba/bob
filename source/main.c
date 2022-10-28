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

#include "include/main.h"

static bob_config options;

void test(void);

bool ce_framework(bool bg) {
    if (options.ce_framework_parms[bg]) {
        if ((options.ce_framework_parms[bg]->magic == 0x14FF) && (options.ce_framework_parms[bg]->status == 0x34)) {
            options.ce_framework_parms[bg]->status = 0x69;
            
            uint32_t(*ccode)(uint32_t arg, volatile uint8_t * status_addr) = (void*)(options.ce_framework_parms[bg]->codepaddr);
            
            bool icache_stat = enable_icache(false);
            options.ce_framework_parms[bg]->resp = ccode(options.ce_framework_parms[bg]->arg, &options.ce_framework_parms[bg]->status);
            enable_icache(icache_stat);
            
            options.ce_framework_parms[bg]->status = options.ce_framework_parms[bg]->exp_status;
            return true;
        }
    } else if (bg)
        _MEP_SLEEP_

    return false;
}

void init(bob_config* arg_config) {

    _MEP_INTR_DISABLE_ // disable interrupts

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
    uart_init(UART_BUS, UART_RATE);
    #endif

    printf("[BOB] init bob [%X], me @ %X\n", get_build_timestamp(), init);

    // test test stuff
    test();

    // enable and clean icache
    enable_icache(true);
    memset((void*)0x00300000, 0, 0x00010000);

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
    uint32_t msg = 0x11111111;
    jig_update_shared_buffer(&msg, 0, 4, true);

    delay(10000);

    msg = 0x22222222;
    jig_update_shared_buffer(&msg, 0, 4, true);
    delay(200);
    //--

    delay(20000);

    printf("[BOB] infinilooping, but you dont see this\n");
    while(1){
        ernie_exec_cmd_short(ERNIE_CMD_GET_KERMITJIG_SHBUF, 0x0800, 2);
        delay(20000);
    };
}