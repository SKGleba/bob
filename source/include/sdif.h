#ifndef __SDIF_H__
#define __SDIF_H__

#include "defs.h"
#include "types.h"
#include "utils.h"

struct _sdif_arg_s {
    uint32_t this_size;
    uint32_t some_arg1;
    uint32_t op_id;
    uint32_t sector;
    uint32_t unk_4;
    uint32_t unk_5;
    uint32_t unk_6;
    uint32_t unk_7;
    uint32_t dst_addr;
    uint32_t sector_size;
    uint32_t sector_count;
    uint32_t unk_11;
};
typedef struct _sdif_arg_s sdif_arg_s;

struct _unk_sdif_ctx_init {
    uint32_t unk_0;
    uint32_t unk_clk1;
    uint32_t unk_clk2;
    uint16_t unk_half_id;
    uint16_t dev_id;
    sdif_arg_s* sdif_arg;
    sdif_arg_s* sdif_arg2;
    volatile uint16_t* sdif_regs_addr;
};
typedef struct _unk_sdif_ctx_init unk_sdif_ctx_init;

struct _unk2_sdif_gigactx {  // shrunk version of the original gigactx
    unk_sdif_ctx_init* sctx;
    uint32_t quirks;  // bit 0: use sector offset instead of byte offset
    uint8_t op9_argx33[0x10];
    uint32_t op9_lutd;  // lut0[op9_4b99] * lut1[op9_3bx60]
    union {
        uint32_t op9_switchd;  // (op9_22bx30 + 1) * 0x400 or (op9_12bx3e + 1) << ((op9_3bx2f + 2) & 0x1f)
        uint32_t op8_switchd;
    };
};
typedef struct _unk2_sdif_gigactx unk2_sdif_gigactx;

enum SDIF_DEV_ID {
    SDIF_DEV_EMMC = 0,
    SDIF_DEV_SD = 1
};

#ifdef SDIF_UNUSE
    #define sdif_read_sector_sd(a, b, c, d) stub()
    #define sdif_read_sector_mmc(a, b, c, d) stub()
    #define sdif_write_sector_sd(a, b, c, d) stub()
    #define sdif_write_sector_mmc(a, b, c, d) stub()
    #define sdif_init_ctx(a, b, c) stub()
    #define sdif_init_sd(a) stub()
    #define sdif_init_mmc(a) stub()
#else
    int sdif_read_sector_sd(unk2_sdif_gigactx* gctx, uint32_t sector, uint32_t dst, uint32_t nsectors);
    int sdif_read_sector_mmc(unk2_sdif_gigactx* gctx, uint32_t sector, uint32_t dst, uint32_t nsectors);
    int sdif_write_sector_sd(unk2_sdif_gigactx* gctx, uint32_t sector, uint32_t dst, uint32_t nsectors);
    int sdif_write_sector_mmc(unk2_sdif_gigactx* gctx, uint32_t sector, uint32_t dst, uint32_t nsectors);
    #ifndef SDIF_NOINITS
        int sdif_init_ctx(int id, bool alt_clk, unk_sdif_ctx_init* ctx);
        int sdif_init_sd(unk2_sdif_gigactx* gctx);
        int sdif_init_mmc(unk2_sdif_gigactx* gctx);
    #else
        #define sdif_init_ctx(a, b, c) stub()
        #define sdif_init_sd(a) stub()
        #define sdif_init_mmc(a) stub()
    #endif
#endif

#endif