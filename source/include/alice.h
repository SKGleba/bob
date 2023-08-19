#ifndef __ALICE_H__
#define __ALICE_H__

#include "types.h"

enum ALICE2BOB_COMMANDS {
    ALICE_A2B_GET_RPC_STATUS = 0xA20,
    ALICE_A2B_SET_RPC_STATUS,
    ALICE_A2B_MASK_RPC_STATUS,
    ALICE_A2B_REBOOT,
    ALICE_A2B_MEMCPY,
    ALICE_A2B_MEMSET,
    ALICE_A2B_MEMSET32,
    ALICE_A2B_READ32,
    ALICE_A2B_WRITE32,
    ALICE_A2B_EXEC = 0x80000000 // OR it with paddr for bob to exec
};

#define ALICE_ACQUIRE_CMD 0x5E7A21CE
#define ALICE_RELINQUISH_CMD 0xA21CEDED

void alice_armReBoot(int armClk, bool hasCS, bool hasUnk);
int alice_handleCmd(uint32_t cmd, uint32_t arg1, uint32_t arg2, uint32_t arg3);
void alice_setupInts(void);

#endif