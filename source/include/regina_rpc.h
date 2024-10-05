#ifndef __REF_RGN_RPC_H__
#define __REF_RGN_RPC_H__

#include "types.h"
// #include "paddr.h"

#define RGN_RPC_SRAM_COMBUF_OFFSET (0xfc0)

struct _rgn_rpc_combuf_s {
    int global_state;
    uint32_t rpc_status;
    int ret;
    union {
        struct {
            uint16_t magic;
            uint8_t hash;
            uint8_t id;
        } __attribute__((packed)) cmd;
        uint32_t cmd_packed;
    };
    uint32_t args[4];
    uint32_t extra_data[8];
} __attribute__((packed));
typedef struct _rgn_rpc_combuf_s rgn_rpc_combuf_s;

#define RGN_RPC_CMD_MAGIC 0x6A6E

#define RGN_RPC_STATUS_READY 0x57414954
#define RGN_RPC_STATUS_PARSE 0x50524550
#define RGN_RPC_STATUS_INCMD 0x444f4954
#define RGN_RPC_STATUS_REPLY 0x444f4e45

#define RGN_RPC_DELAY 0x100

enum RGN_RPC_CMDS {
    RGN_RPC_CMD_NOP = 1,
    RGN_RPC_CMD_READ32,
    RGN_RPC_CMD_WRITE32,
    RGN_RPC_CMD_MEMSET,
    RGN_RPC_CMD_MEMCPY,
    RGN_RPC_CMD_MEMSET32
};

#ifndef RGN_RPC_COMBUF_OFFSET
void rpc_loop(void);
#define RGN_RPC_COMBUF_OFFSET ((void *)(BOOTRAM_OFFSET + RGN_RPC_SRAM_COMBUF_OFFSET))
#endif

#endif