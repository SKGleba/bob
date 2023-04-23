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

#endif