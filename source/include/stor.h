#ifndef __STOR_H__
#define __STOR_H__

#include "defs.h"
#include "sdif.h"
#include "types.h"
#include "utils.h"

#ifndef SDIF_UNUSE
    int stor_read_sd(uint32_t sector_off, void* dst, uint32_t sector_count);
    int stor_write_sd(uint32_t sector_off, void* dst, uint32_t sector_count);
    int stor_read_emmc(uint32_t sector_off, void* dst, uint32_t sector_count);
    int stor_write_emmc(uint32_t sector_off, void* dst, uint32_t sector_count);
    int stor_init_sd(bool init_ctrl);
    int stor_init_emmc(bool init_ctrl, bool set_keys);
    int stor_export_ctx(int dev_id, unk2_sdif_gigactx* dst_gctx, unk_sdif_ctx_init* dst_sctx);
    int stor_import_ctx(int dev_id, unk2_sdif_gigactx* src_g, unk_sdif_ctx_init* src_s);
#else
    #define stor_read_sd(a, b, c) stub()
    #define stor_write_sd(a, b, c) stub()
    #define stor_read_emmc(a, b, c) stub()
    #define stor_write_emmc(a, b, c) stub()
    #define stor_init_sd(a) stub()
    #define stor_init_emmc(a, b) stub()
    #define stor_export_ctx(a, b, c) stub()
    #define stor_import_ctx(a, b, c) stub()
#endif

#endif