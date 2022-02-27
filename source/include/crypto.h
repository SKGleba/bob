#ifndef __CRYPTO_H__
#define __CRYPTO_H__

#include "types.h"

#define NULL_S_PA 0x1D001000

#define CRYPTO_BIGMAC 0xE0050000
#define CRYPTO_BIGMAC_EXT_KEY 0xE0050200

#define CRYPTO_CHAN(c0, cn) (c0 + ( cn * 0x80))

enum CRYPTO_DMAC4_FUNCS {
    CRYPTO_DMAC4_FUNC_MEMCPY,
    CRYPTO_DMAC4_FUNC_AES_ECB_ENC,
    CRYPTO_DMAC4_FUNC_AES_ECB_DEC,
    CRYPTO_DMAC4_FUNC_SHA1,
    CRYPTO_DMAC4_FUNC_RNG,
    CRYPTO_DMAC4_FUNC_AES_CBC_ENC = 9,
    CRYPTO_DMAC4_FUNC_AES_CBC_DEC,
    CRYPTO_DMAC4_FUNC_SHA224,
    CRYPTO_DMAC4_FUNC_MEMSET,
    CRYPTO_DMAC4_FUNC_AES_CTR_ENC = 17,
    CRYPTO_DMAC4_FUNC_AES_CTR_DEC,
    CRYPTO_DMAC4_FUNC_SHA256
};

// base: 0xE0050000 (channel0), 0xE0050080 (channel1)
typedef struct crypto_bigmac_op_channel_t {
    uint32_t src; // E0050000
    uint32_t dst; // E0050004
    uint32_t sz; // E0050008
    uint32_t func; // E005000C
    uint32_t work_ks; // E0050010
    uint32_t iv; // E0050014
    uint32_t next; // E0050018
    uint32_t trigger; // E005001C
    uint32_t status; // E0050020
    uint32_t res; // E0050024
    uint32_t unk_lock; // E0050028
    uint32_t unk_2C;
    uint32_t unk_30;
    uint32_t fill_v32;
    uint32_t unk_38;
    uint32_t rng;
    uint32_t unk[0x10];
} crypto_bigmac_op_channel_t;

typedef struct crypto_bigmac_if_t {
    crypto_bigmac_op_channel_t chan[2];
    uint32_t unk_100;
    uint32_t unk_status;
} crypto_bigmac_if_t;

int crypto_bigmacDefaultCmd(bool second_channel, uint32_t src, uint32_t dst, uint32_t sz, uint32_t cmd, uint32_t work_ks, uint32_t iv, uint32_t unk_status);
void crypto_waitStopBigmacOps(bool disable_future_ops);
uint32_t crypto_memset(bool second_channel, uint32_t addr, uint32_t len, uint32_t unk);

#endif