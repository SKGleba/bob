#ifndef __MAIN_H__
#define __MAIN_H__

#include "types.h"
#include "config.h"
#include "defs.h"

enum CEFW_PROGRESS {
    CEFW_PROGRESS_IDLE = 0,
    CEFW_PROGRESS_STARTING,
    CEFW_PROGRESS_OFF_ICACHE,
    CEFW_PROGRESS_CCODE,
    CEFW_PROGRESS_ON_ICACHE,
    CEFW_PROGRESS_NEXT,
    CEFW_PROGRESS_DONE_WAIT
};
extern enum CEFW_PROGRESS g_cefw_progress[2];

// initialize bob, call that AFTER bob is copied to f00d mem
void init(bob_config_s* arg_config);

// code exec framework | [bg] if running from idle loop
bool ce_framework(bool bg, bob_fm_nfo_s* params, bool nested);

#endif