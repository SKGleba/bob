#ifndef __CRYPTO_H__
#define __CRYPTO_H__

#include "types.h"

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

#define CRYPTO_DMAC4_FUNC_TARGETS_KS 0x10000000 // OR it

int crypto_bigmacDefaultCmd(bool second_channel, uint32_t src, uint32_t dst, uint32_t sz, uint32_t cmd, uint32_t work_ks, uint32_t iv, uint32_t unk_status);
void crypto_waitStopBigmacOps(bool disable_future_ops);
uint32_t crypto_memset(bool second_channel, uint32_t addr, uint32_t len, uint32_t fill_value32);
#define crypto_memcpy(second_channel, dst, src, sz) crypto_bigmacDefaultCmd(second_channel, src, dst, sz, CRYPTO_DMAC4_FUNC_MEMCPY, 0, 0, 0)

#endif