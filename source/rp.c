#include "include/alice.h"
#include "include/clib.h"
#include "include/compat.h"
#include "include/debug.h"
#include "include/defs.h"
#include "include/ex.h"
#include "include/jig.h"
#include "include/maika.h"
#include "include/rpc.h"
#include "include/dram.h"
#include "include/utils.h"
#include "include/regina.h"

volatile int g_rpc_status = 0;

static uint8_t rpc_handle_cmd(uint8_t cmd_id, uint32_t *args, uint32_t *extra_data, rpc_params_s *params) {
    int cret = -1;
    uint8_t xsize = 0;
    uint32_t (*ccode)() = NULL;

    printf("[BOB] RPC CMD %X\n", cmd_id);

    g_rpc_status |= RPC_STATUS_INCMD;

    switch (cmd_id) {
        case RPC_CMD_NOP:
            cret = get_build_timestamp();
            break;
        case RPC_CMD_READ32:
            if ((int)args[2] < 0)
                cret = readAs(args[0], args[2] & 0x7fffffff);
            else
                cret = vp args[0];
            break;
        case RPC_CMD_WRITE32:
            if ((int)args[2] < 0)
                writeAs(args[0], args[1], args[2] & 0x7fffffff);
            else
                vp(args[0]) = args[1];
            cret = 0;
            break;
        case RPC_CMD_MEMSET:
            cret = (uint32_t)memset((void *)args[0], args[1] & 0xFF, args[2]);
            break;
        case RPC_CMD_MEMCPY:
            cret = (uint32_t)memcpy((void *)args[0], (void *)args[1], args[2]);
            break;
        case RPC_CMD_SET_DELAY:
            cret = params->delay_cval;
            params->delay_cval = args[0];
            params->delay_rval = args[1];
            break;
        case RPC_CMD_STOP_RPC:
            cret = 0;
            break;
        case RPC_CMD_SET_PUSH:
            cret = params->push_reply;
            params->push_reply = (bool)args[0];
            break;
        case RPC_CMD_HEXDUMP:
            hexdump(args[0], args[1], args[2]);
            cret = 0;
            break;
        case RPC_CMD_MEMSET32:
            cret = (uint32_t)memset32((void *)args[0], args[1], args[2]);
            break;
        case RPC_CMD_ARM_RESET:
            cret = 0;
            compat_armReBoot((int)args[0], (bool)args[1], (bool)args[2]);
            break;
        case RPC_CMD_SET_XCTABLE:
            cret = 0;
            set_exception_table((bool)args[0]);
            break;
        case RPC_CMD_SET_INTS:
            cret = 0;
            if ((bool)args[0]) {
                if ((bool)args[1])
                    setup_ints();
                _MEP_INTR_ENABLE_
            } else
                _MEP_INTR_DISABLE_
            break;
        case RPC_CMD_START_ALICE_RPC:  // (ALICE: block_bob, delegate_core, BOB:wait_task_done)
            cret = alice_schedule_bob_task(0, ALICE_ZERO_TASKS_ENABLE_RPC, true, (bool)args[2], args[0], args[1], 0, 0);
            break;
        case RPC_CMD_GET_ALICE_TASK_STATUS:
            cret = alice_get_task_status((int)args[0], (bool)args[1], (bool)args[2]);
            break;
        case RPC_CMD_SET_UART_MODE:
            cret = params->uart_mode;
            params->uart_mode = args[0];
            params->uart_scan_timeout = args[1];
            break;
        case RPC_CMD_DRAM_INIT:
            cret = dram_init((int)args[0], (bool)args[1]);
            break;
        case RPC_CMD_AGX_HANDLE:
            cret = compat_handleAllegrex((int)args[0], (int)args[1], (int)args[2]);
            break;
        case RPC_CMD_REGINA_MEMCPY:
            cret = regina_sendCmd(RGN_RPC_CMD_MEMCPY, args, NULL);
            break;

        case RPC_CMD_COPYTO:
            cret = (uint32_t)memcpy((void *)args[0], extra_data, args[1]);
            break;
        case RPC_CMD_COPYFROM:
            cret = (uint32_t)memcpy(extra_data, (void *)args[0], args[1]);
            xsize = args[1];
            break;
        case RPC_CMD_EXEC:
            ccode = (void *)args[0];
            printf("[BOB] RPC EXEC %X\n", ccode);
            cret = ccode(args[1], args[2], extra_data);
            break;
        case RPC_CMD_EXEC_EXTENDED:
            ccode = (void *)args[0];
            printf("[BOB] RPC EXECE %X\n", ccode);
            cret = ccode(args[1], args[2], extra_data[0], extra_data[1], extra_data[2], extra_data[3], extra_data[4], extra_data[5]);
            break;
        case RPC_CMD_SCHEDULE_ALICE_TASK:
            cret = alice_schedule_bob_task((int)args[0], (int)args[1], (bool)args[2], (bool)extra_data[0], (int)extra_data[1], (int)extra_data[2],
                                           (int)extra_data[3], (int)extra_data[4]);
            break;
        case RPC_CMD_LOAD_ALICE:
            cret = alice_loadAlice((void *)args[0], (bool)args[1], (int)args[2], (bool)extra_data[0], (bool)extra_data[1], (bool)extra_data[2],
                                   (bool)extra_data[3]);
            break;
        case RPC_CMD_LOAD_REGINA:
            cret = regina_loadRegina((void *)args[0], (bool)args[1], (bool)args[2]);
            break;
        case RPC_CMD_REGINA_CMD:
            cret = regina_sendCmd((int)args[0], extra_data, NULL); // yhh
            break;
        default:
            break;
    }

    g_rpc_status &= ~RPC_STATUS_INCMD;

    printf("[BOB] RPC RET %X\n", cret);

    args[0] = (uint32_t)cret;
    return xsize;
}

// use kermit<->jig shared buf for RPC comms
static bool rpc_rxw_cmd_shbuf(rpc_params_s *params) {
    uint8_t xsize = 0;      // rpc cmd extra return sz
    uint8_t chash = 0;      // calculated cmd checksum
    rpc_jig_buf_s rpc_buf;  // full rpc cmd & data buf

    statusled(STATUS_RPC_READ);
    memset(&rpc_buf, 0, sizeof(rpc_jig_buf_s));
    jig_read_shared_buffer((uint8_t *)&rpc_buf.cmd, 0, sizeof(rpc_jig_cmd_s));

    statusled(STATUS_RPC_CHECK);
    if (rpc_buf.cmd.magic != RPC_MAGIC || (rpc_buf.cmd.cmd_id & RPC_FLAG_REPLY))
        return false;
    chash = 0;
    for (uint8_t i = 3; i < sizeof(rpc_jig_cmd_s); i++)  // start from after hash
        chash += *(uint8_t *)((uint8_t *)&rpc_buf.cmd + i);
    if (chash != rpc_buf.cmd.hash)
        return false;

    statusled(STATUS_RPC_READ);
    if (rpc_buf.cmd.cmd_id & RPC_FLAG_EXTRA)
        jig_read_shared_buffer(rpc_buf.extra_data, sizeof(rpc_jig_cmd_s), sizeof(rpc_buf.extra_data));

    statusled(STATUS_RPC_EXECUTE);
    xsize = rpc_handle_cmd(rpc_buf.cmd.cmd_id, rpc_buf.cmd.args, (uint32_t *)rpc_buf.extra_data, params);

    rpc_buf.cmd.cmd_id |= RPC_FLAG_REPLY;
    rpc_buf.cmd.hash = 0;
    for (uint8_t i = 3; i < sizeof(rpc_jig_cmd_s); i++)  // start from after hash
        rpc_buf.cmd.hash += *(uint8_t *)((uint8_t *)&rpc_buf.cmd + i);

    statusled(STATUS_RPC_WAIT);
    delay(params->delay_rval);

    statusled(STATUS_RPC_WRITE);
    if (params->push_reply)
        jig_update_shared_buffer((uint8_t *)&rpc_buf, 0, sizeof(rpc_jig_cmd_s) + xsize, true);
    else {
        jig_update_shared_buffer((uint8_t *)&rpc_buf + 4, 4, sizeof(rpc_jig_cmd_s) + xsize - 4, false);
        jig_update_shared_buffer((uint8_t *)&rpc_buf, 0, 4, false);
    }

    if (rpc_buf.cmd.cmd_id == (RPC_CMD_STOP_RPC | RPC_FLAG_REPLY))
        return true;

    return false;
}

// use UART for RPC comms
static bool rpc_rxw_cmd_uart(rpc_params_s *params) {
    rpc_uart_cmd_s cmd;
    uint32_t data[0x10];

    memset(&cmd, 0, sizeof(rpc_uart_cmd_s));
    memset(data, 0, sizeof(data));

    statusled(STATUS_RPC_READ);
    print(RPC_UART_WATERMARK "G0\n");
    if (scanb_timeout(&cmd, sizeof(rpc_uart_cmd_s), params->uart_scan_timeout) < 0)
        return false;

    statusled(STATUS_RPC_CHECK);
    if (cmd.magic != RPC_UART_MAGIC || cmd.hash != (cmd.id + cmd.data_size)) {
        statusled(STATUS_RPC_WAIT);
        delay(params->delay_rval);
        statusled(STATUS_RPC_WRITE);
        print(RPC_UART_WATERMARK "E1\n");
        rxflush();
        return false;
    }

    if (cmd.data_size && (cmd.data_size <= sizeof(data))) {
        statusled(STATUS_RPC_WAIT);
        delay(params->delay_rval);
        statusled(STATUS_RPC_READ);
        rxflush();
        print(RPC_UART_WATERMARK "G1\n");
        if (scanb_timeout(data, cmd.data_size, params->uart_scan_timeout) < 0)
            return false;
    }

    statusled(STATUS_RPC_EXECUTE);
    rpc_handle_cmd(cmd.id, data, &data[3], params);

    statusled(STATUS_RPC_WAIT);
    delay(params->delay_rval);

    statusled(STATUS_RPC_WRITE);
    printf(RPC_UART_WATERMARK "%X\n", data[0]);

    rxflush();

    if (cmd.id == RPC_CMD_STOP_RPC)
        return true;

    return false;
}

void rpc_loop(void) {
    rpc_params_s params;
    params.push_reply = false;            // push reply to jig
    params.delay_cval = RPC_READ_DELAY;   // recv
    params.delay_rval = RPC_WRITE_DELAY;  // send
    params.uart_mode = RPC_UART_MODE;     // use kermit uart
    params.uart_scan_timeout = 0;         // timeout for uart data check
    if (g_rpc_status < 0) {
        printf("[BOB] RPC mode disabled, status: %X\n", g_rpc_status);
        return;
    }
    printf("[BOB] entering RPC mode, delay %X\n", params.delay_cval);
    g_rpc_status |= RPC_STATUS_RUNNING;

    if (params.uart_mode)
        rxflush();

    while (true) {
        statusled(STATUS_RPC_WAIT);
        delay(params.delay_cval);

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

        if (params.uart_mode && rpc_rxw_cmd_uart(&params))
            break;
        else if (rpc_rxw_cmd_shbuf(&params))
            break;

        if (g_rpc_status & RPC_STATUS_REQUEST_STOP)
            break;
    }

    g_rpc_status &= 0xFFFFFF00;  // clear status, keep requests

    printf("[BOB] exiting RPC mode\n");
    statusled(STATUS_RPC_EXIT);
}