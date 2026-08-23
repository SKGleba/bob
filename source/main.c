#include "include/main.h"

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
#include "include/types.h"
#include "include/uart.h"
#include "include/utils.h"
#include "include/test.h"
#include "include/config.h"
#include "include/heap.h"

#ifndef CCX_UNUSE
enum CEFW_PROGRESS g_cefw_progress[2] = { CEFW_PROGRESS_IDLE, CEFW_PROGRESS_IDLE };
bool ce_framework(bool bg, bob_fm_nfo_s* params, bool nested) {
    if (!params)
        params = g_config.ce_framework_parms[bg];

    if (params) {
        if (CEFW_ISMAGIC(params->magic) && (params->status == CE_FRAMEWORK_STATUS_TORUN)) {
            if (!nested)
                g_cefw_progress[bg] = CEFW_PROGRESS_STARTING;
            params->status = CE_FRAMEWORK_STATUS_RUNNING;

            bool icache_stat = false;
            if (CEFW_FLAG(params->magic, _ICACHEOFF)) {
                if (!nested)
                    g_cefw_progress[bg] = CEFW_PROGRESS_OFF_ICACHE;
                statusled(STATUS_CEFW_OFF_ICACHE);
                icache_stat = enable_icache(false);
            }

            if (!nested)
                g_cefw_progress[bg] = CEFW_PROGRESS_CCODE;
            statusled(STATUS_CEFW_CCODE);
            params->resp = params->codepaddr(params->arg, &params->status);

            if (CEFW_FLAG(params->magic, _ICACHEOFF) && icache_stat) {
                statusled(STATUS_CEFW_ON_ICACHE);
                enable_icache(icache_stat);
            }

            if (CEFW_FLAG(params->magic, _EXTENDED) && params->next) { // watch the stack
                if (!nested)
                    g_cefw_progress[bg] = CEFW_PROGRESS_NEXT;
                statusled(STATUS_CEFW_NEXT);
                if ((uint32_t)params->next & 0b1)
                    ce_framework(bg, &params[1], true);
                else
                    ce_framework(bg, params->next, true);
            }

            params->status = params->exp_status;

            if (!nested)
                g_cefw_progress[bg] = CEFW_PROGRESS_DONE_WAIT;
            statusled(STATUS_CEFW_DONE_WAIT);
            return true;
        }
        if (g_cefw_progress[bg] && !nested) // clean only on next it
            g_cefw_progress[bg] = CEFW_PROGRESS_IDLE;
    } else if (bg)
        _MEP_SLEEP_

    return false;
}
#else
bool ce_framework(bool bg, bob_fm_nfo_s* params, bool nested) {
    return false;
}
#endif

void init(bob_config_s* arg_config) {
    _MEP_INTR_DISABLE_  // disable interrupts

    asm(
        "movh $gp, %hi(cfg_gp_addr)\n"
        "add3  $gp, $gp, %lo(cfg_gp_addr)\n"
    );

    int ret = 0;

    // init config
    if (!CONFIG_GFLAGK(_CFG_USEINT)) {
        statusled(STATUS_INIT_CFG);
        ret = config_parse(arg_config);
        if (ret)
            PANIC("CFGP", ret);
    }

    // init uart
#ifndef SILENT
    if (CONFIG_GFLAGK(_SET_UART)) {
        statusled(STATUS_INIT_UART);
        g_uart_bus = CONFIG_GVAL(_UART_BUS);
        uart_init(g_uart_bus, 0x10000 | CONFIG_GVAL(_UART_CLK));
    }
    ERRORF("[BOB] init bob [%X], me @ 0x%X\n", get_build_timestamp(), init);
#endif

#ifdef HEAP_ONINIT
    statusled(STATUS_INIT_HEAP);
    ret = heap_start(NULL, 0, HEAP_ONINIT);
    INFOF("[BOB] init heap 0x%X\n", ret);
    if (ret < 0)
        PANIC("HEAP", ret);
#endif

    // test test stuff
    if (CONFIG_GFLAGK(_TEST_ONINIT)) {
        statusled(STATUS_TEST_STARTING);
        ce_framework(false, g_config.test_params, false);
    }

    // enable and clean icache
    statusled(STATUS_INIT_ICACHE);
    enable_icache(true);
    memset((void*)F00D_ICACHE_OFFSET, 0, F00D_ICACHE_SIZE);

    // jump to reset
    statusled(STATUS_INIT_RESET);
    asm("jmp vectors_exceptions\n");
}