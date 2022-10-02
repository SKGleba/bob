#include "include/types.h"
#include "include/defs.h"
#include "include/utils.h"
#include "include/debug.h"
#include "include/ex.h"
#include "include/crypto.h"
#include "include/clib.h"
#include "include/sm.h"
#include "include/maika.h"
#include "include/compat.h"

static const uint8_t skso_iv[16] = {
    0xa1, 0x32, 0x5a, 0xd8, 0xb9, 0x21, 0x2f, 0xef,
    0x72, 0x16, 0xef, 0xfb, 0x30, 0xcb, 0x4d, 0xfc
};

static uint16_t compat_state[2];

int compat_f00dState(uint32_t state, bool set) {
    if (set)
        p compat_state = state;
    return p compat_state;
}

uint32_t compat_Cry2Arm0(uint32_t msg) {
    if (msg & 0xFFFF) {
        vp 0xE0000000 = msg & 0xFFFF;
        _MEP_SYNC_BUS_
        while (vp(0xE0000000) & 0xFFFF) {};
    }
    return vp 0xE0000000;
}

static void compat_IRQ7_resetPervDevice(void) {
    vp 0xE3101190 = 1;
    vp 0xE3101190 = 0;
    while (vp 0xE3101190) {};
}

static void compat_IRQ7_setEmmcKeyslots(bool resetEmmcCtrl) {
    vp 0xE0030024 = 0x1FEF020F;
    vp 0xE0030024 = 0x1FEF020E;
    vp 0xE0070008 = 0x020E020F;
    if (resetEmmcCtrl)
        vp 0xE0070000 = 1;
    vp 0xE0070000 = 0;
}

static void compat_IRQ7_setSomeEmmcDatax14(void) {
    uint32_t somePervasiveValue = vp(0xE3100000) & 0x00FFFFFF;
    if (somePervasiveValue == 0x20 || somePervasiveValue == 0x30 || somePervasiveValue == 0x32)
        return;
    vp 0xE0070014 = 6;
}

// TODO: fix?
static void compat_IRQ7_genSKSO(void) {
    cmdF01_SKSO skso;
    skso.magic = 0xacb4acb1;
    skso.unk_one = 1;
    skso.random = vp 0xE005003C;
    skso.zero_or_padding = 0;
    keyring_slot_data(false, skso.data_0x511, 0x20, 0x511);
    keyring_slot_data(false, skso.data_0x512, 0x20, 0x512);
    keyring_slot_data(false, skso.data_0x517, 0x20, 0x517);
    keyring_slot_data(false, skso.data_0x519, 0x20, 0x519);
    uint8_t key[0x20];
    memset(key, 0, 0x20);
    keyring_slot_data(false, key, 0x20, 0x514);
    memcpy(0xE0050200, key, 0x20);
    if (!crypto_bigmacDefaultCmd(0, &skso, skso.cmac_hash, 0x90, ((0x2080 & 0xfffffff8) | 0x33b) & 0xfffff3ff, 0, 0, 0)) {
        keyring_slot_data(false, key, 0x20, 0x515);
        memcpy(0xE0050200, key, 0x20);
        if (!crypto_bigmacDefaultCmd(0, &skso, &skso, 0xA0, 0x2189, 0, skso_iv, 0)) {
            memcpy((void*)0x4001ff00, &skso, 0xA0);
            memset(key, 0, 0x20);
            key[0] = 1;
            keyring_slot_data(true, key, 0x20, 0x516);
        }
    }
}

__attribute__((noreturn))
static void compat_IRQ7_armPanic(void) {
    compat_f00dState(9, true);
    cbus_write(0, 0xF);
    asm("mov $0, $0\n");
    _MEP_SYNC_BUS_
    asm("mov $0, $0\n");
    PANIC("ARM", 0);
}

__attribute__((noreturn))
static void compat_IRQ7_forceExitSm(void) {
    crypto_waitStopBigmacOps(true);
    crypto_memset(false, SM_LOAD_ADDR, SM_MAX_SIZE, 0);
    vp 0xE0000014 = 0xFFFFFFFF;
    vp 0xE0000018 = 0xFFFFFFFF;
    vp 0xE000001C = 0xFFFFFFFF;
    vp 0xE0000044 = 0xFFFFFFFF;
    vp 0xE0000048 = 0xFFFFFFFF;
    vp 0xE000004C = 0xFFFFFFFF;
    compat_f00dState(7, true);
    compat_Cry2Arm0(0x104);
    register volatile uint32_t psw asm("psw");
    psw = psw & -3;
    asm("jmp vectors_exceptions\n");
    PANIC("NOEXIT", 0);
}

void compat_IRQ7_handleCmd(void) {

    bool shortcmd = true;
    uint32_t cmd = vp 0xE0000010;

    printf("[BOB] got ARM cmd 0x%X\n", cmd);

    switch (cmd) {
    case 0xC01:
    case 0xD01:
        if (!(vp(0xE0062180) & 4))
            break;
    case 0xB01:
    case 0xE01:
        compat_IRQ7_resetPervDevice();
        compat_IRQ7_setEmmcKeyslots(cmd != 0xC01);
        if (cmd != 0xE01)
            break;
        compat_IRQ7_setSomeEmmcDatax14();
        break;
    case 0xF01:
        compat_IRQ7_genSKSO();
        break;
    case 0x101:
    case 0x601:
        shortcmd = false;
        break;
    default:
        break;
    }

    vp 0xE0000010 = 0xFFFFFFFF;

    if (shortcmd)
        return;

    uint32_t ret = 0x802d;
    if (!compat_Cry2Arm0(false)) {
        ret = 0x8029;
        switch (cmd) {
        default:
        case 0x101:
            compat_IRQ7_armPanic();
            break;
        case 0x601:
            compat_IRQ7_forceExitSm();
            break;
        }
    }

    compat_Cry2Arm0(ret);
}

void compat_pListCopy(void* io, compat_paddr_list* paddr_list, uint32_t list_entries_count, bool copy_to_list) {
    while (list_entries_count) {
        if (copy_to_list)
            memcpy(paddr_list->paddr, io, paddr_list->size);
        else
            memcpy(io, paddr_list->paddr, paddr_list->size);
        io-=-paddr_list->size;
        paddr_list++;
        list_entries_count--;
    }
}