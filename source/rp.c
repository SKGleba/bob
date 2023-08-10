#include "include/defs.h"
#include "include/clib.h"
#include "include/utils.h"
#include "include/debug.h"
#include "include/jig.h"
#include "include/ex.h"
#include "include/alice.h"
#include "include/rpc.h"

volatile int g_rpc_status = 0;

void rpc_loop(void) {
    uint8_t xsize = 0; // rpc cmd extra return sz
    uint8_t chash = 0; // calculated cmd checksum
    uint32_t cret = 0; // rpc cmd exit return val
    rpc_buf_s rpc_buf; // full rpc cmd & data buf
    bool push_reply = true; // push msg to server
    uint32_t delay_cval = RPC_READ_DELAY; // recv
    uint32_t delay_rval = RPC_WRITE_DELAY; //send
    uint32_t(*ccode)() = NULL;
    if (g_rpc_status < 0) {
        printf("[BOB] RPC mode disabled, status: %X\n", g_rpc_status);
        return;
    }
    printf("[BOB] entering RPC mode, delay %X\n", delay_cval);
    g_rpc_status |= RPC_STATUS_RUNNING;
    while (true) {
        statusled(STATUS_RPC_WAIT);
        delay(delay_cval);

        if (g_rpc_status & RPC_STATUS_REQUEST_BLOCK) {
            g_rpc_status |= RPC_STATUS_BLOCKED;
            statusled(STATUS_RPC_BLOCKED);
            printf("[BOB] RPC blocked\n");
            do {
                statusled(STATUS_RPC_BLOCKED);
                delay(RPC_BLOCKED_DELAY);
                statusled(STATUS_RPC_BLOCKED2);
                delay(RPC_BLOCKED_DELAY);
            } while (g_rpc_status & RPC_STATUS_REQUEST_BLOCK);
            printf("[BOB] RPC unblocked\n");
            g_rpc_status &= ~RPC_STATUS_BLOCKED;
        }

        statusled(STATUS_RPC_READ);
        memset(&rpc_buf, 0, sizeof(rpc_buf_s));
        jig_read_shared_buffer((uint8_t*)&rpc_buf.cmd, 0, sizeof(rpc_cmd_s));

        statusled(STATUS_RPC_CHECK);
        if (rpc_buf.cmd.magic != RPC_MAGIC || (rpc_buf.cmd.cmd_id & RPC_FLAG_REPLY))
            continue;
        chash = 0;
        for (uint8_t i = 3; i < sizeof(rpc_cmd_s); i++) // start from after hash
            chash += *(uint8_t*)((uint8_t*)&rpc_buf.cmd + i);
        if (chash != rpc_buf.cmd.hash)
            continue;

        statusled(STATUS_RPC_READ);
        if (rpc_buf.cmd.cmd_id & RPC_FLAG_EXTRA)
            jig_read_shared_buffer(rpc_buf.extra_data, sizeof(rpc_cmd_s), sizeof(rpc_buf.extra_data));

        printf("[BOB] RPC CMD %X\n", rpc_buf.cmd.cmd_id);
        statusled(STATUS_RPC_EXECUTE);

        g_rpc_status |= RPC_STATUS_INCMD;

        cret = -1;
        xsize = 0;
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
            delay_rval = rpc_buf.cmd.args[1];
            break;
        case RPC_CMD_STOP_RPC:
            cret = 0;
            break;
        case RPC_CMD_SET_PUSH:
            cret = push_reply;
            push_reply = (int)rpc_buf.cmd.args[0];
            break;
        case RPC_CMD_HEXDUMP:
            hexdump(rpc_buf.cmd.args[0], rpc_buf.cmd.args[1], rpc_buf.cmd.args[2]);
            cret = 0;
            break;
        case RPC_CMD_MEMSET32:
            cret = (uint32_t)memset32((void*)rpc_buf.cmd.args[0], rpc_buf.cmd.args[1], rpc_buf.cmd.args[2]);
            break;
        case RPC_CMD_ARM_RESET:
            cret = 0;
            alice_armReBoot((int)rpc_buf.cmd.args[0], (bool)rpc_buf.cmd.args[1], (bool)rpc_buf.cmd.args[2]);
            break;
        case RPC_CMD_SET_XCTABLE:
            cret = 0;
            set_exception_table((bool)rpc_buf.cmd.args[0]);
            break;
        case RPC_CMD_SET_INTS:
            cret = 0;
            if ((bool)rpc_buf.cmd.args[0]) {
                if ((bool)rpc_buf.cmd.args[1])
                    alice_setupInts();
                _MEP_INTR_ENABLE_
            } else
                _MEP_INTR_DISABLE_
            break;

        case RPC_CMD_COPYTO:
            cret = (uint32_t)memcpy((void*)rpc_buf.cmd.args[0], rpc_buf.extra_data, rpc_buf.cmd.args[1]);
            break;
        case RPC_CMD_COPYFROM:
            cret = (uint32_t)memcpy(rpc_buf.extra_data, (void*)rpc_buf.cmd.args[0], rpc_buf.cmd.args[1]);
            xsize = rpc_buf.cmd.args[1];
            break;
        case RPC_CMD_EXEC:
            ccode = (void*)rpc_buf.cmd.args[0];
            printf("[BOB] RPC EXEC %X\n", ccode);
            cret = ccode(rpc_buf.cmd.args[1], rpc_buf.cmd.args[2], (uint32_t)rpc_buf.extra_data);
            xsize = sizeof(rpc_buf.extra_data);
            break;
        case RPC_CMD_EXEC_EXTENDED:
            ccode = (void*)rpc_buf.cmd.args[0];
            printf("[BOB] RPC EXECE %X\n", ccode);
            cret = ccode(rpc_buf.cmd.args[1], rpc_buf.cmd.args[2], *(uint32_t*)((uint32_t*)&rpc_buf.extra_data), *(uint32_t*)((uint32_t*)&rpc_buf.extra_data + 1), *(uint32_t*)((uint32_t*)&rpc_buf.extra_data + 2), *(uint32_t*)((uint32_t*)&rpc_buf.extra_data + 3), *(uint32_t*)((uint32_t*)&rpc_buf.extra_data + 4), *(uint32_t*)((uint32_t*)&rpc_buf.extra_data + 5));
            break;
        default:
            break;
        }

        g_rpc_status &= ~RPC_STATUS_INCMD;

        statusled(STATUS_RPC_WAIT);
        delay(delay_rval);

        printf("[BOB] RPC RET %X\n", cret);
        statusled(STATUS_RPC_WRITE);
        
        rpc_buf.cmd.args[0] = cret;
        rpc_buf.cmd.cmd_id |= RPC_FLAG_REPLY;
        rpc_buf.cmd.hash = 0;
        for (uint8_t i = 3; i < sizeof(rpc_cmd_s); i++) // start from after hash
            rpc_buf.cmd.hash += *(uint8_t*)((uint8_t*)&rpc_buf.cmd + i);
        
        if (push_reply)
            jig_update_shared_buffer((uint8_t*)&rpc_buf, 0, sizeof(rpc_cmd_s) + xsize, true);
        else {
            jig_update_shared_buffer((uint8_t*)&rpc_buf + 3, 0, sizeof(rpc_cmd_s) + xsize, false);
            jig_update_shared_buffer((uint8_t*)&rpc_buf.cmd, 0, 3, false);
        }

        if (rpc_buf.cmd.cmd_id == (RPC_CMD_STOP_RPC | RPC_FLAG_REPLY))
            break;

        if (g_rpc_status & RPC_STATUS_REQUEST_STOP)
            break;
    }

    g_rpc_status &= 0xFFFFFF00; // clear status, keep requests

    printf("[BOB] exiting RPC mode\n");
    statusled(STATUS_RPC_EXIT);
}