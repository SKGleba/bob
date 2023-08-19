#include "include/types.h"
#include "include/defs.h"
#include "include/utils.h"
#include "include/debug.h"
#include "include/paddr.h"
#include "include/maika.h"
#include "include/perv.h"
#include "include/rpc.h"
#include "include/clib.h"
#include "include/compat.h"

#include "include/alice.h"

int alice_handleCmd(uint32_t cmd, uint32_t arg1, uint32_t arg2, uint32_t arg3) {
    void* exec_paddr = 0;
    maika_s* maika = (maika_s*)MAIKA_OFFSET;

    printf("[BOB] got alice cmd %X (%X, %X, %X)\n", cmd, arg1, arg2, arg3);

    if (cmd & 0x80000000 && cmd != ALICE_RELINQUISH_CMD) {
        if (cmd & 1)
            exec_paddr = (void*)(cmd & 0xFFFFFFFE);
        else
            exec_paddr = (void*)(cmd & 0x7FFFFFFE);
        uint32_t (*exec_func)(uint32_t a, uint32_t b, uint32_t c) = (void*)exec_paddr;
        maika->mailbox.cry2arm[1] = exec_func(arg1, arg2, arg3);
        maika->mailbox.arm2cry[0] = -1;
        return -1;
    }

    switch (cmd) {
    case ALICE_RELINQUISH_CMD:
        if (arg3 == cmd) {
            printf("[BOB] alice service terminated\n");
            maika->mailbox.arm2cry[3] = -1;
            maika->mailbox.arm2cry[2] = -1;
            maika->mailbox.arm2cry[1] = -1;
            return 0;
        } else
            printf("[BOB] invalid arg for compat acquire\n");
        break;
    case ALICE_A2B_GET_RPC_STATUS:
        maika->mailbox.cry2arm[1] = g_rpc_status;
        break;
    case ALICE_A2B_SET_RPC_STATUS:
        g_rpc_status = arg1;
        break;
    case ALICE_A2B_MASK_RPC_STATUS:
        if (maika->mailbox.arm2cry[2])
            g_rpc_status |= (arg1);
        else
            g_rpc_status &= ~(arg1);
        maika->mailbox.cry2arm[1] = g_rpc_status;
        break;
    case ALICE_A2B_REBOOT:
        compat_armReBoot(arg1, arg2, arg3);
        break;
    case ALICE_A2B_MEMCPY:
        memcpy((void*)arg1, (void*)arg2, arg3);
        break;
    case ALICE_A2B_MEMSET:
        memset((void*)arg1, (arg2 & 0xFF), arg3);
        break;
    case ALICE_A2B_MEMSET32:
        memset32((void*)arg1, arg2, arg3);
        break;
    case ALICE_A2B_READ32:
        if ((int)arg3 < 0)
            maika->mailbox.cry2arm[1] = readAs(arg1, arg3 & 0x7fffffff);
        else
            maika->mailbox.cry2arm[1] = vp arg1;
        break;
    case ALICE_A2B_WRITE32:
        if ((int)arg3 < 0)
            writeAs(arg1, arg2, arg3 & 0x7fffffff);
        else
            vp arg1 = arg2;
        break;
    default:
        break;
    }

    maika->mailbox.arm2cry[3] = -1;
    maika->mailbox.arm2cry[2] = -1;
    maika->mailbox.arm2cry[1] = -1;

    return -1;
}