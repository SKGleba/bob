#include "include/ernie.h"
#include "include/utils.h"
#include "include/clib.h"
#include "include/jig.h"

static uint16_t l_current_request_no;

int jig_update_shared_buffer(uint8_t* msg, uint8_t offset, uint8_t size, bool push) {
    int ret = -1;
    if (offset >= JIG_KERMIT_SHBUF_SIZE || size > JIG_KERMIT_SHBUF_SIZE || offset + size > JIG_KERMIT_SHBUF_SIZE)
        return ret;
    jig_cmd_kermit2jig_s cmd_buffer;
    uint8_t copied = 0;
    while ((copied + sizeof(cmd_buffer.data)) <= size) {
        memset(&cmd_buffer, 0, sizeof(cmd_buffer));
        cmd_buffer.offset = copied;
        cmd_buffer.size = sizeof(cmd_buffer.data);
        memcpy(cmd_buffer.data, msg + copied, sizeof(cmd_buffer.data));
        ret = ernie_exec_cmd(ERNIE_CMD_SET_KERMITJIG_SHBUF, &cmd_buffer, sizeof(cmd_buffer));
        copied += sizeof(cmd_buffer.data);
    }
    if (copied < size) {
        memset(&cmd_buffer, 0, sizeof(cmd_buffer));
        cmd_buffer.offset = copied;
        cmd_buffer.size = size - copied;
        memcpy(cmd_buffer.data, msg + copied, size - copied);
        ret = ernie_exec_cmd(ERNIE_CMD_SET_KERMITJIG_SHBUF, &cmd_buffer, (sizeof(cmd_buffer) - sizeof(cmd_buffer.data)) + (size - copied));
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
        cmd_buffer.offset = copied;
        cmd_buffer.size = sizeof(cmd_buffer.data);
        ret = ernie_exec_cmd(ERNIE_CMD_GET_KERMITJIG_SHBUF, &cmd_buffer, sizeof(cmd_buffer) - sizeof(cmd_buffer.data));
        memcpy(msg + copied, &g_ernie_comms.rx[ERNIE_RX_DATA(0)], sizeof(cmd_buffer.data));
        copied += sizeof(cmd_buffer.data);
    }
    if (copied < size) {
        memset(&cmd_buffer, 0, sizeof(cmd_buffer));
        cmd_buffer.offset = copied;
        cmd_buffer.size = size - copied;
        ret = ernie_exec_cmd(ERNIE_CMD_GET_KERMITJIG_SHBUF, &cmd_buffer, sizeof(cmd_buffer) - sizeof(cmd_buffer.data));
        memcpy(msg + copied, &g_ernie_comms.rx[ERNIE_RX_DATA(0)], size - copied);
    }
    return ret;
}

/*

static void jig_bert_check_exec_rx_cmd(void) {
    jig_kermit_bert_shbuf_s msg;
READ_PRE:
    jig_read_shared_buffer(&msg, 0, sizeof(msg));
    if (!(msg.magic == JIG_KERMIT_BERT_MAGIC))
        return;
    if (msg.req_no != msg.completed_req_no)
        goto READ_PRE;
    if (msg.req_no == l_current_request_no)
        return;
    if (msg.req_id & JIG_BERT_REQ_FLAG_ISREPLY)
        return;
    
}

int jig_bert_exec_tx_cmd(uint16_t cmd, void *data, uint16_t data_size) {
    jig_kermit_bert_shbuf_s msg;
    memset(&msg, 0, sizeof(msg));
    msg.magic = JIG_KERMIT_BERT_MAGIC;
    msg.req_no = -1;
    jig_bert_check_exec_my_cmd(); // complete pending ops
    jig_update_shared_buffer(&msg, 0, sizeof(msg), false); // stop new ops
    msg.req_no = l_current_request_no + 1;
    msg.req_id = cmd;
    msg.full_data_size = data_size;
    memcpy(msg.data, data, data_size);
    msg.completed_req_no = msg.req_no;
    l_current_request_no = msg.req_no;
    jig_update_shared_buffer(&msg, 0, sizeof(msg), true);
    while(1) {
        jig_read_shared_buffer(&msg, 0, sizeof(msg));
        if (msg.magic != JIG_KERMIT_BERT_MAGIC)
            return;
        if (msg.completed_req_no == msg.req_no) {
            if (msg.req_no != l_current_request_no) {
                if (msg.req_id & JIG_BERT_REQ_FLAG_ISREPLY)
                    return 
            }
        }
    };
}

void jig_bert_printn(char *str, int n) {

}
*/