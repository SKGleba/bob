#include "include/types.h"
#include "include/debug.h"
#include "include/compat.h"
#include "include/utils.h"
#include "include/main.h"
#include "include/ex.h"

__attribute__((optimize("O0"), noreturn))
void c_RESET(void) {
    _MEP_INTR_DISABLE_

#ifdef ENABLE_REGDUMP
    debug_regdump();
#endif

    register uint32_t exc asm("exc") = 0;
    register uint32_t tmp asm("tmp") = 0;

    register uint32_t sp asm("sp") = 0x49000;
    register uint32_t gp asm("gp") = 0x4fc00;

    if ((uint32_t)c_RESET > sp) {
        sp = 0x809000;
        gp = 0x80fc00;
    }

    print("[BOB] warning: did reset\n");

    _MEP_INTR_ENABLE_

    while (1) {
        ce_framework(true);
    };
}

__attribute__((optimize("O0")))
void c_SWI(void) {
    print("[BOB] entering SWI\n");

    // TODO

    print("[BOB] exiting SWI\n");
}

__attribute__((optimize("O0")))
void c_IRQ(void) {
    print("[BOB] entering IRQ\n");

    // TODO

    print("[BOB] exiting IRQ\n");
}

__attribute__((optimize("O0")))
void c_ARM_REQ(void) {
    print("[BOB] entering ARM req\n");
    
    if (ce_framework(false))
        p 0xE0000010 = 0xFFFFFFFF;
    else
        compat_IRQ7_handleCmd();

    print("[BOB] exiting ARM req\n");
}

__attribute__((optimize("O0"), noreturn))
void c_OTHER_INT(void) {
    _MEP_INTR_DISABLE_

#ifdef ENABLE_REGDUMP
    debug_regdump();
#endif

    register uint32_t exc asm("exc");
    register uint32_t epc asm("epc");
    
    printf("[BOB] UNK INTERRUPT: %X @ %X\n", exc, epc);

    _MEP_HALT_

    while (1) {};
}

__attribute__((optimize("O0"), noreturn))
void c_OTHER_EXC(void) {
    _MEP_INTR_DISABLE_

#ifdef ENABLE_REGDUMP
        debug_regdump();
#endif

    register uint32_t exc asm("exc");
    register uint32_t epc asm("epc");

    printf("[BOB] UNK EXCEPTION: %X @ %X\n", exc, epc);

    _MEP_HALT_

    while (1) {};
}

__attribute__((optimize("O0"), noreturn))
void PANIC(const char *panic_string, uint32_t panic_value) {
    _MEP_INTR_DISABLE_

#ifdef ENABLE_REGDUMP
        debug_regdump();
#endif

    printf("[BOB] PANIC: %s | %X\n", panic_string, panic_value);

    _MEP_HALT_

    while (1) {};
}

__attribute__((optimize("O0")))
void c_DBG(void) {
    print("[BOB] GOT DBG INTERRUPT\n");
}