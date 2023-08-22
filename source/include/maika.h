#ifndef __MAIKA_H__
#define __MAIKA_H__

#include "types.h"

#define reg volatile uint32_t

#define MAIKA_DEVICE_SIZE 0x00010000 // size per-device
#define MAIKA_KEYSLOT_COUNT 0x400
#define MAIKA_KEYSLOT_SIZE 0x20

/*
    Mapping
*/
// maika::mailbox
struct _maika_mailbox {
    reg cry2arm[4];
    reg arm2cry[4];
    reg cry2sc[2]; // via overlord
    reg sc2cry[2]; // via overlord
    reg unk[4];
    reg cry2arm_inv[4];
    reg arm2cry_inv[4];
    reg cry2sc_inv[2];
    reg sc2cry_inv[2];
    reg unk_inv[4]; // guessed
    reg incoming_state_80; // overlord writing sc2cry changes this
};
typedef struct _maika_mailbox maika_mailbox;

// maika::reset_ctrl
struct _maika_reset_ctrl {
    reg f00d_reset; // f00d reset
    reg crySboot; // f00d POR status?
    reg f00d_cycle_reset; // useful for self reset
    reg math_reset; // bigmac & bignum reset
    reg other_reset; // other subsystems reset
};
typedef struct _maika_reset_ctrl maika_reset_ctrl;

// maika::aio
struct _maika_aio {
    reg control_0;
    reg control_4; // writable only once
    reg control_8;
    reg unk_C[5];
    reg math_status;
    reg unk_24[7];
    struct {
        reg addr; // addr to r/w
        reg data; // data io
        reg mode; // op bits
    } readAs;
    reg unk_4C[0xB4 / 4];
    union {
        reg unk_100[16]; // x602, x601
        struct {
            reg unk_id_input[4]; // [0] = ??, [1] & [2] = serial64, [3] = config32?
            reg unk_10[4]; // IV?
            reg unk_20[8]; // key?
        } config_keys;
    };
};
typedef struct _maika_aio maika_aio;

// maika::keyring_ctrl
struct _maika_keyring_ctrl {
    reg data[MAIKA_KEYSLOT_SIZE / 4]; // data to write to the keyslot
    reg keyslot; // keyslot to write the data to
    reg set_prot; // ((prot << 16) | keyslot)
    reg get_prot; // write keyslot to get prot in next
    reg resp;
};
typedef struct _maika_keyring_ctrl maika_keyring_ctrl;

// maika::bigmac_ctrl
struct _maika_bigmac_ctrl { // size of bigmac ctrl is 0x400
    struct { // size of a bigmac channel is 0x80
        reg src;
        reg dst;
        reg sz;
        reg func;
        reg work_ks;
        reg iv;
        reg next;
        reg trigger;
        reg status;
        reg res;
        reg unk_lock;
        reg unk_2C;
        reg unk_30;
        reg fill_v32; // memset fill value (32bit)
        reg unk_38;
        reg rng;
        reg unk[0x10];
    } channel[2];
    reg unk_100; // RW
    reg unk_status; // RW
    reg unk_status2; // RO?
    reg unk_10C[3];
    reg oob_paddr; // RO
    reg oob_status; // RW
    reg unk_120[0xE0 / 4];
    reg external_key_ch0[8];
    reg unk_220[0x60 / 4];
    reg external_key_ch1[8];
    reg unk_2A0[0x160 / 4];
};
typedef struct _maika_bigmac_ctrl maika_bigmac_ctrl;

// maika::emmc_crypto_ctrl
struct _maika_emmc_crypto_ctrl {
    reg control_0;
    reg status;
    reg keyslots;
    reg control_C;
    reg unk_10;
    reg unk_14;
};
typedef struct _maika_emmc_crypto_ctrl maika_emmc_crypto_ctrl;

// maika::sxbar
struct _maika_sxbar_ctrl {
    struct { // size of a xbar device entry is 0x400
        reg unk_0[8];
        reg bus_access_control;
        reg unk_24;
        reg unk_status_28;
        reg unk_2C[(0x400 - 0x2C) / 4];
    } sxbar_entry[0x31]; // actually there are 17 confirmed devices
};
typedef struct _maika_sxbar_ctrl maika_sxbar_ctrl;

// maika
struct _maika_s {
    // e000
    maika_mailbox mailbox;
    reg mailbox_unused[(MAIKA_DEVICE_SIZE - sizeof(maika_mailbox)) / 4];

    // e001
    maika_reset_ctrl reset_ctrl;
    reg reset_ctrl_unused[(MAIKA_DEVICE_SIZE - sizeof(maika_reset_ctrl)) / 4];

    // e002
    maika_aio aio;
    reg aio_unused[(MAIKA_DEVICE_SIZE - sizeof(maika_aio)) / 4];

    // e003
    maika_keyring_ctrl keyring_ctrl;
    reg keyring_ctrl_unused[(MAIKA_DEVICE_SIZE - sizeof(maika_keyring_ctrl)) / 4];

    // e004 : TODO
    reg bignum_mailbox_unk[MAIKA_DEVICE_SIZE / 4];

    // e005 : DMAC4 interface?
    maika_bigmac_ctrl bigmac_ctrl;
    reg bigmac_ctrl_unused[(MAIKA_DEVICE_SIZE - sizeof(maika_bigmac_ctrl)) / 4];

    // e006
    reg keyring[MAIKA_KEYSLOT_COUNT][MAIKA_KEYSLOT_SIZE / 4];
    reg keyring_unused[(MAIKA_DEVICE_SIZE - (MAIKA_KEYSLOT_COUNT * MAIKA_KEYSLOT_SIZE)) / 4];

    // e007
    maika_emmc_crypto_ctrl emmc_crypto_ctrl;
    reg emmc_crypto_ctrl_unused[(MAIKA_DEVICE_SIZE - sizeof(maika_emmc_crypto_ctrl)) / 4];

    // e008 : TODO
    reg e008_unk[MAIKA_DEVICE_SIZE / 4];

    // unused
    reg unused_9[3][MAIKA_DEVICE_SIZE / 4];

    // e00c
    maika_sxbar_ctrl sxbar_ctrl;
    reg sxbar_ctrl_unused[(MAIKA_DEVICE_SIZE - sizeof(maika_sxbar_ctrl)) / 4];

    // unused
    reg unused_d[3][MAIKA_DEVICE_SIZE / 4];
};
typedef struct _maika_s maika_s;

/*
    Defines
*/
#define MAIKA_AIO_CONTROL0_ARM2CRY0 0b1
#define MAIKA_AIO_CONTROL0_ARM2CRY1 0b10
#define MAIKA_AIO_CONTROL0_ARM2CRY2 0b100
#define MAIKA_AIO_CONTROL0_ARM2CRY3 0b1000
#define MAIKA_AIO_CONTROL0_SC2CRY01 0b10000
#define MAIKA_AIO_CONTROL0_0b100000 0b100000
#define MAIKA_AIO_CONTROL0_EXTRST_W 0b1 << 12
#define MAIKA_AIO_CONTROL0_EXTRST_R 0b10 << 12

#define MAIKA_AIO_CONTROL0_EXTRESET_MASK(arm_read, arm_write) (arm_read * (MAIKA_AIO_CONTROL0_EXTRST_R) | arm_write * (MAIKA_AIO_CONTROL0_EXTRST_W))
#define MAIKA_AIO_CONTROL0_ARM2CRY_MASK(arm2cry0, arm2cry1, arm2cry2, arm2cry3) (arm2cry0 * MAIKA_AIO_CONTROL0_ARM2CRY0 | arm2cry1 * MAIKA_AIO_CONTROL0_ARM2CRY1 | arm2cry2 * MAIKA_AIO_CONTROL0_ARM2CRY2 | arm2cry3 * MAIKA_AIO_CONTROL0_ARM2CRY3)

#define MAIKA_RAS_DEV_S 0 // default secure
#define MAIKA_RAS_MODE_WRITE 0b1 // write mode
#define MAIKA_RAS_DEV_UNK 0b10 // masks DRAM and DRAM regs, from arm bus
#define MAIKA_RAS_DEV_NS 0b100 // non-secure, probably arm TZ

#define MAIKA_RAS_B0 0b1000 // r/w byte0
#define MAIKA_RAS_B1 0b10000 // r/w byte1 or RAS_NOALIGN in incompatible read offsets
#define MAIKA_RAS_B2 0b100000 // r/w byte2
#define MAIKA_RAS_B3 0b1000000 // r/w byte3
#define MAIKA_RAS_32 (MAIKA_RAS_B0 | MAIKA_RAS_B1 | MAIKA_RAS_B2 | MAIKA_RAS_B3) // r/w all 4 bytes

/*
    Funcs
*/
// read data from [addr] with/as [mode]
uint32_t readAs(uint32_t addr, uint32_t mode);

// write [data] to [addr] with/as [mode]
void writeAs(uint32_t addr, uint32_t data, uint32_t mode);

uint32_t keyring_slot_data(bool set, void* data, int datasize, uint32_t keyslot);
uint32_t keyring_slot_prot(bool set, uint32_t prot, uint32_t keyslot);

#undef reg

#endif