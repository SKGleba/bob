#ifndef __CRYPTO_H__
#define __CRYPTO_H__

#include <hardware/crypto.h>

#include "types.h"

int crypto_bigmacDefaultCmd(bool second_channel, uint32_t src, uint32_t dst, uint32_t sz, uint32_t cmd, uint32_t work_ks, uint32_t iv, uint32_t unk_status);
void crypto_waitStopBigmacOps(bool disable_future_ops);
uint32_t crypto_memset(bool second_channel, uint32_t addr, uint32_t len, uint32_t fill_value32);
#define crypto_memcpy(second_channel, dst, src, sz) crypto_bigmacDefaultCmd(second_channel, src, dst, sz, CRYPTO_BIGMAC_FUNC_MEMCPY, 0, 0, 0)

#endif