#include "include/sdif.h"

#include "include/debug.h"
#include "include/clib.h"
#include "include/stor.h"

#ifndef SDIF_UNUSE
static unk_sdif_ctx_init stor_sctx[2];
static unk2_sdif_gigactx stor_gctx[2];

static void prepare_emmc_regs(bool set_keys) {
    vp 0xe3100124 |= 1;
    vp 0xe3101190 = 1;
    vp 0xe31020a0 = 1;
    while (!(vp 0xe31020a0)) {
    };
    vp 0xe31010a0 = 0;
    while ((vp 0xe31010a0)) {
    };
    vp 0xe3101190 = 0;
    while ((vp 0xe3101190)) {
    };
    if (set_keys) {
        vp 0xE0030024 = 0x1c0f020e;
        vp 0xE0030024 = 0x1c0f020f;
        vp 0xe0070008 = 0x020e020f;
        vp 0xe0070000 = 1;
    }
}

static void prepare_sd_regs(void) {
    vp 0xe31020a4 = 1;
    while (!(vp 0xe31020a4)) {
    };
    vp 0xe31010a4 = 0;
    while ((vp 0xe31010a4)) {
    };
}

int stor_init_sd(bool init_ctrl) {
    if (init_ctrl)
        prepare_sd_regs();
    delay(10000);
    memset(&stor_sctx[SDIF_DEV_SD], 0, sizeof(unk_sdif_ctx_init));
    memset(&stor_gctx[SDIF_DEV_SD], 0, sizeof(unk2_sdif_gigactx));
    int ret = sdif_init_ctx(SDIF_DEV_SD, !((vp(0xE0064060) >> 0x11) & 1), &stor_sctx[SDIF_DEV_SD]);
    if (ret < 0)
        return ret;
    stor_gctx[SDIF_DEV_SD].sctx = &stor_sctx[SDIF_DEV_SD];
    return sdif_init_sd(&stor_gctx[SDIF_DEV_SD]);
}

int stor_init_emmc(bool init_ctrl, bool no_keys) {
    if (init_ctrl)
        prepare_emmc_regs(!no_keys);
    delay(10000);
    memset(&stor_sctx[SDIF_DEV_EMMC], 0, sizeof(unk_sdif_ctx_init));
    memset(&stor_gctx[SDIF_DEV_EMMC], 0, sizeof(unk2_sdif_gigactx));
    int ret = sdif_init_ctx(SDIF_DEV_EMMC, !((vp(0xE0064060) >> 0x10) & 1), &stor_sctx[SDIF_DEV_EMMC]);
    if (ret < 0)
        return ret;
    stor_gctx[SDIF_DEV_EMMC].sctx = &stor_sctx[SDIF_DEV_EMMC];
    return sdif_init_mmc(&stor_gctx[SDIF_DEV_EMMC]);
}

int stor_read_sd(uint32_t sector_off, void* dst, uint32_t sector_count) {
    int ret = 0;
    printf("[BOB] read_sd(%X, %X, %X)\n", sector_off, (uint32_t)dst, sector_count);
    ret = sdif_read_sector_sd(&stor_gctx[SDIF_DEV_SD], sector_off, (uint32_t)dst, sector_count);
    if (ret < 0)
        printf("[BOB] read_sd: read failed: %X\n", ret);
    return ret;
}

int stor_write_sd(uint32_t sector_off, void* dst, uint32_t sector_count) {
    int ret = 0;
    printf("[BOB] write_sd(%X, %X, %X)\n", sector_off, (uint32_t)dst, sector_count);
    ret = sdif_write_sector_sd(&stor_gctx[SDIF_DEV_SD], sector_off, (uint32_t)dst, sector_count);
    if (ret < 0)
        printf("[BOB] write_sd: write failed: %X\n", ret);
    return ret;
}

int stor_read_emmc(uint32_t sector_off, void* dst, uint32_t sector_count) {
    int ret = 0;
    printf("[BOB] read_emmc(%X, %X, %X)\n", sector_off, (uint32_t)dst, sector_count);
    ret = sdif_read_sector_mmc(&stor_gctx[SDIF_DEV_EMMC], sector_off, (uint32_t)dst, sector_count);
    if (ret < 0)
        printf("[BOB] read_emmc: read failed: %X\n", ret);
    return ret;
}

int stor_write_emmc(uint32_t sector_off, void* dst, uint32_t sector_count) {
    int ret = 0;
    printf("[BOB] write_emmc(%X, %X, %X)\n", sector_off, (uint32_t)dst, sector_count);
    ret = sdif_write_sector_mmc(&stor_gctx[SDIF_DEV_EMMC], sector_off, (uint32_t)dst, sector_count);
    if (ret < 0)
        printf("[BOB] write_emmc: write failed: %X\n", ret);
    return ret;
}

int stor_export_ctx(int dev_id, unk2_sdif_gigactx* dst_gctx, unk_sdif_ctx_init* dst_sctx) {
    if (!dst_gctx || !dst_sctx || !stor_gctx[dev_id].sctx)
        return -1;
    memcpy(dst_gctx, &stor_gctx[dev_id], sizeof(unk2_sdif_gigactx));
    memcpy(dst_sctx, stor_gctx[dev_id].sctx, sizeof(unk_sdif_ctx_init));
    return 0;
}

int stor_import_ctx(int dev_id, unk2_sdif_gigactx* src_g, unk_sdif_ctx_init* src_s) {
    if (!src_g || !src_s)
        return -1;
    memcpy(&stor_gctx[dev_id], src_g, sizeof(unk2_sdif_gigactx));
    memcpy(&stor_sctx[dev_id], src_s, sizeof(unk_sdif_ctx_init));
    stor_gctx[dev_id].sctx = &stor_sctx[dev_id];
    return 0;
}

#endif