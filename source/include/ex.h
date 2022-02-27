#ifndef __EX_H__
#define __EX_H__

#include "types.h"

__attribute__((optimize("O0"), noreturn)) void volatile c_RESET(void);
__attribute__((optimize("O0"), noreturn)) void volatile c_OTHER_EXC(void);
__attribute__((optimize("O0"), noreturn)) void volatile c_OTHER_INT(void);
__attribute__((optimize("O0"))) void volatile c_DBG(void);
__attribute__((optimize("O0"))) void volatile c_SWI(void);
__attribute__((optimize("O0"))) void volatile c_IRQ(void);
__attribute__((optimize("O0"))) void volatile c_ARM_REQ(void);

__attribute__((optimize("O0"), noreturn)) void volatile PANIC(const char* panic_string, uint32_t panic_value);

#endif