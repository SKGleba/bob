#ifndef __UTILS_H__
#define __UTILS_H__

#include "types.h"
#include <intrinsics.h>

// atrocious, but i love it
#define p *(uint32_t*)
#define vp *(volatile uint32_t*)
#define v8p *(volatile uint8_t*)
#define v16p *(volatile uint16_t*)
#define v32p *(volatile uint32_t*)
#define v64p *(volatile uint64_t*)

#define BITF(n) (~(-1 << (n)))
#define BITFL(n) (BITF((n) + 1))
#define BITN(n) (1 << (n))
#define BITNVAL(n, val) ((val) << (n))
#define BITNVALM(n, val, mask) (((val) & (mask)) << (n))
#define XBITN(v, n) (((v) >> (n)) & 1)
#define XBITNVALM(v, n, mask) (((v) >> (n)) & (mask))

// function selector based on argc
#define FUN_VAR4(_1, _2, _3, _4, _fun, ...) _fun

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

// delay funcs
#define UTILS_RTZ_DFL_REG "$12" // default register for delay_rtz
#define delay_rtz(reg) __asm__ __volatile__("1: add3 %0, %0, -1; bnez %0, 1b" : "+r"(reg))
#define delay_rtz_scr(n, regn) register int delay_rtz_reg asm(regn) = n
#define delay_rtz_set(n) delay_rtz_scr(n, UTILS_RTZ_DFL_REG)
#define delay_rtz_go() delay_rtz(delay_rtz_reg)
void delay_nx(int n, int x);

extern void delay(int n);
extern int cbus_read(uint16_t cb_line);
extern void cbus_write(uint16_t cb_line, uint32_t data);
extern void set_dbg_mode(bool debug_mode);
extern bool enable_icache(bool cache);

extern volatile uint32_t g_state;

// get compile timestamp
__attribute__((noinline)) uint32_t get_build_timestamp(void);

// enable default interrupts
void setup_ints(void);

// stub func for disabled features
int stub();

#endif