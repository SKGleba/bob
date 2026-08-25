#ifndef __TFSM_H__
#define __TFSM_H__

#include "types.h"
#include "defs.h"
#include "utils.h"

#ifdef BOBT_FSM
void tfsm_init(void);
#else
#define tfsm_init() stub()
#endif

#endif