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
} bob_config;

// initialize bob, call that AFTER bob is copied to f00d mem
void init(bob_config* arg_config);

// code exec framework | [bg] if running from idle loop
int ce_framework(bool bg);

#endif