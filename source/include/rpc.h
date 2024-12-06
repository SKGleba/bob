#ifndef __RPC_H__
#define __RPC_H__

#include "types.h"
#include "jig.h"

#define RPC_MAGIC 0xEB0B
#define RPC_UART_MAGIC '&'
#define RPC_UART_WATERMARK "?PC_"
#define RPC_FLAG_REPLY 0b10000000 // data is my reply
#define RPC_FLAG_EXTRA 0b01000000 // use extra_data

#define RPC_STATUS_RUNNING 0b1
#define RPC_STATUS_BLOCKED 0b10
#define RPC_STATUS_INCMD 0b100

#define RPC_STATUS_REQUEST_STOP 0x8000
#define RPC_STATUS_REQUEST_BLOCK 0x800000
#define RPC_STATUS_DISABLED 0x80000000

enum RPC_COMMANDS {
    RPC_CMD_NOP,
    RPC_CMD_READ32,
    RPC_CMD_WRITE32,
    RPC_CMD_MEMSET,
    RPC_CMD_MEMCPY,
    RPC_CMD_SET_DELAY,
    RPC_CMD_STOP_RPC,
    RPC_CMD_SET_PUSH,
    RPC_CMD_HEXDUMP,
    RPC_CMD_MEMSET32,
    RPC_CMD_ARM_RESET,
    RPC_CMD_SET_XCTABLE,
    RPC_CMD_SET_INTS,
    RPC_CMD_START_ALICE_RPC,
    RPC_CMD_GET_ALICE_TASK_STATUS,
    RPC_CMD_SET_UART_MODE,
    RPC_CMD_DRAM_INIT,
    RPC_CMD_AGX_HANDLE,
    RPC_CMD_REGINA_MEMCPY,
    RPC_CMD_INIT_STORAGE,
    RPC_CMD_READ_SD,
    RPC_CMD_WRITE_SD,
    RPC_CMD_READ_EMMC,
    RPC_CMD_WRITE_EMMC,
    RPC_CMD_COPYTO = RPC_FLAG_EXTRA,
    RPC_CMD_COPYFROM,
    RPC_CMD_EXEC,           // exec arg0(arg1, arg2, &extra) | ret to arg0
    RPC_CMD_EXEC_EXTENDED,  // exec arg0(arg1, arg2, extra32[X], extra32[X+1], extra32[X+2], extra32[X+3]) | rets to arg0
    RPC_CMD_SCHEDULE_ALICE_TASK,
    RPC_CMD_LOAD_ALICE,
    RPC_CMD_LOAD_REGINA,
    RPC_CMD_REGINA_CMD
};

struct _rpc_uart_cmd_s {
    uint8_t magic;
    uint8_t id;
    uint8_t data_size;
    uint8_t hash;
};// __attribute__((packed));
typedef struct _rpc_uart_cmd_s rpc_uart_cmd_s;

struct _rpc_jig_cmd_s { // size is 0x10
    uint16_t magic;
    uint8_t hash;
    uint8_t cmd_id;
    uint32_t args[3];
};// __attribute__((packed));
typedef struct _rpc_jig_cmd_s rpc_jig_cmd_s;

struct _rpc_jig_buf_s { // size is 0x40
    rpc_jig_cmd_s cmd;
    uint8_t extra_data[JIG_KERMIT_SHBUF_SIZE - sizeof(rpc_jig_cmd_s)];
};// __attribute__((packed));
typedef struct _rpc_jig_buf_s rpc_jig_buf_s;

struct _rpc_params_s {
    bool push_reply;
    uint32_t delay_cval;
    uint32_t delay_rval;
    bool uart_mode;
    uint32_t uart_scan_timeout;
};// __attribute__((packed));
typedef struct _rpc_params_s rpc_params_s;

extern volatile int g_rpc_status;

void rpc_loop(void);

#endif