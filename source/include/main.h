#ifndef __MAIN_H__
#define __MAIN_H__

#include "types.h"

typedef struct fm_nfo {
    uint16_t magic;
    volatile uint8_t exp_status;
    volatile uint8_t status;
    volatile uint32_t codepaddr;
    volatile uint32_t arg;
    uint32_t resp;
} fm_nfo;

typedef struct bob_config {
    fm_nfo* ce_framework_parms[2];
    uint32_t uart_params; // (bus << 0x18) | clk
    uint32_t run_tests; // 0: nothing, 1: test(), > 1: paddr to run
    int test_arg; // arg passed to test() or custom test
} bob_config;

// initialize bob, call that AFTER bob is copied to f00d mem
void init(bob_config* arg_config);

// code exec framework | [bg] if running from idle loop
int ce_framework(bool bg);

#endif