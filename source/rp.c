#include "include/defs.h"
#include "include/clib.h"
#include "include/utils.h"
#include "include/debug.h"
#include "include/jig.h"
#include "include/rpc.h"

void rpc_loop(void) {
    uint8_t chash = 0; // calculated cmd checksum
    uint32_t cret = 0; // rpc cmd exit return val
    rpc_buf_s rpc_buf; // full rpc cmd & data buf
    uint32_t delay_cval = RPC_DELAY; // delay val
    uint32_t(*ccode)() = NULL;
    printf("[BOB] entering RPC mode, delay %X\n", delay_cval);
    while (true) {
        delay(delay_cval);

        //printf("[BOB] RPC CHK\n");

        memset(&rpc_buf, 0, sizeof(rpc_buf_s));
        jig_read_shared_buffer((uint8_t*)&rpc_buf.cmd, 0, sizeof(rpc_cmd_s));
        
        if (rpc_buf.cmd.magic != RPC_MAGIC || (rpc_buf.cmd.cmd_id & RPC_FLAG_REPLY))
            continue;

        chash = 0;
        for (uint8_t i = 3; i < sizeof(rpc_cmd_s); i++) // start from after hash
            chash += *(uint8_t*)((uint8_t*)&rpc_buf.cmd + i);
        if (chash != rpc_buf.cmd.hash)
            continue;

        printf("[BOB] RPC CMD %X\n", rpc_buf.cmd.cmd_id);

        if (rpc_buf.cmd.cmd_id & RPC_FLAG_EXTRA)
            jig_read_shared_buffer(rpc_buf.extra_data, sizeof(rpc_cmd_s), sizeof(rpc_buf.extra_data));

        cret = -1;
        
        switch (rpc_buf.cmd.cmd_id) {
        case RPC_CMD_NOP:
            cret = get_build_timestamp();
            break;
        case RPC_CMD_READ32:
            cret = vp rpc_buf.cmd.args[0];
            break;
        case RPC_CMD_WRITE32:
            vp(rpc_buf.cmd.args[0]) = rpc_buf.cmd.args[1];
            cret = 0;
            break;
        case RPC_CMD_MEMSET:
            cret = (uint32_t)memset((void*)rpc_buf.cmd.args[0], rpc_buf.cmd.args[1] & 0xFF, rpc_buf.cmd.args[2]);
            break;
        case RPC_CMD_MEMCPY:
            cret = (uint32_t)memcpy((void*)rpc_buf.cmd.args[0], (void*)rpc_buf.cmd.args[1], rpc_buf.cmd.args[2]);
            break;
        case RPC_CMD_SET_DELAY:
            cret = delay_cval;
            delay_cval = rpc_buf.cmd.args[0];
            break;
        case RPC_CMD_STOP_RPC:
            cret = 0;
            break;
        case RPC_CMD_COPYTO:
            cret = (uint32_t)memcpy((void*)rpc_buf.cmd.args[0], rpc_buf.extra_data, rpc_buf.cmd.args[1]);
            break;
        case RPC_CMD_COPYFROM:
            cret = (uint32_t)memcpy(rpc_buf.extra_data, (void*)rpc_buf.cmd.args[0], rpc_buf.cmd.args[1]);
            break;
        case RPC_CMD_EXEC:
            ccode = (void*)rpc_buf.cmd.args[0];
            printf("[BOB] RPC EXEC %X\n", ccode);
            cret = ccode(rpc_buf.cmd.args[1], rpc_buf.cmd.args[2], (uint32_t)rpc_buf.extra_data);
            break;
        case RPC_CMD_EXEC_EXTENDED:
            ccode = (void*)rpc_buf.cmd.args[0];
            printf("[BOB] RPC EXECE %X\n", ccode);
            cret = ccode(rpc_buf.cmd.args[1], rpc_buf.cmd.args[2], *(uint32_t*)((uint32_t*)&rpc_buf.extra_data), *(uint32_t*)((uint32_t*)&rpc_buf.extra_data + 1), *(uint32_t*)((uint32_t*)&rpc_buf.extra_data + 2), *(uint32_t*)((uint32_t*)&rpc_buf.extra_data + 3), *(uint32_t*)((uint32_t*)&rpc_buf.extra_data + 4), *(uint32_t*)((uint32_t*)&rpc_buf.extra_data + 5));
            break;
        default:
            break;
        }

        printf("[BOB] RPC RET %X\n", cret);

        rpc_buf.cmd.args[0] = cret;

        if (rpc_buf.cmd.cmd_id & RPC_FLAG_EXTRA)
            jig_update_shared_buffer(rpc_buf.extra_data, sizeof(rpc_cmd_s), sizeof(rpc_buf.extra_data), false);

        rpc_buf.cmd.cmd_id |= RPC_FLAG_REPLY;
        jig_update_shared_buffer((uint8_t*)&rpc_buf.cmd, 0, sizeof(rpc_cmd_s), true);

        if (rpc_buf.cmd.cmd_id == (RPC_CMD_STOP_RPC & ~RPC_FLAG_REPLY))
            break;
    }

    printf("[BOB] exiting RPC mode\n");
}