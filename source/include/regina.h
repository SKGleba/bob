#ifndef __REGINA_H__
#define __REGINA_H__

#include "types.h"
#include "defs.h"
#include "utils.h"

#define RGN_RPC_COMBUF_OFFSET ((void *)(COMPAT_SRAM_OFFSET + RGN_RPC_SRAM_COMBUF_OFFSET))
#include "regina_rpc.h"

#define REGINA_RPC_ANSWER_TIMEOUT_STEP 0x1000
#define REGINA_RPC_ANSWER_TIMEOUT_COUNT 0x10

#ifndef REGINA_UNUSE
    int regina_loadRegina(void *src, bool blockFudAccess, bool allowArmAccess);
    int regina_sendCmd(int cmd, uint32_t *args, uint32_t *extra, int timeout_step, int timeout_count);
#else
    #define regina_loadRegina(a, b, c) stub()
    #define regina_sendCmd(a, b, c, d, e) stub()
#endif

#endif