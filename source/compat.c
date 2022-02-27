#include "include/types.h"
#include "include/defs.h"
#include "include/utils.h"
#include "include/debug.h"
#include "include/ex.h"
#include "include/crypto.h"
#include "include/sm.h"

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
static void compat_forceExitSm(void) {
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
            compat_forceExitSm();
            break;
        }
    }

    compat_Cry2Arm0(ret);
}