#ifndef __GLITCH_H__
#define __GLITCH_H__

#include "types.h"

// initialize bob from glitch
__attribute__((noreturn, section(".text.exs"))) void glitch_init(void);

#endif