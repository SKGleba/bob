#include "include/types.h"
#include "include/clib.h"
#include "include/utils.h"
#include "include/ex.h"
#include "include/maika.h"
#include "include/paddr.h"
#include "include/crypto.h"

int crypto_bigmacDefaultCmd(bool second_channel, uint32_t src, uint32_t dst, uint32_t sz, uint32_t cmd, uint32_t work_key, uint32_t iv, uint32_t unk_status) {

    maika_s* maika = (maika_s*)MAIKA_OFFSET;

    maika->bigmac_ctrl.channel[second_channel].src = src;
    maika->bigmac_ctrl.channel[second_channel].dst = dst;
    maika->bigmac_ctrl.channel[second_channel].sz = sz;
    
    if (cmd & CRYPTO_BIGMAC_FUNC_FLAG_USE_EXT_KEY) {
        if (second_channel)
            memcpy((void*)maika->bigmac_ctrl.external_key_ch1, (void*)work_key, 8 + ((cmd & 0x300) >> 5));
        else
            memcpy((void*)maika->bigmac_ctrl.external_key_ch0, (void*)work_key, 8 + ((cmd & 0x300) >> 5));
    } else
        maika->bigmac_ctrl.channel[second_channel].work_ks = work_key;
    
    if (iv)
        maika->bigmac_ctrl.channel[second_channel].iv = iv;
    
    maika->bigmac_ctrl.channel[second_channel].func = cmd;

    maika->bigmac_ctrl.unk_status = unk_status;

    maika->bigmac_ctrl.channel[second_channel].trigger = 1;

    while ((maika->bigmac_ctrl.channel[second_channel].res) & 1) {};
    
    return (int)maika->bigmac_ctrl.channel[second_channel].res;
}

void crypto_waitStopBigmacOps(bool disable_future_ops) {
    register volatile uint32_t psw asm("$psw");
    if (psw & 1)
        PANIC("PSW", psw);

    maika_s* maika = (maika_s*)MAIKA_OFFSET;

    // waitstop scheduled jobs for channel 0
    if (maika->bigmac_ctrl.channel[0].res & 1) {
        maika->bigmac_ctrl.channel[0].trigger = 0;
        while (maika->bigmac_ctrl.channel[0].res & 1) {};
    }

    // waitstop scheduled jobs for channel 1
    if (maika->bigmac_ctrl.channel[1].res & 1) {
        maika->bigmac_ctrl.channel[1].trigger = 0;
        while (maika->bigmac_ctrl.channel[1].res & 1) {};
    }

    // disable requests for channels 0/1
    if (disable_future_ops) {
        maika->bigmac_ctrl.channel[0].unk_lock = 3;
        maika->bigmac_ctrl.channel[1].unk_lock = 3;
    }
}

uint32_t crypto_memset(bool second_channel, uint32_t addr, uint32_t len, uint32_t fill_value32) {
    maika_s* maika = (maika_s*)MAIKA_OFFSET;
    maika->bigmac_ctrl.channel[second_channel].fill_v32 = fill_value32;
    uint32_t ret = crypto_bigmacDefaultCmd(second_channel, 0, addr, len, CRYPTO_BIGMAC_FUNC_MEMSET, 0, 0, 0);
    maika->bigmac_ctrl.unk_status = 0;
    return ret;
}