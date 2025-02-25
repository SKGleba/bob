#include "include/compat.h"

#include <hardware/paddr.h>
#include <hardware/xbar.h>
#include <hardware/regbus.h>

#include "include/alice.h"
#include "include/clib.h"
#include "include/crypto.h"
#include "include/debug.h"
#include "include/defs.h"
#include "include/ex.h"
#include "include/maika.h"
#include "include/perv.h"
#include "include/sm.h"
#include "include/types.h"
#include "include/utils.h"

#ifndef COMPAT_UNUSE

// bring your own keys
static const uint8_t skso_iv[16] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

static int compat_state = 0;

uint32_t compat_Cry2Arm0(uint32_t msg) {
    maika_s* maika = (maika_s*)MAIKA_OFFSET;
    if (msg & 0xFFFF) {
        maika->mailbox.cry2arm[0] = msg & 0xFFFF;
        _MEP_SYNC_BUS_
        while (maika->mailbox.cry2arm[0] & 0xFFFF) {};
    }
    return maika->mailbox.cry2arm[0];
}

static void compat_IRQ7_resetPervDevice(void) {
    pervasive_control_reset(PERV_CTRL_RESET_DEV_EMMC_CRYPTO, 1, true, false);
    pervasive_control_reset(PERV_CTRL_RESET_DEV_EMMC_CRYPTO, 1, false, true);
}

static void compat_IRQ7_setEmmcKeyslots(bool disableEmmcCtrl) {
    maika_s* maika = (maika_s*)MAIKA_OFFSET;
    maika->keyring_ctrl.set_prot = 0x1FEF020F;
    maika->keyring_ctrl.set_prot = 0x1FEF020E;
    maika->emmc_crypto_ctrl.keyslots = 0x020E020F;
    if (disableEmmcCtrl)
        maika->emmc_crypto_ctrl.control_0 = 0;
    else
        maika->emmc_crypto_ctrl.control_0 = 1;
}

static void compat_IRQ7_setSomeEmmcDatax14(void) {
    uint32_t somePervasiveValue = vp(PERV_GET_REG(PERV_CTRL_MISC, PERV_CTRL_MISC_REG_SOC_REV)) & 0x00FFFFFF;
    if (somePervasiveValue == 0x20 || somePervasiveValue == 0x30 || somePervasiveValue == 0x32)
        return;
    ((maika_s*)(MAIKA_OFFSET))->emmc_crypto_ctrl.unk_14 = 6;
}

// TODO: fix?
static void compat_IRQ7_genSKSO(void) {
    maika_s* maika = (maika_s*)MAIKA_OFFSET;
    cmdF01_SKSO skso;
    skso.magic = 0xacb4acb1;
    skso.unk_one = 1;
    skso.random = maika->bigmac_ctrl.channel[0].rng;
    skso.zero_or_padding = 0;
    keyring_slot_data(false, skso.data_0x511, 0x20, 0x511);
    keyring_slot_data(false, skso.data_0x512, 0x20, 0x512);
    keyring_slot_data(false, skso.data_0x517, 0x20, 0x517);
    keyring_slot_data(false, skso.data_0x519, 0x20, 0x519);
    uint8_t key[0x20];
    memset(key, 0, 0x20);
    keyring_slot_data(false, key, 0x20, 0x514);
    memcpy((void *)maika->bigmac_ctrl.external_key_ch0, key, 0x20);
    if (!crypto_bigmacDefaultCmd(0, (uint32_t)&skso, (uint32_t)skso.cmac_hash, 0x90, ((0x2080 & 0xfffffff8) | 0x33b) & 0xfffff3ff, 0, 0, 0)) {
        keyring_slot_data(false, key, 0x20, 0x515);
        memcpy((void*)maika->bigmac_ctrl.external_key_ch0, key, 0x20);
        if (!crypto_bigmacDefaultCmd(0, (uint32_t)&skso, (uint32_t)&skso, 0xA0, 0x2189, 0, (uint32_t)skso_iv, 0)) {
            memcpy((void*)0x4001ff00, &skso, 0xA0);
            memset(key, 0, 0x20);
            key[0] = 1;
            keyring_slot_data(true, key, 0x20, 0x516);
        }
    }
}

__attribute__((noreturn))
static void compat_IRQ7_armPanic(void) {
    compat_state = 9;
    cbus_write(0, 0xF);
    asm("mov $0, $0\n");
    _MEP_SYNC_BUS_
    asm("mov $0, $0\n");
    PANIC("ARM", 0);
}

__attribute__((noreturn))
static void compat_IRQ7_forceExitSm(void) {
    maika_s* maika = (maika_s*)MAIKA_OFFSET;
    crypto_waitStopBigmacOps(true);
    crypto_memset(false, SM_LOAD_ADDR, SM_MAX_SIZE, 0);
    maika->mailbox.arm2cry[1] = -1;
    maika->mailbox.arm2cry[2] = -1;
    maika->mailbox.arm2cry[3] = -1;
    maika->mailbox.cry2arm_inv[1] = -1;
    maika->mailbox.cry2arm_inv[2] = -1;
    maika->mailbox.cry2arm_inv[3] = -1;
    compat_state = 7;
    compat_Cry2Arm0(0x104);
    register volatile uint32_t psw asm("psw");
    psw = psw & -3;
    asm("jmp vectors_exceptions\n");
    PANIC("NOEXIT", 0);
}

void compat_IRQ7_handleCmd(uint32_t cmd, uint32_t arg1, uint32_t arg2, uint32_t arg3) {
    if (compat_state < 0) {
        compat_state = alice_handleCmd(cmd, arg1, arg2, arg3);
        return;
    }
    
    statusled(STATUS_COMPAT_HANDLE);
    bool shortcmd = true;
    maika_s* maika = (maika_s*)MAIKA_OFFSET;

    printf("[BOB] got ARM cmd %X\n", cmd);

    switch (cmd) {
    case ALICE_ACQUIRE_CMD:
        if (arg3 == cmd) {
            compat_state = -1;
            printf("[BOB] compat service terminated\n");
            maika->mailbox.arm2cry[3] = -1;
            maika->mailbox.arm2cry[2] = -1;
            maika->mailbox.arm2cry[1] = -1;
        } else
            printf("[BOB] invalid arg for alice acquire: %X %X %X\n", arg1, arg2, arg3);
            break;
    case 0xC01:
    case 0xD01:
        if (!(maika->keyring[0x10C][0] & 4))
            break;
    case 0xB01:
    case 0xE01:
        statusled(STATUS_COMPAT_RESET_PERV);
        compat_IRQ7_resetPervDevice();
        compat_IRQ7_setEmmcKeyslots(cmd != 0xC01);
        if (cmd != 0xE01)
            break;
        compat_IRQ7_setSomeEmmcDatax14();
        break;
    case 0xF01:
        statusled(STATUS_COMPAT_SKSO);
        compat_IRQ7_genSKSO();
        break;
    case 0x101:
    case 0x601:
        shortcmd = false;
        break;
    default:
        break;
    }

    if (shortcmd)
        return;

    maika->mailbox.arm2cry[0] = -1;

    uint32_t ret = 0x802d;
    if (!compat_Cry2Arm0(false)) {
        ret = 0x8029;
        switch (cmd) {
        default:
        case 0x101:
            statusled(STATUS_COMPAT_ARMDED);
            compat_IRQ7_armPanic();
            break;
        case 0x601:
            statusled(STATUS_COMPAT_FEXSM);
            compat_IRQ7_forceExitSm();
            break;
        }
    }

    statusled(STATUS_COMPAT_CRY2ARM0);
    compat_Cry2Arm0(ret);
}

void compat_pListCopy(void* io, compat_paddr_list* paddr_list, uint32_t list_entries_count, bool copy_to_list) {
    while (list_entries_count) {
        if (copy_to_list)
            memcpy((void *)paddr_list->paddr, io, paddr_list->size);
        else
            memcpy(io, (void *)paddr_list->paddr, paddr_list->size);
        io-=-paddr_list->size;
        paddr_list++;
        list_entries_count--;
    }
}

void compat_armReBoot(int armClk, bool hasCS, bool remap_00) {
    // put ARM & CS in reset
    pervasive_control_reset(PERV_CTRL_RESET_DEV_ARM, 0x1000f, true, true);
    if (hasCS)
        pervasive_control_reset(PERV_CTRL_RESET_DEV_ARM_CS, 1, true, true);

    // disable ARM & CS clocks
    pervasive_control_gate(PERV_CTRL_GATE_DEV_ARM, 0xFFFFFFFF, false, true);
    if (hasCS)
        pervasive_control_gate(PERV_CTRL_GATE_DEV_ARM_CS, 0xFFFFFFFF, false, true);

    // WTF1
    uint32_t dev_96_clk = vp PERV_GET_REG(PERV_CTRL_GATE, 96);
    pervasive_control_gate(96, dev_96_clk & 0xffffff7f, true, true);
    pervasive_control_reset(97, 0xFFFFFFFF, false, true);
    pervasive_control_gate(96, dev_96_clk | 0x80, true, true);

    // set arm to 42mhz
    pervasive_control_clock(0, 1, true);

    // ??
    pervasive_control_misc(0xC, 0, true);
    pervasive_control_misc(0x14, 1, true);

    // WTF2
    while (vp PERV_GET_REG(PERV_CTRL_MISC, 0x30) != 1) {};
    vp PERV_GET_REG(PERV_CTRL_MISC, 0x30) = 1;
    while (vp PERV_GET_REG(PERV_CTRL_MISC, 0x30) == 1) {};

    // open & close ARM debug mode gate for some reason
    pervasive_control_gate(PERV_CTRL_GATE_DEV_ARM, 0xc00000, true, true);
    pervasive_control_gate(PERV_CTRL_GATE_DEV_ARM, 0xFFFFFFFF, false, true);

    // set arm to caller-defined freq (default 7 : 333mhz)
    pervasive_control_clock(0, armClk & 0xf, true);

    // remap arm 0x0 to 0x40000000
    vp PERV2_ARM_BOOT_ALIAS_DRAM = remap_00 & 1;
    while (vp PERV2_ARM_BOOT_ALIAS_DRAM != (remap_00 & 1))
        ;

    // open arm (&opt) gate
    pervasive_control_gate(PERV_CTRL_GATE_DEV_ARM, hasCS ? 0xc10000 : 0x10000, true, true);

    // spin up CS
    if (hasCS) {
        pervasive_control_gate(PERV_CTRL_GATE_DEV_ARM_CS, 1, true, true);
        pervasive_control_reset(PERV_CTRL_RESET_DEV_ARM_CS, 0xFFFFFFFF, false, true);
    }

    // put arm out of reset
    pervasive_control_reset(PERV_CTRL_RESET_DEV_ARM, 0xFFFFFFFF, false, true);
}

void compat_killArm(bool prehang) {
    if (prehang) {  // make ARM hang on bus transfers
        vp XBAR_CONFIG_REG(MAIN_XBAR, XBAR_CFG_FAMILY_ACCESS_CONTROL, XBAR_TA_MXB_DEV_SPAD32K, XBAR_ACCESS_CONTROL_WHITELIST) &= ~0b11;
        vp XBAR_CONFIG_REG(MAIN_XBAR, XBAR_CFG_FAMILY_ACCESS_CONTROL, XBAR_TA_MXB_DEV_LPDDR0, XBAR_ACCESS_CONTROL_WHITELIST) &= ~0b11;
        delay_nx(0x800, 200);  // increase delay if it hangs here
    }

    // stop ARM & CS
    pervasive_control_reset(PERV_CTRL_RESET_DEV_ARM, 0x1000f, true, true);
    pervasive_control_reset(PERV_CTRL_RESET_DEV_ARM_CS, 1, true, true);
    pervasive_control_gate(PERV_CTRL_GATE_DEV_ARM, 0xFFFFFFFF, false, true);
    pervasive_control_gate(PERV_CTRL_GATE_DEV_ARM_CS, 0xFFFFFFFF, false, true);

    delay_nx(0x800, 200);

    if (prehang) {  // restore ARM access
        vp XBAR_CONFIG_REG(MAIN_XBAR, XBAR_CFG_FAMILY_ACCESS_CONTROL, XBAR_TA_MXB_DEV_LPDDR0, XBAR_ACCESS_CONTROL_WHITELIST) |= 0b11;
        vp XBAR_CONFIG_REG(MAIN_XBAR, XBAR_CFG_FAMILY_ACCESS_CONTROL, XBAR_TA_MXB_DEV_SPAD32K, XBAR_ACCESS_CONTROL_WHITELIST) |= 0b11;
        // TODO: fix storm?
    }
}

void compat_pspemuColdInit(bool dram, bool regbus) {
    int ret;
    if (dram) {
        pervasive_control_clock(49, 0, false);
        pervasive_control_misc(190, 0x1, false);
        pervasive_control_reset(PERV_CTRL_RESET_DEV_COMPAT_RAM, 0b1, true, false);
        pervasive_control_gate(PERV_CTRL_GATE_DEV_COMPAT_RAM, 0b1, true, false);
        { // ??
            pervasive_control_misc(15, 0x0, false);
            vp 0xE310005c = 0x1;
            do {
                ret = (int)vp(0xE310005c);
            } while ((ret << 0x1f) < 0);
            do {
                ret = (int)vp(0xE31000c0);
            } while (-1 < (ret << 0x1c));
            vp 0xE31000c0 = 0x8;
            do {
                ret = (int)vp(0xE31000c0);
            } while ((ret & 0x8) != 0);
        }
        pervasive_control_gate(PERV_CTRL_GATE_DEV_COMPAT_RAM, 0b1, false, false);
        pervasive_control_reset(PERV_CTRL_RESET_DEV_COMPAT_RAM, 0b1, false, false);
        pervasive_control_misc(190, 0x0, false);
        pervasive_control_gate(PERV_CTRL_GATE_DEV_COMPAT_RAM, 0b1, true, false);
    }
    if (regbus) {
        { // ??2
            pervasive_control_misc(16, 0x0, false);
            vp 0xE3100060 = 0x1;
            do {
                ret = (int)vp(0xE3100060);
            } while ((ret << 0x1f) < 0);
            do {
                ret = (int)vp(0xE31000c0);
            } while (-1 < (ret << 0x1b));
            vp 0xE31000c0 = 0x10;
            do {
                ret = (int)vp(0xE31000c0);
            } while ((ret & 0x10) != 0);
        }
        pervasive_control_clock(56, 0, false);
        pervasive_control_gate(9, 0b1, true, false);
        pervasive_control_reset(9, 0b1, false, false);
    }
}

int compat_handleAllegrex(int cmd, int arg1, int arg2) {
    int ret = -1;
    switch (cmd & 0xFF) {
    case AGX_CMD_RESET:
        ret = (cmd & AGX_CMD_QUERY) ? vp PERV_GET_REG(PERV_CTRL_RESET, PERV_CTRL_RESET_DEV_ALLEGREX)
            : pervasive_control_reset(PERV_CTRL_RESET_DEV_ALLEGREX, arg2, arg1 & 1, !!(arg1 & 2));
        break;
    case AGX_CMD_GATE:
        ret = (cmd & AGX_CMD_QUERY) ? vp PERV_GET_REG(PERV_CTRL_GATE, PERV_CTRL_GATE_DEV_ALLEGREX)
            : pervasive_control_gate(PERV_CTRL_GATE_DEV_ALLEGREX, arg2, arg1 & 1, !!(arg1 & 2));
        break;
    case AGX_CMD_CLOCK:
        ret = (cmd & AGX_CMD_QUERY) ? vp PERV_GET_REG(PERV_CTRL_BASECLK, 40)
            : pervasive_control_clock(40, arg1, !!(arg2));
        break;
    case AGX_CMD_ACL:
        if (!(cmd & AGX_CMD_QUERY))
            vp REGBUS_REG(REGBUS_AGX_SRAM_ACL) = arg1;
        ret = vp REGBUS_REG(REGBUS_AGX_SRAM_ACL);
        break;
    }
    return ret;
}

#endif
