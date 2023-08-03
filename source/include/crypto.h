#ifndef __CRYPTO_H__
#define __CRYPTO_H__

#include "types.h"

enum CRYPTO_BIGMAC_FUNCS {
    CRYPTO_BIGMAC_FUNC_MEMCPY,
    CRYPTO_BIGMAC_FUNC_AES_ECB_ENC,
    CRYPTO_BIGMAC_FUNC_AES_ECB_DEC,
    CRYPTO_BIGMAC_FUNC_SHA1,
    CRYPTO_BIGMAC_FUNC_RNG,
    CRYPTO_BIGMAC_FUNC_AES_CBC_ENC = 9,
    CRYPTO_BIGMAC_FUNC_AES_CBC_DEC,
    CRYPTO_BIGMAC_FUNC_SHA224,
    CRYPTO_BIGMAC_FUNC_MEMSET,
    CRYPTO_BIGMAC_FUNC_AES_CTR_ENC = 17,
    CRYPTO_BIGMAC_FUNC_AES_CTR_DEC,
    CRYPTO_BIGMAC_FUNC_SHA256
};

enum CRYPTO_BIGMAC_FUNC_FLAGS {
    CRYPTO_BIGMAC_FUNC_FLAG_USE_EXT_KEY = 0x80,
    CRYPTO_BIGMAC_FUNC_FLAG_KEYSIZE_64 = 0, // enum lul
    CRYPTO_BIGMAC_FUNC_FLAG_KEYSIZE_128 = 0x100,
    CRYPTO_BIGMAC_FUNC_FLAG_KEYSIZE_192 = 0x200,
    CRYPTO_BIGMAC_FUNC_FLAG_KEYSIZE_256 = 0x300,
    CRYPTO_BIGMAC_FUNC_FLAG_HASH_UPDATE = 0x400,
    CRYPTO_BIGMAC_FUNC_FLAG_HASH_FINALIZE = 0x800,
    CRYPTO_BIGMAC_FUNC_FLAG_TARGETS_KS = 0x10000000
};

int crypto_bigmacDefaultCmd(bool second_channel, uint32_t src, uint32_t dst, uint32_t sz, uint32_t cmd, uint32_t work_ks, uint32_t iv, uint32_t unk_status);
void crypto_waitStopBigmacOps(bool disable_future_ops);
uint32_t crypto_memset(bool second_channel, uint32_t addr, uint32_t len, uint32_t fill_value32);
#define crypto_memcpy(second_channel, dst, src, sz) crypto_bigmacDefaultCmd(second_channel, src, dst, sz, CRYPTO_BIGMAC_FUNC_MEMCPY, 0, 0, 0)

#endif