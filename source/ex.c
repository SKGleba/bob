#include "include/ex.h"

#include <hardware/paddr.h>

#include "include/clib.h"
#include "include/compat.h"
#include "include/debug.h"
#include "include/glitch.h"
#include "include/maika.h"
#include "include/main.h"
#include "include/types.h"
#include "include/utils.h"
#include "include/config.h"
#include "include/tfsm.h"

__attribute__((optimize("O0"), noreturn))
void c_RESET(void) {
#ifdef DEBUG_REGDUMP_EXC
    regdump();
#endif
    
    statusled(STATUS_RESET_HIT);

#ifndef BOBT_FSM
    __attribute__((unused)) register volatile uint32_t exc asm("exc") = 0;
    __attribute__((unused)) register volatile uint32_t tmp asm("tmp") = 0;
    WARN("[BOB] warning: did reset\n");
#else
    tfsm_init();
#endif

    if (CONFIG_GFLAGK(_TEST_ONRESET)) {
        statusled(STATUS_TEST_STARTING);
        ce_framework(false, g_config.test_params, false);
    }

    statusled(STATUS_CEFW_DONE_WAIT);

#ifndef BOBT_FSM
    _MEP_INTR_ENABLE_
#endif

    while (1) {
        ce_framework(true, NULL, false);
    };
}

void c_SWI(int a0, int a1, int a2, int a3) {
    statusled(STATUS_SWI_HIT);
    INFOF("[BOB] entering SWI 0x%X 0x%X 0x%X 0x%X\n", a0, a1, a2, a3);

    //TODO

    delay_nx(0x6000, 200);

    INFO("[BOB] exiting SWI\n");
    statusled(STATUS_SWI_QUIT);
}

void c_IRQ(void) {
    statusled(STATUS_IRQ_HIT);
    int irqn = (cbus_read(0) & 0xf8) >> 3;
    switch (irqn) {
        case IRQN_ARM2CRY0:
        case IRQN_ARM2CRY1:
        case IRQN_ARM2CRY2:
        case IRQN_ARM2CRY3:
            compat_Arm2Cry0123(irqn - IRQN_ARM2CRY0);
            break;
        default:
            WARNF("[BOB] UNHANDLED IRQ: %d\n", irqn);
            break;
    }
    statusled(STATUS_IRQ_QUIT);
}

__attribute__((optimize("O0"), noreturn))
void c_OTHER_INT(void) {
    _MEP_INTR_DISABLE_
#ifdef DEBUG_REGDUMP_EXC
    regdump();
#endif
    
    statusled(STATUS_OTHER_INT_HIT);

#if !defined(SILENT) && !defined(DEBUG_ONLYERR)
    register volatile uint32_t exc asm("exc");
    register volatile uint32_t epc asm("epc");
    WARNF("[BOB] UNK INTERRUPT: 0x%X @ 0x%X\n", exc, epc);
#endif

    _MEP_HALT_

    while (1) {};
}

__attribute__((optimize("O0"), noreturn))
void c_OTHER_EXC(void) {
    _MEP_INTR_DISABLE_
#ifdef DEBUG_REGDUMP_EXC
    regdump();
#endif
    
    statusled(STATUS_OTHER_EXC_HIT);

#if !defined(SILENT) && !defined(DEBUG_ONLYERR)
    register volatile uint32_t exc asm("exc");
    register volatile uint32_t epc asm("epc");
    WARNF("[BOB] UNK EXCEPTION: 0x%X @ 0x%X\n", exc, epc);
#endif

    _MEP_HALT_

    while (1) {};
}

__attribute__((optimize("O0"), noreturn))
void PANIC(const char* panic_string, uint32_t panic_value) {
    _MEP_INTR_DISABLE_
#ifdef DEBUG_REGDUMP_EXC
    regdump();
#endif
    
    statusled(STATUS_PANIC_HIT);

    ERRORF("[BOB] PANIC: %s | 0x%X\n", panic_string, panic_value);

    _MEP_HALT_

    while (1) {};
}

__attribute__((optimize("O0")))
void c_DBG(void) {
    statusled(STATUS_DBG_HIT);
    INFO("[BOB] GOT DBG INTERRUPT\n");
    statusled(STATUS_DBG_QUIT);
}

void set_exception_table(bool glitch) {
#ifdef BOBT_FSM
    INFO("[BOB] set_exception_table called in FSM mode\n");
#else
    if (glitch) {
        memset32(&vectors_exceptions[0], ex_cxctable[CXCTABLE_ETR_GLITCH], 0x34);
        return;
    } else
        memset32(&vectors_exceptions[0], ex_cxctable[CXCTABLE_ETR_OTHER], 0x34);
    vectors_exceptions[0] = ex_cxctable[CXCTABLE_ETR_RESET];
    vectors_exceptions[5] = ex_cxctable[CXCTABLE_ETR_SWI];
    vectors_exceptions[6] = ex_cxctable[CXCTABLE_ETR_DBG];
#endif
}