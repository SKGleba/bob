#ifndef __COMPAT_H__
#define __COMPAT_H__

#include "types.h"
#include "defs.h"
#include "utils.h"

typedef struct compat_paddr_list {
    uint32_t paddr;
    uint32_t size;
} compat_paddr_list;

typedef struct cmdF01_SKSO {
    uint32_t magic; // Magic (0xACB4ACB1 = -0x534B534F -> "SKSO")
    uint32_t unk_one; // Always 1
    uint32_t random; // Pseudo random number (read from 0xE005003C)
    uint32_t zero_or_padding; // Always 0
    char data_0x511[0x20]; // Comes from Bigmac keyslot 0x511
    char data_0x512[0x20]; // Comes from Bigmac keyslot 0x512
    char data_0x517[0x20]; // Comes from Bigmac keyslot 0x517
    char data_0x519[0x20]; // Comes from Bigmac keyslot 0x519
    char cmac_hash[0x10]; // AES256CMAC hash using keyslot 0x514 as key
} cmdF01_SKSO;

enum AGX_CMD {
    AGX_CMD_RESET, // arg1: &1 - reset status, &2 - nowait; arg2: mask;
    AGX_CMD_GATE, // arg1: &1 - open, &2 - nowait; arg2: mask;
    AGX_CMD_CLOCK, // arg1: clock; arg2: nowait
    AGX_CMD_ACL, // arg1: new SRAM ACL
    AGX_CMD_QUERY = 0x100, // query instead of set
};

#ifndef COMPAT_UNUSE
    void compat_IRQ7_handleCmd(uint32_t cmd, uint32_t arg1, uint32_t arg2, uint32_t arg3);
    int compat_f00dState(uint32_t state, bool set);
    uint32_t compat_Cry2Arm0(uint32_t msg);
    void compat_pListCopy(void* io, compat_paddr_list* paddr_list, uint32_t list_entries_count, bool copy_to_list);
    void compat_armReBoot(int armClk, bool hasCS, bool remap_00);
    void compat_killArm(bool prehang);
    void compat_pspemuColdInit(bool dram, bool regbus);
    int compat_handleAllegrex(int cmd, int arg1, int arg2);
#else
    #define compat_IRQ7_handleCmd(a, b, c, d) stub()
    #define compat_f00dState(a, b) stub()
    #define compat_Cry2Arm0(a) stub()
    #define compat_pListCopy(a, b, c, d) stub()
    #define compat_armReBoot(a, b, c) stub()
    #define compat_killArm(a) stub()
    #define compat_pspemuColdInit(a, b) stub()
    #define compat_handleAllegrex(a, b, c) stub()
    #define ALICE_UNUSE
    #define REGINA_UNUSE
#endif

#endif