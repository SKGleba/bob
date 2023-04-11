#ifndef __RPC_H__
#define __RPC_H__

#define RPC_MAGIC 0xEB0B
#define RPC_FLAG_REPLY 0b10000000 // data is my reply
#define RPC_FLAG_EXTRA 0b01000000 // use extra_data

enum RPC_COMMANDS {
    RPC_CMD_NOP,
    RPC_CMD_READ32,
    RPC_CMD_WRITE32,
    RPC_CMD_MEMSET,
    RPC_CMD_MEMCPY,
    RPC_CMD_SET_DELAY,
    RPC_CMD_STOP_RPC,
    RPC_CMD_COPYTO = RPC_FLAG_EXTRA,
    RPC_CMD_COPYFROM,
    RPC_CMD_EXEC, // exec arg0(arg1, arg2, &extra) | ret to arg0
    RPC_CMD_EXEC_EXTENDED // exec argX(extra32[X], extra32[X+1], extra32[X+2], extra32[X+3]) | rets to argX
};

struct _rpc_cmd_s { // size is 0x10
    uint16_t magic;
    uint8_t hash;
    uint8_t cmd_id;
    uint32_t args[3];
} __attribute__((packed));
typedef struct _rpc_cmd_s rpc_cmd_s;

struct _rpc_buf_s { // size is 0x40
    rpc_cmd_s cmd;
    uint8_t extra_data[JIG_KERMIT_SHBUF_SIZE - sizeof(rpc_cmd_s)];
} __attribute__((packed));
typedef struct _rpc_buf_s rpc_buf_s;

void rpc_loop(void);

#endif