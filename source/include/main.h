#ifndef __MAIN_H__
#define __MAIN_H__

#include "types.h"
#include "config.h"
#include "defs.h"

// initialize bob, call that AFTER bob is copied to f00d mem
void init(bob_config_s* arg_config);

// code exec framework | [bg] if running from idle loop
bool ce_framework(bool bg, bob_fm_nfo_s* params);

#endif