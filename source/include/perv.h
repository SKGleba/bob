#ifndef __PERV_H__
#define __PERV_H__

#include <hardware/perv.h>

#include "types.h"

uint32_t pervasive_control_reset(int device, unsigned int mask, bool reset, bool wait);
uint32_t pervasive_control_gate(int device, unsigned int mask, bool open, bool wait);
uint32_t pervasive_control_clock(int device, unsigned int clock, bool wait);
uint32_t pervasive_control_misc(int reg_id, unsigned int value, bool wait);

#endif