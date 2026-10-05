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

            if ((params->codepaddr < F00D_SRAM_OFFSET) && params->codepaddr) {
                if (params->codepaddr <= (g_exparam & 0xFFFF))
                    params->codepaddr = ((uint32_t)&PROG_exports_start + (params->codepaddr * 4));
                else
                    params->codepaddr = 0;
            }

            if (params->codepaddr) {
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
                //INFOF("CEFWX: 0x%08X(0x%08X, 0x%08X, 0x%08X, 0x%08X..)\n", params->codepaddr, params->arg0, params->argx[0], params->argx[1], params->argx[2]);
                if (CEFW_FLAG(params->magic, _EXTRARG))
                    params->resp = params->c_ext(params->arg0, params->argx[0], params->argx[1], params->argx[2], params->argx[3], params->argx[4], params->argx[5], params->argx[6]);
                else
                    params->resp = params->c_n(params->arg0, &params->status);

                if (CEFW_FLAG(params->magic, _ICACHEOFF) && icache_stat) {
                    statusled(STATUS_CEFW_ON_ICACHE);
                    enable_icache(icache_stat);
                }
            } else
                params->resp = -1;

            if (CEFW_FLAG(params->magic, _EXTENDED)) { // watch the stack
                if (!(params->unext & -2))
                    params->unext = (uint32_t)&params->snext_start + (!(params->unext & 1) * (7 * sizeof(uint32_t)));
                if (!nested)
                    g_cefw_progress[bg] = CEFW_PROGRESS_NEXT;
                statusled(STATUS_CEFW_NEXT);
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
enum CEFW_PROGRESS g_cefw_progress[2] = { CEFW_PROGRESS_DISABLED, CEFW_PROGRESS_DISABLED };
bool ce_framework(bool bg, bob_fm_nfo_s* params, bool nested) {
    return false;
}
#endif

void init(bob_config_s* arg_config, void *tf, int ta0, int ta1) {
#ifndef BOBT_FSM
    asm(
        "di\n"
        "movh $gp, %hi(cfg_gp_addr)\n"
        "add3  $gp, $gp, %lo(cfg_gp_addr)\n"
    );
#endif

    int ret = 0;

    // init config
    if (!CONFIG_GFLAGK(_CFG_USEINT)) {
        statusled(STATUS_INIT_CFG);
        if (ICONFIG_IS(arg_config))
            ret = config_iparse((uint32_t)arg_config, tf, ta0, ta1);
        else
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
    printf("[BOB] init bob [%X], me @ 0x%X\n", get_build_timestamp(), init);
    printf("config at 0x%X\n", (uint32_t)&g_config);
    hexdump((uint32_t)&g_config, sizeof(g_config));
#endif

#ifdef HEAP_ONINIT
    statusled(STATUS_INIT_HEAP);
    ret = heap_start(NULL, 0, HEAP_ONINIT);
    INFOF("init heap 0x%X\n", ret);
    if (ret < 0)
        PANIC("HEAP", ret);
#endif

    // test test stuff
    if (CONFIG_GFLAGK(_TEST_ONINIT)) {
        statusled(STATUS_TEST_STARTING);
        ce_framework(false, g_config.test_params, false);
    }

#ifdef BOBT_FSM
    return;
#endif

    // enable and clean icache
    statusled(STATUS_INIT_ICACHE);
    enable_icache(true);
    memset((void*)F00D_ICACHE_OFFSET, 0, F00D_ICACHE_SIZE);

    // jump to reset
    statusled(STATUS_INIT_RESET);
    asm("jmp vectors_exceptions\n");
}