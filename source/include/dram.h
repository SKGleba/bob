#ifndef __DRAM_H__
#define __DRAM_H__

#include "types.h"
#include "defs.h"
#include "utils.h"

#ifdef DRAM_UNUSE
#define dram_init(a,b) stub()
#else
int dram_init(int clock, bool is_resume);
#endif

#endif