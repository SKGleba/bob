#include "include/types.h"
#include "include/utils.h"
#include "include/ex.h"
#include "include/crypto.h"

int crypto_bigmacDefaultCmd(bool second_channel, uint32_t src, uint32_t dst, uint32_t sz, uint32_t cmd, uint32_t work_ks, uint32_t iv, uint32_t unk_status) {

    volatile crypto_bigmac_if_t* bigmac_if = (crypto_bigmac_if_t*)CRYPTO_BIGMAC;
    volatile crypto_bigmac_op_channel_t* op_if = (crypto_bigmac_op_channel_t*)CRYPTO_CHAN(CRYPTO_BIGMAC, second_channel);

    op_if->src = src;
    op_if->dst = dst;
    op_if->sz = sz;
    op_if->work_ks = work_ks;
    if (iv)
        op_if->iv = iv;
    op_if->func = cmd;

    bigmac_if->unk_status = unk_status;

    op_if->trigger = 1;

    while ((op_if->res) & 1) {};
    
    return (int)op_if->res;
}

void crypto_waitStopBigmacOps(bool disable_future_ops) {
    register volatile uint32_t psw asm("$psw");
    if (psw & 1)
        PANIC("PSW", psw);

    volatile crypto_bigmac_if_t* bigmac_if = (crypto_bigmac_if_t*)CRYPTO_BIGMAC;

    // waitstop scheduled jobs for channel 0
    if (bigmac_if->chan[0].res & 1) {
        bigmac_if->chan[0].trigger = 0;
        while (bigmac_if->chan[0].res & 1) {};
    }

    // waitstop scheduled jobs for channel 1
    if (bigmac_if->chan[1].res & 1) {
        bigmac_if->chan[1].trigger = 0;
        while (bigmac_if->chan[1].res & 1) {};
    }

    // disable requests for channels 0/1
    if (disable_future_ops) {
        bigmac_if->chan[0].unk_lock = 3;
        bigmac_if->chan[1].unk_lock = 3;
    }
}

uint32_t crypto_memset(bool second_channel, uint32_t addr, uint32_t len, uint32_t fill_value32) {
    volatile crypto_bigmac_if_t* bigmac_if = (crypto_bigmac_if_t*)CRYPTO_BIGMAC;
    bigmac_if->chan[second_channel].fill_v32 = fill_value32;
    uint32_t ret = crypto_bigmacDefaultCmd(second_channel, 0, addr, len, CRYPTO_DMAC4_FUNC_MEMSET, 0, 0, 0);
    bigmac_if->unk_status = 0;
    return ret;
}