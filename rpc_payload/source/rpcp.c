#include "../../source/include/types.h"

#include "../../source/include/defs.h"
#include "../../source/include/uart.h"
#include "../../source/include/debug.h"
#include "../../source/include/utils.h"
#include "../../source/include/clib.h"
#include "../../source/include/maika.h"
#include "../../source/include/crypto.h"
#include "../../source/include/spi.h"
#include "../../source/include/perv.h"
#include "../../source/include/gpio.h"
#include "../../source/include/i2c.h"
#include "../../source/include/paddr.h"
#include "../../source/include/ernie.h"

#include "include/brom1k.h"

#define TEST_COUNT 1

void prepare_sd_regs(void) {
    vp 0xe31020a4 = 1;
    while (!(vp 0xe31020a4)) {};
    vp 0xe31010a4 = 0;
    while ((vp 0xe31010a4)) {};
}

int prepare_sd(uint32_t* ctx) {
    memset(0x0005eaa8, 0, 0x1548);
    ctx[0] = 0;
    ctx[1] = 0;
    int ret = brom_init_storages(1, (((vp 0xE0064060) >> 0x11) & 1) == 0);
    if (ret >= 0)
        ret = brom_init_sd(1, ctx);
    return ret;
}

int try_timed_xg(uint32_t ctx) {
    maika_s* maika = (maika_s*)MAIKA_OFFSET;

    memset(0x4c000, 0, 0x400);
    crypto_bigmacDefaultCmd(true, 0x4c200, 0x4c300, 0x20, CRYPTO_BIGMAC_FUNC_FLAG_KEYSIZE_256 | CRYPTO_BIGMAC_FUNC_AES_CBC_ENC, 0x213, 0x4c220, 0);

    memset(0x4c220, 0, 0x20);
    maika->bigmac_ctrl.channel[true].dst = 0x4c320;
    
    brom_read_sector_sd(ctx, 0x40, 0x4c000, 1);

    maika->bigmac_ctrl.channel[true].trigger = 1;
    
    brom_read_sector_sd(ctx, 0x40, 0x4c000, 1);
    
    while ((maika->bigmac_ctrl.channel[true].res) & 1) {};
    if (memcmp(0x4c300, 0x4c320, 0x20)) {
        print("\nFAILED\n");
        while (1) {};
    } else
        print("\nOK\n");
}

__attribute__((section(".text.rpcp")))
int rpcp(uint32_t arg0, uint32_t arg1, void* extra_data) {
    printf("\n[RPCP] hello world (%X, %X, %X)\n", arg0, arg1, (uint32_t)extra_data);

    int ret = 0;
    int testno = 0;
    int test_count = TEST_COUNT;
    //if (arg1)
        //test_count = arg1;
do_tests:
    testno++;
    printf("[RPCP] test number %X\n", testno);

    {
        uint32_t ctx[2];
        ret = prepare_sd(ctx);
        if (ret < 0) {
            printf("[RPCP] read_sd: prepare sd failed: %X\n", ret);
            return ret;
        }
        
        try_timed_xg(ctx[0]);
    }

    if (testno < test_count)
        goto do_tests;

    print("[RPCP] byee\n\n");
    return ret;
}