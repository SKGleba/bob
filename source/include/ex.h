#ifndef __EX_H__
#define __EX_H__

#include "types.h"

__attribute__((optimize("O0"), noreturn)) void c_RESET(void);
__attribute__((optimize("O0"), noreturn)) void c_OTHER_EXC(void);
__attribute__((optimize("O0"), noreturn)) void c_OTHER_INT(void);
__attribute__((optimize("O0"))) void c_DBG(void);
__attribute__((optimize("O0"))) void c_SWI(int a0, int a1, int a2, int a3);
__attribute__((optimize("O0"))) void c_IRQ(void);
__attribute__((optimize("O0"))) void c_ARM_REQ(void);

__attribute__((optimize("O0"), noreturn)) void PANIC(const char* panic_string, uint32_t panic_value);

extern uint32_t vectors_exceptions[];
extern uint32_t ex_cxctable[];
void set_exception_table(bool glitch);

enum CXCTABLE_ETR {
    CXCTABLE_ETR_RESET = 0,
    CXCTABLE_ETR_SWI,
    CXCTABLE_ETR_DBG,
    CXCTABLE_ETR_GLITCH,
    CXCTABLE_ETR_OTHER
};

#endif