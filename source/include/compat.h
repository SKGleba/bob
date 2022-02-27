#ifndef __COMPAT_H__
#define __COMPAT_H__

#include "types.h"

void compat_IRQ7_handleCmd(void);
int compat_f00dState(uint32_t state, bool set);
uint32_t compat_Cry2Arm0(uint32_t msg);

#endif