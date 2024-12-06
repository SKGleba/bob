#include <hardware/paddr.h>
#include <hardware/xbar.h>

#include "include/defs.h"
#include "include/perv.h"
#include "include/types.h"
#include "include/utils.h"

#ifndef DRAM_UNUSE

static uint32_t dram_bank_luts[4][8] = {
    {
        0xE6000000, 0x230B0111,
        0xE6008140, 0x00000002,
        0xE6008048, 0x0000002D,
        0xFFFFFFFF, 0x00000000
    },
    {
        0xE6000000, 0x220B0111,
        0xE6008140, 0x00000004,
        0xE6008048, 0x0000002D,
        0xFFFFFFFF, 0x00000000
    },
    {
        0xE6000000, 0x130B0111,
        0xE6008140, 0x00000004,
        0xE6008048, 0x0000002B,
        0xFFFFFFFF, 0x00000000
    },
    {
        0xE6000000, 0x000C0111,
        0xE6008140, 0x00000006,
        0xE6008048, 0x0000002A,
        0xFFFFFFFF, 0x00000000
    }
};

static uint32_t dram_bank_sshr_lut[2][4] = {
    {
        0x00000002, 0x00000003,
        0xFFFFFFFF, 0x00000000
    },
    {
        0x00000003, 0x00000004,
        0xFFFFFFFF, 0x00000000
    }
};

static uint32_t dram_main_lut[70] = {
    0xe6000020, 0x00000000, 
    0xe6000024, 0x00010003, 
    0xe6000030, 0x00000000, 
    0xe6000034, 0x00010003, 
    0xe6000040, 0x00000000, 
    0xe6000044, 0x00010003,
    0xe6000050, 0x00000000, 
    0xe6000054, 0x00010003, 
    0xe6000060, 0x00000000, 
    0xe6000064, 0x00010003, 
    0xe6000070, 0x00000000, 
    0xe6000074, 0x00010003,
    0xe6000080, 0x00000000, 
    0xe6000084, 0x00010003, 
    0xe6000090, 0x00000000, 
    0xe6000094, 0x00010003, 
    0xe6008038, 0x00000005, 
    0xe6008040, 0x00000004,
    0xe6008050, 0x00000005, 
    0xe6008058, 0x00000003, 
    0xe6008060, 0x00000018, 
    0xe6008068, 0x00000003, 
    0xe6008088, 0x0000000c, 
    0xe6008090, 0x0000000c,
    0xe6008098, 0x00000010, 
    0xe60080b0, 0x00000006, 
    0xe60080e0, 0x0000002e, 
    0xe60080e8, 0x0000002e, 
    0xe60080f0, 0x00000002, 
    0xe6008150, 0x00000002,
    0xe6008158, 0x00000002, 
    0xe6008160, 0x0000000b, 
    0xe6008168, 0x00000005, 
    0xe6008178, 0x00000006, 
    0xffffffff, 0x00000000
};

static uint32_t dram_secondary_lut[38] =
{
    0xe60080c8, 0x00001fff, 
    0xe6008200, 0x00000076, 
    0xe6008208, 0x00000076, 
    0xe6008210, 0x00000076, 
    0xe6008218, 0x00000076,
    0xe6008220, 0x0000005e, 
    0xe6008228, 0x0000005e, 
    0xe6008230, 0x0000005e, 
    0xe6008238, 0x0000005e, 
    0xe6008260, 0x00000067,
    0xe60083b0, 0x0d068235, 
    0xe60083b4, 0x014e014e, 
    0xe6008030, 0x00000514, 
    0xe60081a0, 0x0000001e, 
    0xe60081a8, 0x00000003,
    0xe60081b0, 0x0000001e, 
    0xe60081b8, 0x00000003, 
    0xe6008070, 0x00000006, 
    0xffffffff, 0x00000000
};

static void dram_reset(int dram_clock) {
    pervasive_control_gate(PERV_CTRL_GATE_DEV_LPDDR0, 0x1, false, true);
    pervasive_control_reset(PERV_CTRL_RESET_DEV_LPDDR0, 0x1, true, true);
    pervasive_control_misc((0x44 / 4), 0, true);  // TODO: document this
    pervasive_control_clock((0x90 / 4), dram_clock & 3, true);
    pervasive_control_gate(PERV_CTRL_GATE_DEV_LPDDR0, 0x1, true, true);
    pervasive_control_reset(PERV_CTRL_RESET_DEV_LPDDR0, 0x1, false, true);
}

static void dram_swsh(int num_banks, int wv, int xv) {
    int uret = 0;
    uint8_t *regz = (uint8_t *)(LPDDR0_CFG_OFFSET + 0x8000);
    int i = num_banks + 1;
    while (i -= 1, i != 0) {
        *regz = wv & 7;
        regz += 8;
    }
    for (int uj = 0; uj < num_banks; uj -= -1) {
        while (uret = vp(LPDDR0_CFG_OFFSET + 0x8000 + 0x20), (uret >> ((uj & 7) << 2) & 0xF) != (xv & 0xFF))
            delay_nx(10, 200);
    }
}

#define dram_sshr(reg, lb, hb) vp(LPDDR0_CFG_OFFSET + 0x8000 + 0x100 + (reg * 8)) = (lb & 0xFF) | ((hb & 0xFF) << 8);

static void dram_sshr_lut(int num_banks, uint8_t *lut) {
    uint8_t *lut_c;
    for (int bank = 0; lut_c = lut, bank < num_banks; bank = bank + 1) {
        for (; *(int *)lut_c != -1; lut_c = lut_c + 8)
            dram_sshr(bank, *lut_c, lut_c[4]);
    }
}

static void dram_lut_apply(int **lut) {
    for (; (int **)*lut != (int **)0xffffffff; lut = lut + 2) {
        **lut = (int)lut[1];
        while ((int *)**lut != lut[1])
            ;
    }
}

static int dram_sshtr(int num_banks) {
    uint8_t RB5 = 0, RB8 = 0;

    vp(LPDDR0_CFG_OFFSET + 0x8000 + 0x120) = 5;
    RB5 = (vp(LPDDR0_CFG_OFFSET + 0x8000 + 0x120) & 0xFF00) >> 8;

    vp(LPDDR0_CFG_OFFSET + 0x8000 + 0x120) = 8;
    RB8 = (vp(LPDDR0_CFG_OFFSET + 0x8000 + 0x120) & 0xFF00) >> 8;

    if (RB8 & 3)
        return 4;

    if ((RB5 & 7) == 1) {
        RB8 = (RB8 & 0x3c) >> 2;
        if (RB8 == 5) {
            if (num_banks == 2)
                return 2;
            else if (num_banks == 4)
                return 1;
        } else if (RB8 == 4 && num_banks == 4)
            return 0;
    } else if (((RB5 & 7) == 3) && ((RB8 & 0x3c) == 0x18))
        return (4 - (num_banks == 1));

    return 4;
}

int dram_init(int clock, bool is_resume) {
    int num_banks = 0;
    uint32_t soc_rev = vp PERV_GET_REG(PERV_CTRL_MISC, PERV_CTRL_MISC_REG_SOC_REV);
    if ((int)soc_rev < 0) {
        soc_rev &= 0x30000000;
        switch (soc_rev) {
            case 0:
                num_banks = 2;
                break;
            case 0x10000000:
                num_banks = 1;
                break;
            case 0x20000000:
                num_banks = 4;
                break;
            default:
                break;
        }
    } else
        num_banks = 4;

    if (!num_banks)
        return -1;

    dram_reset(clock);

    if (is_resume)
        dram_swsh(num_banks, 5, 4);
    dram_swsh(num_banks, 2, 2);

    vp(LPDDR0_CFG_OFFSET + 0x8000 + 0x180) = 1;
    while (vp(LPDDR0_CFG_OFFSET + 0x8000 + 0x180) != 1)
        ;

    int x = 0, y = 0;
    do {
        y = x + 1;
        dram_sshr(x, 2, 3);
        x = y;
    } while (y < num_banks);

    int sshtr = dram_sshtr(num_banks);
    if (sshtr > 3)
        return -2;

    dram_lut_apply((int **)dram_main_lut);
    dram_lut_apply((int **)dram_bank_luts[sshtr]);
    dram_lut_apply((int **)dram_secondary_lut);

    dram_sshr_lut(num_banks, (uint8_t*)dram_bank_sshr_lut[0]);
    if (sshtr == 3)
        dram_sshr_lut(num_banks, (uint8_t *)dram_bank_sshr_lut[1]);

    dram_swsh(num_banks, 1, 1);

    return 0;
}

#endif