#include "include/ernie.h"
#include "include/utils.h"
#include "include/clib.h"
#include "include/jig.h"

int jig_update_shared_buffer(uint8_t* msg, uint8_t offset, uint8_t size, bool push) {
    int ret = -1;
    if (offset >= JIG_KERMIT_SHBUF_SIZE || size > JIG_KERMIT_SHBUF_SIZE || offset + size > JIG_KERMIT_SHBUF_SIZE)
        return ret;
    jig_cmd_kermit2jig_s cmd_buffer;
    uint8_t copied = 0;
    if (msg) {
        while ((copied + sizeof(cmd_buffer.data)) <= size) {
            memset(&cmd_buffer, 0, sizeof(cmd_buffer));
            cmd_buffer.offset = offset + copied;
            cmd_buffer.size = sizeof(cmd_buffer.data);
            memcpy(cmd_buffer.data, msg + copied, sizeof(cmd_buffer.data));
            ret = ernie_exec_cmd(ERNIE_CMD_SET_KERMITJIG_SHBUF, &cmd_buffer, sizeof(cmd_buffer));
            copied += sizeof(cmd_buffer.data);
        }
        if (copied < size) {
            memset(&cmd_buffer, 0, sizeof(cmd_buffer));
            cmd_buffer.offset = offset + copied;
            cmd_buffer.size = size - copied;
            memcpy(cmd_buffer.data, msg + copied, size - copied);
            ret = ernie_exec_cmd(ERNIE_CMD_SET_KERMITJIG_SHBUF, &cmd_buffer, (sizeof(cmd_buffer) - sizeof(cmd_buffer.data)) + (size - copied));
        }
    }
    if (push) {
        memset(&cmd_buffer, 0, sizeof(cmd_buffer));
        cmd_buffer.push_to_jig = 1;
        cmd_buffer.size = size;
        ret = ernie_exec_cmd(ERNIE_CMD_SET_KERMITJIG_SHBUF, &cmd_buffer, sizeof(cmd_buffer) - sizeof(cmd_buffer.data));
    }
    return ret;
}

int jig_read_shared_buffer(uint8_t* msg, uint8_t offset, uint8_t size) {
    int ret = -1;
    if (offset >= JIG_KERMIT_SHBUF_SIZE || size > JIG_KERMIT_SHBUF_SIZE || offset + size > JIG_KERMIT_SHBUF_SIZE)
        return ret;
    memset(msg, 0, size);
    jig_cmd_jig2kermit_s cmd_buffer;
    uint8_t copied = 0;
    while ((copied + sizeof(cmd_buffer.data)) <= size) {
        memset(&cmd_buffer, 0, sizeof(cmd_buffer));
        cmd_buffer.offset = offset + copied;
        cmd_buffer.size = sizeof(cmd_buffer.data);
        ret = ernie_exec_cmd(ERNIE_CMD_GET_KERMITJIG_SHBUF, &cmd_buffer, sizeof(cmd_buffer) - sizeof(cmd_buffer.data));
        memcpy(msg + copied, &g_ernie_comms.rx[ERNIE_RX_DATA(0)], sizeof(cmd_buffer.data));
        copied += sizeof(cmd_buffer.data);
    }
    if (copied < size) {
        memset(&cmd_buffer, 0, sizeof(cmd_buffer));
        cmd_buffer.offset = offset + copied;
        cmd_buffer.size = size - copied;
        ret = ernie_exec_cmd(ERNIE_CMD_GET_KERMITJIG_SHBUF, &cmd_buffer, sizeof(cmd_buffer) - sizeof(cmd_buffer.data));
        memcpy(msg + copied, &g_ernie_comms.rx[ERNIE_RX_DATA(0)], size - copied);
    }
    return ret;
}