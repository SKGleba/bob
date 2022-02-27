#ifndef __MAIKA_H__
#define __MAIKA_H__

#include "types.h"

#define READAS_REG 0xE0020040 // readas32 device

#define RAS_DEV_S 0 // default secure
#define RAS_MODE_WRITE 0b1 // write mode
#define RAS_DEV_UNK 0b10 // masks DRAM and DRAM regs, from arm bus
#define RAS_DEV_NS 0b100 // non-secure, probably arm TZ

#define RAS_B0 0b1000 // r/w byte0
#define RAS_B1 0b10000 // r/w byte1 or RAS_NOALIGN in incompatible read offsets
#define RAS_B2 0b100000 // r/w byte2
#define RAS_B3 0b1000000 // r/w byte3
#define RAS_32 (RAS_B0 | RAS_B1 | RAS_B2 | RAS_B3) // r/w all 4 bytes

typedef struct readas32_t {
    volatile uint32_t addr; // addr to r/w
    volatile uint32_t data; // data io
    volatile uint32_t mode; // op bits
} readas32_t;

// read data from [addr] with/as [mode]
uint32_t readAs(uint32_t addr, uint32_t mode);

// write [data] to [addr] with/as [mode]
void writeAs(uint32_t addr, uint32_t data, uint32_t mode);

#define MAIKA_ACR 0xE0020000
#define MAIKA_DEV_RESET_REG 0xE0010010

#define KEYRING_BASE 0xE0058000
#define KEYRING_SLOT(slot) (KEYRING_BASE + (slot * 0x20))

#define KEYRING_CONTROLLER 0xE0030000

typedef struct keyring_ctrl_t {
    uint32_t data[8]; // data to write to the keyslot
    uint32_t keyslot; // keyslot to write the data to
    union {
        uint16_t set_prot_prot;
        uint16_t set_prot_keyslot;
        uint32_t set_prot; // ((prot << 16) | keyslot)
    };
    uint32_t get_prot; // write keyslot to get prot in next
    uint32_t resp;
} keyring_ctrl_t;

uint32_t keyring_slot_data(int set, void* data, int datasize, uint32_t keyslot);
uint32_t keyring_slot_prot(int set, uint32_t prot, uint32_t keyslot);

#endif