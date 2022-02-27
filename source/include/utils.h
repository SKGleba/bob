#ifndef __UTILS_H__
#define __UTILS_H__

#include "types.h"
#include <intrinsics.h>

// atrocious, but i love it
#define p *(uint32_t*)
#define vp *(volatile uint32_t*)

// some useful MEP instructions
#define _MEP_INTR_DISABLE_ mep_di();
#define _MEP_INTR_ENABLE_ mep_ei();
#define _MEP_SYNC_BUS_ mep_syncm();
#define _MEP_SYNC_COP_ mep_synccp();
#define _MEP_SLEEP_ mep_sleep();
#define _MEP_EXC_RETURN_ mep_reti();
#define _MEP_HALT_ mep_halt();
#define _MEP_BREAK_ mep_break();
#define _MEP_DEBUG_BREAK_ mep_dbreak();
#define _MEP_DEBUG_RETURN_ mep_dret();

// delay for ~n * 200 cycles
void delay(int n);

// read control bus
__attribute__((noinline, optimize("O0"))) int cbus_read(uint16_t cb_line);

// write control bus
__attribute__((noinline, optimize("O0"))) void cbus_write(uint16_t cb_line, uint32_t data);

// enter/exit f00d debug mode
__attribute__((noinline, optimize("O0"))) void set_dbg_mode(bool debug_mode);

// get compile timestamp
__attribute__((noinline)) uint32_t get_build_timestamp(void);

// enable/disable icache
__attribute__((noinline, optimize("O0"))) bool enable_icache(bool cache);

#endif