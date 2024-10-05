#include "include/regina.h"

#include <hardware/paddr.h>
#include <hardware/regbus.h>

#include "include/clib.h"
#include "include/compat.h"
#include "include/debug.h"
#include "include/types.h"
#include "include/utils.h"

// TODO: support coldboot
int regina_loadRegina(void *src, bool blockFudAccess, bool allowArmAccess) {
    printf("[BOB] put AGX into reset\n");
    compat_handleAllegrex(AGX_CMD_RESET, true, 3);

    printf("[BOB] spin up AGX clocks\n");
    compat_handleAllegrex(AGX_CMD_GATE, 0x1, 0x3);
    compat_handleAllegrex(AGX_CMD_CLOCK, 0x1, 0);

    void *dst = (void *)COMPAT_SRAM_OFFSET;
    uint32_t sz = COMPAT_SRAM_SIZE;
    if (src != dst) {
        printf("[BOB] copy regina to %X[%X]\n", (uint32_t)dst, sz);
        compat_handleAllegrex(AGX_CMD_ACL, REGBUS_AGX_SRAM_ACL_DEV_F00D, 0);
        memset32(dst, 0, sz);
        if (vp(dst)) {
            printf("[BOB] failed to clear dst area\n");
            return -1;
        }
        memcpy(dst, src, sz);
    }

    printf("[BOB] set ACL\n");
    compat_handleAllegrex(AGX_CMD_ACL, ((allowArmAccess << 3) | (!blockFudAccess << 2)), 0);

    printf("[BOB] put AGX out of reset\n");
    compat_handleAllegrex(AGX_CMD_RESET, false, 1);

    return 0;
}

int regina_sendCmd(int cmd, uint32_t *args, uint32_t *extra) {
    rgn_rpc_combuf_s *combuf = (rgn_rpc_combuf_s *)RGN_RPC_COMBUF_OFFSET;
    if (combuf->rpc_status != RGN_RPC_STATUS_READY) {
        printf("[BOB] regina_sendCmd: rpc_status != READY, wait\n");
        for (int i = 0; i < REGINA_RPC_ANSWER_TIMEOUT_COUNT; i++) {
            if (combuf->rpc_status == RGN_RPC_STATUS_READY)
                break;
            delay(REGINA_RPC_ANSWER_TIMEOUT_STEP);
        }
        if (combuf->rpc_status != RGN_RPC_STATUS_READY) {
            printf("[BOB] regina_sendCmd: rpc_status != READY, timed out\n");
            return -1;
        }
    }

    combuf->cmd_packed = 0;
    if (args)
        memcpy(combuf->args, args, sizeof(combuf->args));
    if (extra)
        memcpy(combuf->extra_data, extra, sizeof(combuf->extra_data));

    combuf->cmd.id = cmd;
    uint8_t chash = 0;
    for (int i = 0; i < 0x11; i++)
        chash += ((uint8_t *)&combuf->cmd.id)[i];
    combuf->cmd.hash = chash;
    combuf->cmd.magic = RGN_RPC_CMD_MAGIC;

    for (int i = 0; i < REGINA_RPC_ANSWER_TIMEOUT_COUNT; i++) {
        if (combuf->rpc_status == RGN_RPC_STATUS_REPLY)
            break;
        delay(REGINA_RPC_ANSWER_TIMEOUT_STEP);
    }
    if (combuf->rpc_status != RGN_RPC_STATUS_REPLY) {
        printf("[BOB] regina_sendCmd: rpc_status != REPLY, timed out\n");
        return -1;
    }

    combuf->cmd_packed = 0;
    return combuf->ret;
}