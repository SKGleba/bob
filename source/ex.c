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

__attribute__((optimize("O0"), noreturn))
void c_RESET(void) {
#ifdef ENABLE_REGDUMP
    regdump();
#endif
    
    statusled(STATUS_RESET_HIT);

    __attribute__((unused)) register volatile uint32_t exc asm("exc") = 0;
    __attribute__((unused)) register volatile uint32_t tmp asm("tmp") = 0;

    print("[BOB] warning: did reset\n");

    if (CONFIG_GFLAGK(_TEST_ONRESET)) {
        statusled(STATUS_TEST_STARTING);
        ce_framework(false, g_config.test_params);
    }

    statusled(STATUS_CEFW_DONE_WAIT);

    _MEP_INTR_ENABLE_

    while (1) {
        ce_framework(true, NULL);
    };
}

void c_SWI(int a0, int a1, int a2, int a3) {
    statusled(STATUS_SWI_HIT);
    printf("[BOB] entering SWI %X %X %X %X\n", a0, a1, a2, a3);

    //TODO

    delay_nx(0x6000, 200);

    print("[BOB] exiting SWI\n");
    statusled(STATUS_SWI_QUIT);
}

void c_IRQ(void) {
    statusled(STATUS_IRQ_HIT);
    print("[BOB] entering IRQ\n");

    // TODO

    delay_nx(0x6000, 200);

    print("[BOB] exiting IRQ\n");
    statusled(STATUS_IRQ_QUIT);
}

void c_ARM_REQ(void) {
    statusled(STATUS_ARM_HIT);
    maika_s* maika = (maika_s*)MAIKA_OFFSET;
    uint32_t arm_req = maika->mailbox.arm2cry[0];
    printf("[BOB] entering ARM req %X\n", arm_req);

    if (ce_framework(false, NULL) != true)
        compat_IRQ7_handleCmd(arm_req, maika->mailbox.arm2cry[1], maika->mailbox.arm2cry[2], maika->mailbox.arm2cry[3]);

    printf("[BOB] exiting ARM req %X\n", arm_req);

    ((maika_s*)(MAIKA_OFFSET))->mailbox.arm2cry[0] = -1; // full clear

    statusled(STATUS_ARM_QUIT);
}

__attribute__((optimize("O0"), noreturn))
void c_OTHER_INT(void) {
#ifdef ENABLE_REGDUMP
    regdump();
#endif
    
    statusled(STATUS_OTHER_INT_HIT);
    
    _MEP_INTR_DISABLE_

    register volatile uint32_t exc asm("exc");
    register volatile uint32_t epc asm("epc");
    
    printf("[BOB] UNK INTERRUPT: %X @ %X\n", exc, epc);

    _MEP_HALT_

    while (1) {};
}

__attribute__((optimize("O0"), noreturn))
void c_OTHER_EXC(void) {
#ifdef ENABLE_REGDUMP
    regdump();
#endif
    
    statusled(STATUS_OTHER_EXC_HIT);
    
    _MEP_INTR_DISABLE_

    register volatile uint32_t exc asm("exc");
    register volatile uint32_t epc asm("epc");

    printf("[BOB] UNK EXCEPTION: %X @ %X\n", exc, epc);

    _MEP_HALT_

    while (1) {};
}

__attribute__((optimize("O0"), noreturn))
void PANIC(const char* panic_string, uint32_t panic_value) {
#ifdef ENABLE_REGDUMP
    regdump();
#endif
    
    statusled(STATUS_PANIC_HIT);
    
    _MEP_INTR_DISABLE_

    printf("[BOB] PANIC: %s | %X\n", panic_string, panic_value);

    _MEP_HALT_

    while (1) {};
}

__attribute__((optimize("O0")))
void c_DBG(void) {
    statusled(STATUS_DBG_HIT);
    print("[BOB] GOT DBG INTERRUPT\n");
    statusled(STATUS_DBG_QUIT);
}

void set_exception_table(bool glitch) {
    if (glitch) {
        memset32(&vectors_exceptions[0], ex_cxctable[CXCTABLE_ETR_GLITCH], 0x34);
        return;
    } else
        memset32(&vectors_exceptions[0], ex_cxctable[CXCTABLE_ETR_OTHER], 0x34);
    vectors_exceptions[0] = ex_cxctable[CXCTABLE_ETR_RESET];
    vectors_exceptions[5] = ex_cxctable[CXCTABLE_ETR_SWI];
    vectors_exceptions[6] = ex_cxctable[CXCTABLE_ETR_DBG];
}