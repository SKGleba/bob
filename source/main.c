#include "include/types.h"

#include "include/defs.h"
#include "include/uart.h"
#include "include/maika.h"
#include "include/debug.h"
#include "include/ex.h"
#include "include/crypto.h"
#include "include/syscon.h"
#include "include/xbar.h"
#include "include/utils.h"
#include "include/clib.h"

#include "include/main.h"

static bob_config options;

// dev ?? 0xE00CA020
// dev ?? 0xE00CC078
static void test(void) {

    set_dbg_mode(true);

    printf("ks %X | %X\n", keyring_slot_prot(false, 0, 0x20E), keyring_slot_prot(false, 0, 0x20F));

    for (uint32_t off = 0xE3101000; off < 0xE3102000; off -= -4) {
        if (off == 0xE31013F4)
            off -= -0x4;
        if (off == 0xE31013FC)
            off -= -0x4;
        if (off == 0xE3101120)
            off = 0xE310113C;
        //printx(off);
        vp off = 0xFFFFFFFF;
    }

    printf("ks %X | %X\n", keyring_slot_prot(false, 0, 0x20E), keyring_slot_prot(false, 0, 0x20F));

    for (uint32_t off = 0xE3101000; off < 0xE3102000; off -= -4) {
        if (off == 0xE31013F4)
            off -= -0x4;
        if (off == 0xE31013FC)
            off -= -0x4;
        if (off == 0xE3101120)
            off = 0xE310113C;
        //printx(off);
        vp off = 0;
    }

    printf("ks %X | %X\n", keyring_slot_prot(false, 0, 0x20E), keyring_slot_prot(false, 0, 0x20F));

    for (uint32_t off = 0xE3100000; off < 0xE3101000; off -= -4) {
        if (off == 0xE3100018)
            off -= -0x10;
        //printx(off);
        vp off = 0xFFFFFFFF;
    }

    printf("ks %X | %X\n", keyring_slot_prot(false, 0, 0x20E), keyring_slot_prot(false, 0, 0x20F));
    
    printp(0);
    printx(readAs(0, RAS_32 | RAS_DEV_S));
    //printx(readAs(0, RAS_32 | RAS_DEV_NS));
    printx(readAs(0, RAS_32 | RAS_DEV_UNK));

    printp(0x00040000);
    printx(readAs(0x00040000, RAS_32 | RAS_DEV_S));
    //printx(readAs(0x00040000, RAS_32 | RAS_DEV_NS));
    printx(readAs(0x00040000, RAS_32 | RAS_DEV_UNK));

    printf("slot 0x206:\n- prot: %X\ndata:\n", keyring_slot_prot(0, 0, 0x206));
    hexdump(KEYRING_SLOT(0x206), 0x10, 1);

    printf("slot 0x509:\n- prot: %X\ndata:\n", keyring_slot_prot(0, 0, 0x509));
    hexdump(KEYRING_SLOT(0x509), 0x10, 1);

    crypto_memset(false, 0x0080b000, 0x80, 0xAAAAAAAA);
    hexdump(0x0080b000, 0x20, 1);

    printx(readAs(0x00040000, RAS_32 | 0xFFFFFF00));
    printp(READAS_REG + 0x8);

    set_dbg_mode(false);
}

bool ce_framework(bool bg) {
    if (options.ce_framework_parms[bg]) {
        if ((options.ce_framework_parms[bg]->magic == 0x14FF) && (options.ce_framework_parms[bg]->status == 0x34)) {
            options.ce_framework_parms[bg]->status = 0x69;
            
            uint32_t(*ccode)(uint32_t arg, volatile uint8_t * status_addr) = (void*)(options.ce_framework_parms[bg]->codepaddr);
            
            bool icache_stat = enable_icache(false);
            options.ce_framework_parms[bg]->resp = ccode(options.ce_framework_parms[bg]->arg, &options.ce_framework_parms[bg]->status);
            enable_icache(icache_stat);
            
            options.ce_framework_parms[bg]->status = options.ce_framework_parms[bg]->exp_status;
            return true;
        }
    } else if (bg)
        _MEP_SLEEP_

    return false;
}

void init(bob_config* arg_config) {

    _MEP_INTR_DISABLE_ // disable interrupts

    // foreground framework (only runs from arm request)
    options.ce_framework_parms[0] = arg_config->ce_framework_parms[0];
    if (options.ce_framework_parms[0]) {
        options.ce_framework_parms[0]->resp = 0;
        options.ce_framework_parms[0]->status = options.ce_framework_parms[0]->exp_status;
        *(uint32_t*)0xE0000010 = 0xFFFFFFFF;
    }

    // background framework (runs when idle)
    options.ce_framework_parms[1] = arg_config->ce_framework_parms[1];
    if (options.ce_framework_parms[1]) {
        options.ce_framework_parms[1]->resp = 0;
        options.ce_framework_parms[1]->status = options.ce_framework_parms[1]->exp_status;
    }

    uart_init(UART_TX_BUS);
    
    printf("[BOB] init bob [%X], me @ %X\n", get_build_timestamp(), init);

    test();

    // enable and clean icache
    enable_icache(true);
    memset((void*)0x00300000, 0, 0x00010000);

    // jump to reset (dynamic)
    asm("jmp vectors_exceptions\n");
}