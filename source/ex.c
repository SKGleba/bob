#include "include/types.h"
#include "include/debug.h"
#include "include/compat.h"
#include "include/utils.h"
#include "include/main.h"
#include "include/glitch.h"
#include "include/ex.h"

__attribute__((optimize("O0"), noreturn))
void c_RESET(void) {
#ifdef ENABLE_REGDUMP
    regdump();
#endif
    
    statusled(STATUS_RESET_HIT);

    register uint32_t exc asm("exc") = 0;
    register uint32_t tmp asm("tmp") = 0;

    print("[BOB] warning: did reset\n");

    statusled(STATUS_CEFW_WAIT);

    _MEP_INTR_ENABLE_

    while (1) {
        ce_framework(true);
    };
}

__attribute__((optimize("O0")))
void c_SWI(void) {
    statusled(STATUS_SWI_HIT);
    print("[BOB] entering SWI\n");

    // TODO

    print("[BOB] exiting SWI\n");
    statusled(STATUS_SWI_QUIT);
}

__attribute__((optimize("O0")))
void c_IRQ(void) {
    statusled(STATUS_IRQ_HIT);
    print("[BOB] entering IRQ\n");

    // TODO

    print("[BOB] exiting IRQ\n");
    statusled(STATUS_IRQ_QUIT);
}

__attribute__((optimize("O0")))
void c_ARM_REQ(void) {
    statusled(STATUS_ARM_HIT);
    print("[BOB] entering ARM req\n");

    if (ce_framework(false))
        p 0xE0000010 = 0xFFFFFFFF;
    else
        compat_IRQ7_handleCmd();

    print("[BOB] exiting ARM req\n");
    statusled(STATUS_ARM_QUIT);
}

__attribute__((optimize("O0"), noreturn))
void c_OTHER_INT(void) {
#ifdef ENABLE_REGDUMP
    regdump();
#endif
    
    statusled(STATUS_OTHER_INT_HIT);
    
    _MEP_INTR_DISABLE_

    register uint32_t exc asm("exc");
    register uint32_t epc asm("epc");
    
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

    register uint32_t exc asm("exc");
    register uint32_t epc asm("epc");

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