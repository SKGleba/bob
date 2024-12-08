#include "include/sdif.h"

#include "include/defs.h"
#include "include/types.h"
#include "include/utils.h"
#include "include/clib.h"

#include "include/debug.h" // temp

#ifndef SDIF_UNUSE

#define CONCAT11(high, low) ((high << 8) | low)
#define CONCAT12(high, low) ((high << 16) | low)
#define CONCAT13(high, low) ((high << 24) | low)

static void sdif_cfgwait_regs16_x19nx1b(unk_sdif_ctx_init *param_1, uint32_t param_2) {
    if (param_2 != 0) {
        SceSdifReg *sdif = param_1->sdif_regs_addr;

        /* Suspend error interrupts */
        uint16_t prevEIS = sdif->ErrorInterruptStatusEnable;
        sdif->ErrorInterruptStatusEnable = 0;

        while (sdif->ErrorInterruptStatusEnable != 0)
            ;

        if ((param_2 & 0xf) != 0) {
            /* Reset command line logic */
            sdif->SoftwareReset = SDHC_SOFTWARE_RESET_CMD_LINE;
            while (sdif->SoftwareReset & SDHC_SOFTWARE_RESET_CMD_LINE)
                ;
        }

        if ((param_2 & 0x70) != 0) {
            /* Reset data line logic */
            sdif->SoftwareReset = SDHC_SOFTWARE_RESET_DAT_LINE;
            while (sdif->SoftwareReset & SDHC_SOFTWARE_RESET_DAT_LINE)
                ;
        }

        /* Clear error interrupt flags */
        sdif->ErrorInterruptStatus = sdif->ErrorInterruptStatus;
        while (sdif->ErrorInterruptStatus != 0)
            ;

        /* Restore error interrupts that we suspended earlier */
        sdif->ErrorInterruptStatusEnable = prevEIS;
        while (sdif->ErrorInterruptStatusEnable != prevEIS)
            ;
    }
    return;
}

static void sdif_rx_maybe(unk_sdif_ctx_init *ctx, uint32_t param_2, uint32_t param_3) {
    SceSdifReg *sdif = ctx->sdif_regs_addr;
    sdif_arg_s *psVar1;
    uint32_t uVar2;
    uint16_t uVar4;
    uint32_t uVar5;
    int iVar6;
    sdif_arg_s *psVar7;
    int iVar8;
    uint8_t *puVar9;
    uint32_t *puVar10;

    psVar1 = ctx->sdif_arg;
    if (psVar1 != (sdif_arg_s *)0x0) {
        if (ctx->sdif_arg2 == (sdif_arg_s *)0x0) {
            if (((param_2 & 2) != 0) && ((psVar1->some_arg1 & 8) != 0)) {
                psVar1->some_arg1 = psVar1->some_arg1 | 0x80000000;
            }
        } else if (param_3 == 0) {
            if ((((param_2 & 0x20) != 0) && ((psVar1->some_arg1 & 0x700) == 0x100)) && (0 < (int)psVar1->sector_count)) {
                uVar2 = psVar1->dst_addr;

//                puVar3 = ctx->sdif_regs_addr;

                psVar1->sector_count = psVar1->sector_count - 1;

                /* Wait for readable data in controller buffer */
                while (!(sdif->PresentState & SDHC_PRESENT_STATE_BUFFER_READ_ENABLED))
                    ;

                iVar6 = 0;
                if (0 < (int)psVar1->sector_size) {
                    do {
                        iVar8 = psVar1->sector_size - iVar6;
                        if (iVar8 == 1) {
                            puVar9 = (uint8_t *)(iVar6 + uVar2);
                            iVar6 = iVar6 + 1;

                            *puVar9 = v8p(&sdif->BufferDataPort);
                        } else {
                            puVar10 = (uint32_t *)(uVar2 + iVar6);
                            if (iVar8 < 4) {
                                uVar4 = v16p(&sdif->BufferDataPort);
                                iVar6 = iVar6 + 2;
                                v8p puVar10 = (uint8_t)uVar4;
                                v8p((int)puVar10 + 1) = (uint8_t)(uVar4 >> 8);
                            } else {
                                uVar5 = sdif->BufferDataPort;
                                if ((uVar2 & 3) == 0) {
                                    *puVar10 = uVar5;
                                } else {
                                    v8p puVar10 = (uint8_t)uVar5;
                                    v8p((int)puVar10 + 1) = (uint8_t)((uint32_t)uVar5 >> 8);
                                    v8p((int)puVar10 + 3) = (uint8_t)((uint32_t)uVar5 >> 0x18);
                                    v8p((int)puVar10 + 2) = (uint8_t)((uint32_t)uVar5 >> 0x10);
                                }
                                iVar6 = iVar6 + 4;
                            }
                        }
                    } while (iVar6 < (int)psVar1->sector_size);
                }
                psVar1->dst_addr = psVar1->dst_addr + psVar1->sector_size;
            }
            if ((((param_2 & 0x10) != 0) && ((psVar1->some_arg1 & 0x700) == 0x200)) && (0 < (int)psVar1->sector_count)) {
                uVar2 = psVar1->dst_addr;
//                puVar3 = ctx->sdif_regs_addr;
                psVar1->sector_count = psVar1->sector_count - 1;

                /* Wait for free space in controller write buffer */
                while (!(sdif->PresentState & SDHC_PRESENT_STATE_BUFFER_WRITE_ENABLED))
                    ;

                iVar6 = 0;
                if (0 < (int)psVar1->sector_size) {
                    do {
                        iVar8 = psVar1->sector_size - iVar6;
                        if (iVar8 == 1) {
                            puVar9 = (uint8_t *)(iVar6 + uVar2);
                            iVar6 = iVar6 + 1;

                            v8p(&sdif->BufferDataPort) = *puVar9;
                        } else {
                            puVar10 = (uint32_t *)(iVar6 + uVar2);
                            if (iVar8 < 4) {
                                iVar6 = iVar6 + 2;
                                v16p(&sdif->BufferDataPort) = CONCAT11(v8p((int)puVar10 + 1), v8p puVar10);
                            } else {
                                if ((uVar2 & 3) == 0) {
                                    uVar5 = *puVar10;
                                } else {
                                    uVar5 = CONCAT13(v8p((int)puVar10 + 3), CONCAT12(v8p((int)puVar10 + 2), CONCAT11(v8p((int)puVar10 + 1), v8p puVar10)));
                                }
                                iVar6 = iVar6 + 4;
                                sdif->BufferDataPort = uVar5;
                            }
                        }
                    } while (iVar6 < (int)psVar1->sector_size);
                }
                psVar1->dst_addr = psVar1->dst_addr + psVar1->sector_size;
            }
            if ((param_2 & 2) != 0) {
                psVar7 = (sdif_arg_s *)(int)v8p((int)&ctx->dev_id + 1);
                if (psVar7 != (sdif_arg_s *)0x0) {
                    psVar7 = (sdif_arg_s *)0x0;
                    psVar1->some_arg1 = psVar1->some_arg1 | 0x80000000;
                }
                ctx->sdif_arg2 = psVar7;
            }
        } else {
            ctx->sdif_arg2 = (sdif_arg_s *)0x0;
            psVar1->unk_11 = ((param_3 & 0x10) == 0) + 0x80320002;
            psVar1->some_arg1 = psVar1->some_arg1 | 0x40000000;
            sdif_cfgwait_regs16_x19nx1b(ctx, param_3);
        }
    }
    return;
}

static void sdif_prep_txarg(unk_sdif_ctx_init *param_1, sdif_arg_s *param_2) {
    SceSdifReg *sdif = param_1->sdif_regs_addr;
    uint32_t uVar1;
    uint32_t uVar2;
    int iVar3;
    uint32_t uVar4;

    param_2->unk_11 = 0;
    uVar4 = param_2->some_arg1 & 0xf8;
    if (((((uVar4 == 0x90) || (uVar4 == 0x80)) || (uVar4 == 0x78)) || ((uVar4 == 0x60 || (uVar4 == 0x50)))) || (uVar4 == 0x40)) {
        param_2->unk_4 = sdif->Response[0];
    } else if (uVar4 == 0x30) {
        uVar4 = sdif->Response[0];
        uVar1 = sdif->Response[1];
        uVar2 = sdif->Response[2];
        iVar3 = sdif->Response[3];
        param_2->unk_4 = uVar4 << 8;
        param_2->unk_5 = uVar1 << 8 | uVar4 >> 0x18;
        param_2->unk_6 = uVar2 << 8 | uVar1 >> 0x18;
        param_2->unk_7 = iVar3 << 8 | uVar2 >> 0x18;
    } else if (((uVar4 == 0x28) || (uVar4 == 0x10)) && (param_2->unk_4 = sdif->Response[0], (param_2->some_arg1 & 0x800) != 0)) {
        param_2->unk_7 = sdif->Response[3];
    }

    if ((param_2->some_arg1 & 0x3000) != 0) {
        /* Reset command and data logic (including DMA) */
        sdif->SoftwareReset = (SDHC_SOFTWARE_RESET_DAT_LINE | SDHC_SOFTWARE_RESET_CMD_LINE);

        while (sdif->SoftwareReset & (SDHC_SOFTWARE_RESET_DAT_LINE | SDHC_SOFTWARE_RESET_CMD_LINE)) {
            /* Wait until reset is complete */
        }
    }
    return;
}

static void sdif_tx_maybe(unk_sdif_ctx_init *ctx, uint32_t param_2, uint32_t param_3) {
    sdif_arg_s *psVar1;

    psVar1 = ctx->sdif_arg;
    if (psVar1 != (sdif_arg_s *)0x0) {
        if (param_3 == 0) {
            if ((param_2 & 1) != 0) {
                v8p((int)&ctx->dev_id + 1) = 1;
                sdif_prep_txarg(ctx, psVar1);
                if ((ctx->sdif_arg2 == (sdif_arg_s *)0x0) && ((psVar1->some_arg1 & 8) == 0)) {
                    psVar1->some_arg1 = psVar1->some_arg1 | 0x80000000;
                }
            }
        } else {
            psVar1->unk_11 = ((param_3 & 1) == 0) + 0x80320002;
            psVar1->some_arg1 = psVar1->some_arg1 | 0x40000000;
            sdif_cfgwait_regs16_x19nx1b(ctx, param_3);
        }
    }
    return;
}

static uint32_t sdif_trans_action(uint32_t dev_id, unk_sdif_ctx_init *ctx) {
    SceSdifReg *sdif = ctx->sdif_regs_addr;
    uint16_t NIS = sdif->NormalInterruptStatus;
    uint16_t EIS = sdif->ErrorInterruptStatus;

    /* Check for command phase completion or errors */
    if ((NIS & SDHC_NORMAL_IRQ_STATUS_CMD_COMPLETE) || (EIS & SDHC_ERROR_IRQ_STATUS_COMMAND_PHASE_ERRORS)) {
        /* Clear related interrupt flags */
        sdif->NormalInterruptStatus = SDHC_NORMAL_IRQ_STATUS_CMD_COMPLETE;
        sdif->ErrorInterruptStatus = SDHC_ERROR_IRQ_STATUS_COMMAND_PHASE_ERRORS;

        /* Wait until flags are cleared */
        while (sdif->NormalInterruptStatus & SDHC_NORMAL_IRQ_STATUS_CMD_COMPLETE)
            ;   
        while (sdif->ErrorInterruptStatus & SDHC_ERROR_IRQ_STATUS_COMMAND_PHASE_ERRORS)
            ;

        sdif_tx_maybe(ctx, (uint32_t)(NIS & ~SDHC_NORMAL_IRQ_STATUS_CARD_STATUS_FLAGS), (uint32_t)EIS);
    }

    /* Check for data phase completion or errors */
    const uint32_t DATA_PHASE_STATUS_BITS = SDHC_NORMAL_IRQ_STATUS_TFR_COMPLETE | SDHC_NORMAL_IRQ_STATUS_BUFFER_WRITE_READY | SDHC_NORMAL_IRQ_STATUS_BUFFER_READ_READY;
    if ((NIS & DATA_PHASE_STATUS_BITS) || (EIS & SDHC_ERROR_IRQ_STATUS_DATA_PHASE_ERRORS)) {
        /* Clear related interrupt flags */
        sdif->NormalInterruptStatus = DATA_PHASE_STATUS_BITS;
        sdif->ErrorInterruptStatus = SDHC_ERROR_IRQ_STATUS_DATA_PHASE_ERRORS;

        /* Wait until flags are cleared */
        while (sdif->NormalInterruptStatus & DATA_PHASE_STATUS_BITS)
            ;   
        while (sdif->ErrorInterruptStatus & SDHC_ERROR_IRQ_STATUS_DATA_PHASE_ERRORS)
            ;

        sdif_rx_maybe(ctx, (uint32_t)(NIS & ~SDHC_NORMAL_IRQ_STATUS_CARD_STATUS_FLAGS), (uint32_t)EIS);
    }

    return 0;
}

static uint32_t write_args(unk_sdif_ctx_init *ctx, sdif_arg_s *op) {
    SceSdifReg *sdif = ctx->sdif_regs_addr;
    uint16_t transferMode;
    sdif_arg_s *psVar2;
    uint16_t uVar3;
    uint32_t uVar4;

    op->unk_11 = 0;
    op->some_arg1 = op->some_arg1 & 0x3fffffff;
    v8p((int)&ctx->dev_id + 1) = 0;
    ctx->sdif_arg2 = (sdif_arg_s *)0x0;
    ctx->sdif_arg = op;
    do {
        while (sdif->PresentState & SDHC_PRESENT_STATE_CMD_INHIBITED) {
            /* Wait until CMD line is not in use */
        }
    } while (
            /* Check that command doesn't need DAT lines, or wait until they are free */
            (op->op_id != 12) && 
            (
                (
                    (op->some_arg1 & 7) == 4 || 
                    ((op->some_arg1 & 0xf8) == 0x28)
                ) && (sdif->PresentState & SDHC_PRESENT_STATE_DAT_INHIBITED)
            )
        );

    uVar4 = op->some_arg1 & 0xf8;
    if (uVar4 == 0x30) {
        uVar3 = 9;
    } else if ((uVar4 == 0x78) || (uVar4 == 0x28)) {
        uVar3 = 0x1b;
    } else if (((uVar4 == 0x90) || (uVar4 == 0x80)) || ((uVar4 == 0x60 || (uVar4 == 0x10)))) {
        uVar3 = 0x1a;
    } else if ((uVar4 == 0x50) || (uVar4 == 0x40)) {
        uVar3 = 2;
    } else {
        uVar3 = 0;
    }
    uVar4 = op->some_arg1 & 7;
    if (uVar4 == 4) {
        ctx->sdif_arg2 = op;

        sdif->TimeoutControl = SDHC_TIMEOUT_CONTROL_DATA_TIMEOUT_2_27;
        sdif->HostControl1 = (sdif->HostControl1 & ~SDHC_HOST_CONTROL1_DMA_SELECT_Msk) | SDHC_HOST_CONTROL1_DMA_SELECT_SDMA;

        sdif->BlockSize = SDHC_BLOCK_SIZE_HOST_SDMA_BOUNDARY_512K | (uint16_t)op->sector_size;
        sdif->BlockCount = (uint16_t)op->sector_count;

        if (op->some_arg1 & 0x100) {
            transferMode = SDHC_TRANSFER_MODE_DATA_DIRECTION_WRITE;
        } else {
            transferMode = SDHC_TRANSFER_MODE_DATA_DIRECTION_READ;
        }

        if ((op->some_arg1 & 0x800) != 0) {
            transferMode |= SDHC_TRANSFER_MODE_AUTO_CMD12_ENABLE;
        }

        if (op->sector_count == 0) {
            op->sector_count = 1;
        } else if (op->sector_count == 1) {
            transferMode |= (SDHC_TRANSFER_MODE_BLOCK_COUNT_ENABLE | SDHC_TRANSFER_MODE_SINGLE_BLOCK);
        } else if (1 < (int)op->sector_count) {
            transferMode = (SDHC_TRANSFER_MODE_BLOCK_COUNT_ENABLE | SDHC_TRANSFER_MODE_MULTI_BLOCK);
        }

        sdif->Argument1  = op->sector;
        sdif->TransferMode = transferMode;

        /* Kickstart SDIF command */
        sdif->Command = (uint16_t)(op->op_id << SDHC_COMMAND_COMMAND_INDEX_Pos) | SDHC_COMMAND_DATA_PRESENT_YES | uVar3;
    } else if (((uVar4 == 3) || (uVar4 == 2)) || (uVar4 == 1)) {
        sdif->Argument1 = op->sector;

        sdif->TransferMode = SDHC_TRANSFER_MODE_DATA_DIRECTION_READ;
        sdif->Command = (uint16_t)(op->op_id << SDHC_COMMAND_COMMAND_INDEX_Pos) | uVar3;
    }

    while ((op->some_arg1 & 0xc0000000) == 0) {
        if (sdif->NormalInterruptStatus || sdif->ErrorInterruptStatus) {
            sdif_trans_action((uint32_t) * (volatile uint8_t *)&ctx->dev_id, ctx);
        }
        delay(1000);
    }

    uVar4 = 0;
    psVar2 = (sdif_arg_s *)(op->some_arg1 & 0x40000000);
    if (psVar2 != (sdif_arg_s *)0x0) {
        psVar2 = (sdif_arg_s *)0x0;
        uVar4 = op->unk_11;
    }
    ctx->sdif_arg = psVar2;
    return uVar4;
}

static int write_args_retry(unk_sdif_ctx_init *ctx, sdif_arg_s *op, int retry_n) {
    int iret;

    do {
        iret = write_args(ctx, op);
        if (-1 < iret) {
            return iret;
        }
        retry_n = retry_n + -1;
    } while (0 < retry_n);
    return iret;
}

static int sdif_do_op_0xc(unk_sdif_ctx_init *ctx, int unk_arg1_0x302b) {
    int iVar1;
    sdif_arg_s op;

    op.this_size = 0x30;
    op.some_arg1 = 0x3013;
    if (unk_arg1_0x302b != 0) {
        op.some_arg1 = 0x302b;
    }
    op.op_id = 0xc;
    op.sector = 0;
    iVar1 = write_args_retry(ctx, &op, 3);
    if (-1 < iVar1) {
        iVar1 = 0;
    }
    return iVar1;
}

static int parse_op_unk_4(uint32_t param_1) {
    uint32_t uVar1;

    if ((param_1 & 0xfdffe008) == 0) {
        return 0;
    }
    uVar1 = 0;
    do {
        if ((1 << (uVar1 & 0x1f) & param_1 & 0xfdffe008) != 0)
            break;
        uVar1 = uVar1 + 1;
    } while ((int)uVar1 < 0x20);
    return uVar1 + 0x80320100;
}

static int do_op_0x17(unk_sdif_ctx_init *ctx, uint32_t unk_sector_arg) {
    int iVar1;
    sdif_arg_s local_34;

    local_34.dst_addr = 0;
    local_34.op_id = 0x17;
    local_34.some_arg1 = 0x13;
    local_34.this_size = 0x30;
    local_34.sector = unk_sector_arg;
    iVar1 = write_args_retry(ctx, &local_34, 3);
    if ((-1 < iVar1) && (iVar1 = parse_op_unk_4(local_34.unk_4), -1 < iVar1)) {
        iVar1 = 0;
    }
    return iVar1;
}

static int sdif_do_op_0xd(unk_sdif_ctx_init *ctx, uint32_t *unk_4_ret) {
    int iret;
    sdif_arg_s op;

    op.some_arg1 = 0x13;
    op.op_id = 0xd;
    op.this_size = 0x30;
    op.dst_addr = 0;
    op.sector = (uint32_t)ctx->unk_half_id << 0x10;
    iret = write_args_retry(ctx, &op, 3);
    if (-1 < iret) {
        if (unk_4_ret != (uint32_t *)0x0) {
            *unk_4_ret = op.unk_4;
        }
        iret = parse_op_unk_4(op.unk_4);
        if (-1 < iret) {
            iret = 0;
        }
    }
    return iret;
}

int sdif_read_sector_sd(unk2_sdif_gigactx *gctx, uint32_t sector, uint32_t dst, uint32_t nsectors) {
    int iret;
    sdif_arg_s op;

    op.this_size = 0x30;
    if (nsectors == 1) {
        op.op_id = 0x11;
        op.some_arg1 = 0x114;
    } else {
        op.some_arg1 = 0x914;
        op.op_id = 0x12;
    }
    op.sector = sector;
    if (!(gctx->quirks & 1))
        op.sector = sector << 9;
    op.sector_size = 0x200;
    op.dst_addr = dst;
    op.sector_count = nsectors;
    iret = write_args_retry(gctx->sctx, &op, 0);
    if (iret < 0) {
        if (op.op_id == 0x12) {
            sdif_do_op_0xc(gctx->sctx, 1);
        }
    } else {
        iret = sdif_do_op_0xd(gctx->sctx, 0);
        if (-1 < iret) {
            iret = 0;
        }
    }
    return iret;
}

int sdif_write_sector_sd(unk2_sdif_gigactx *gctx, uint32_t sector, uint32_t dst, uint32_t nsectors) {
    int iret;
    sdif_arg_s op;

    op.this_size = 0x30;
    if (nsectors == 1) {
        op.op_id = 0x18;
        op.some_arg1 = 0x214;
    } else {
        op.some_arg1 = 0xa14;
        op.op_id = 0x19;
    }
    op.sector = sector;
    if (!(gctx->quirks & 1))
        op.sector = sector << 9;
    op.sector_size = 0x200;
    op.dst_addr = dst;
    op.sector_count = nsectors;
    iret = write_args_retry(gctx->sctx, &op, 0);
    if (iret < 0) {
        if (op.op_id == 0x19) {
            sdif_do_op_0xc(gctx->sctx, 1);
        }
    } else {
        iret = sdif_do_op_0xd(gctx->sctx, 0);
        if (-1 < iret) {
            iret = 0;
        }
    }
    return iret;
}

int sdif_read_sector_mmc(unk2_sdif_gigactx *gctx, uint32_t sector, uint32_t dst, uint32_t nsectors) {
    int iret;
    sdif_arg_s op;

    op.some_arg1 = 0x114;
    op.this_size = 0x30;
    op.op_id = (nsectors != 1) + 0x11;
    op.sector = sector;
    if (!(gctx->quirks & 1))
        op.sector = sector << 9;
    op.sector_size = 0x200;
    op.dst_addr = dst;
    op.sector_count = nsectors;
    if ((op.op_id != 0x12) || (iret = do_op_0x17(gctx->sctx, nsectors), -1 < iret)) {
        iret = write_args_retry(gctx->sctx, &op, 0);
        if (iret < 0) {
            if ((((op.op_id == 0x12) && (iret != -0x7fcdfee3)) && (iret != -0x7fcdfee2)) && (iret != -0x7fcdfee1)) {
                sdif_do_op_0xc(gctx->sctx, 0);
            }
        } else {
            iret = sdif_do_op_0xd(gctx->sctx, 0);
            if (-1 < iret) {
                iret = 0;
            }
        }
    }
    return iret;
}

int sdif_write_sector_mmc(unk2_sdif_gigactx *gctx, uint32_t sector, uint32_t dst, uint32_t nsectors) {
    int iret;
    sdif_arg_s op;

    op.some_arg1 = 0x214;
    op.this_size = 0x30;
    op.op_id = (nsectors != 1) + 0x18;
    op.sector = sector;
    if (!(gctx->quirks & 1))
        op.sector = sector << 9;
    op.sector_size = 0x200;
    op.dst_addr = dst;
    op.sector_count = nsectors;
    if ((op.op_id != 0x19) || (iret = do_op_0x17(gctx->sctx, nsectors), -1 < iret)) {
        iret = write_args_retry(gctx->sctx, &op, 0);
        if (iret < 0) {
            if ((((op.op_id == 0x12) && (iret != -0x7fcdfee3)) && (iret != -0x7fcdfee2)) && (iret != -0x7fcdfee1)) {
                sdif_do_op_0xc(gctx->sctx, 0);
            }
        } else {
            iret = sdif_do_op_0xd(gctx->sctx, 0);
            if (-1 < iret) {
                iret = 0;
            }
        }
    }
    return iret;
}

#ifndef SDIF_NOINITS
static uint32_t sdif_pingwaitcfg_regs(unk_sdif_ctx_init *param_1, uint32_t param_2) {
    SceSdifReg *sdif = param_1->sdif_regs_addr;

    if ((param_2 & 1) != 0) {
        /* Reset the entire SD host controller */
        sdif->SoftwareReset = SDHC_SOFTWARE_RESET_ALL;

        /* Wait until reset is complete */
        while (sdif->SoftwareReset & SDHC_SOFTWARE_RESET_ALL)
            ;
    }

    if ((param_2 & 2) != 0) {
        const uint32_t NIS_ENABLED =
            (SDHC_NORMAL_IRQ_STATUS_CARD_REMOVAL | SDHC_NORMAL_IRQ_STATUS_CARD_INSERTION
                | SDHC_NORMAL_IRQ_STATUS_BUFFER_READ_READY | SDHC_NORMAL_IRQ_STATUS_BUFFER_WRITE_READY
                | SDHC_NORMAL_IRQ_STATUS_TFR_COMPLETE | SDHC_NORMAL_IRQ_STATUS_CMD_COMPLETE);

        const uint32_t EIS_ENABLED =
            (SDHC_ERROR_IRQ_STATUS_AUTO_CMD_ERROR | SDHC_ERROR_IRQ_STATUS_DATA_PHASE_ERRORS
                | SDHC_ERROR_IRQ_STATUS_COMMAND_PHASE_ERRORS);

        sdif->NormalInterruptStatusEnable = NIS_ENABLED;
        sdif->ErrorInterruptStatusEnable = EIS_ENABLED;
        sdif->NormalInterruptSignalEnable = NIS_ENABLED;
        sdif->ErrorInterruptSignalEnable = EIS_ENABLED;

        sdif->TimeoutControl = SDHC_TIMEOUT_CONTROL_DATA_TIMEOUT_2_27;

        /* Wait until card present state is stable */
        while (!(sdif->PresentState & SDHC_PRESENT_STATE_CARD_STATE_STABLE))
            ;

        /* Clear all interrupt flags */
        sdif->NormalInterruptStatus = sdif->NormalInterruptStatus;
        sdif->ErrorInterruptStatus = sdif->ErrorInterruptStatus;

        /* Wait for clear to be completed */
        while (sdif->NormalInterruptStatus != 0)
            ;
        while (sdif->ErrorInterruptStatus != 0)
            ;
    }
    return 0;
}

int sdif_init_ctx(int id, bool alt_clk, unk_sdif_ctx_init *ctx) {
    memset(ctx, 0, sizeof(unk_sdif_ctx_init));
    switch (id) {
        case SDIF_DEV_EMMC:
            ctx->unk_0 = 0x80;
            break;
        case SDIF_DEV_SD:
        case 0x101:
            ctx->unk_0 = 0x300000;
            break;
        default:
            ctx->unk_0 = 0;
    }

    ctx->unk_clk1 = 48000000;
    ctx->unk_clk2 = alt_clk ? 24000000 : 48000000;
    ctx->dev_id = id;

    uint32_t regBase;
    if ((id & 0xFF) == 0 || id == 0x101) {
        regBase = SDIF0_BASE;
    } else {
        regBase = (SDIF1_BASE - 0x10000) + (id & 0xFF) * 0x10000;
    }

    ctx->sdif_regs_addr = (SceSdifReg *)regBase;

    sdif_pingwaitcfg_regs(ctx, /* Reset entire controller and IRQ status */ 3);

    return 0;
}

static uint32_t bitfield_extract(int ptr, uint32_t start_bit, uint32_t numbits) {
    uint32_t ui;
    uint8_t *pos;
    uint32_t mask1;
    uint32_t accu;
    uint32_t mask2;

    accu = 0;
    ui = 0;
    pos = (uint8_t *)(ptr + (start_bit >> 3));
    mask1 = 1 << (start_bit & 7) & 0xff;
    if (numbits != 0) {
        do {
            mask2 = 0;
            if ((*pos & mask1) != 0) {
                mask2 = 1 << (ui & 0x1f);
            }
            accu = accu | mask2;
            mask2 = mask1 & 0x7f;
            mask1 = mask2 << 1;
            if (mask2 == 0) {
                pos = pos + 1;
                mask1 = 1;
            }
            ui = ui + 1;
        } while (ui < numbits);
    }
    return accu;
}

static int sdif_wait_card_present(unk_sdif_ctx_init *param_1) {
    SceSdifReg *sdif = param_1->sdif_regs_addr;
    int remainingTries = 1000;

    while (remainingTries > 0) {
        /* Wait for stabilization of card presence state */
        if (!(sdif->PresentState & SDHC_PRESENT_STATE_CARD_STATE_STABLE)) {
            remainingTries--;
            delay(1000);
        }

        return (sdif->PresentState & SDHC_PRESENT_STATE_CARD_INSERTED_Msk) >> SDHC_PRESENT_STATE_CARD_INSERTED_Pos;
    }

    /* 0x80320002 */
    return -2144206846;
}

static int sdif_configure_bus(unk_sdif_ctx_init *param_1) {
    SceSdifReg *sdif = param_1->sdif_regs_addr;

    while (!(sdif->PresentState & SDHC_PRESENT_STATE_CARD_STATE_STABLE)) {
        /* Wait for stabilization of card presence state */
    }

    /* If a card is inserted, configure the bus */
    if ((sdif->PresentState & SDHC_PRESENT_STATE_CARD_INSERTED)) {
        /* Turn on power on SD Bus @ 1.8V */
        sdif->PowerControl |= (SDHC_POWER_CONTROL_SD_BUS_VOLTAGE_SELECT_1V8 | SDHC_POWER_CONTROL_SD_BUS_POWER_ON);

        /* Disable all clocks */
        sdif->ClockControl = 0;

        /* Enable internal clock and configure SD Clock to lowest speed possible */
        sdif->ClockControl |= (SDHC_CLOCK_CONTROL_SDCLK_FREQ_BASECLK_DIV_256 | SDHC_CLOCK_CONTROL_INTERNAL_CLOCK_ENABLE);

        while (!(sdif->ClockControl & SDHC_CLOCK_CONTROL_INTERNAL_CLOCK_STABLE)) {
            /* Wait for internal clock to stabilize */
        }

        /* Enable SD Clock */
        sdif->ClockControl |= SDHC_CLOCK_CONTROL_SD_CLOCK_ENABLE;

        /* Reset HostControl1 */
        sdif->HostControl1 = 0;
    }
    
    return 0;
}

static int sdif_work_reg16x16(unk_sdif_ctx_init *param_1, uint32_t param_2, int enable_high_speed) {
    SceSdifReg *sdif = param_1->sdif_regs_addr;
    uint32_t uVar4;

    if (param_1->unk_clk2 < param_2) {
        param_2 = param_1->unk_clk2;
    }
    uVar4 = 0;
    do {
        if (param_1->unk_clk1 >> ((uint8_t)uVar4 & 0x1f) <= param_2)
            break;
        uVar4 = uVar4 + 1;
    } while ((int)uVar4 < 8);

    /* Reset clock configuration and turn off all clocks */
    sdif->ClockControl = 0;

    /* Enable internal clock and configure SD clock prescaler */
    const uint16_t freq_sel = ((SDHC_CLOCK_CONTROL_SDCLK_FREQ_BASECLK_DIV_2 >> 1) << uVar4) & SDHC_CLOCK_CONTROL_SDCLK_FREQ_SELECT_Msk;
    sdif->ClockControl |= (SDHC_CLOCK_CONTROL_INTERNAL_CLOCK_ENABLE | freq_sel);

    int tries = 10;
    while (tries != 0) {
        if (sdif->ClockControl & SDHC_CLOCK_CONTROL_INTERNAL_CLOCK_STABLE) {
            /* Internal clock is stable - enable SD clock */
            sdif->ClockControl |= SDHC_CLOCK_CONTROL_SD_CLOCK_ENABLE;

            /* Configure high speed mode depending on caller's request */
            if (!enable_high_speed) {
                sdif->HostControl1 &= ~SDHC_HOST_CONTROL1_HIGH_SPEED_ENABLE;
            } else {
                sdif->HostControl1 |= SDHC_HOST_CONTROL1_HIGH_SPEED_ENABLE;
            }

            return 0;
        }

        tries--;
        delay(1000);
    }

    /* 0x80320002 */
    return -2144206846;
}

static uint32_t sdif_ack_regx14(unk_sdif_ctx_init *param_1, int bus_width) {
    /* This is 1:1 with 2BL implementation but not brom? End results are equivalent */
    uint8_t HC1 = param_1->sdif_regs_addr->HostControl1;

    if (bus_width == 8) {
        HC1 = (HC1 & ~SDHC_HOST_CONTROL1_DATA_TRANSFER_WIDTH_4BIT) | SDHC_HOST_CONTROL1_EXTENDED_DATA_WIDTH_ON;
    } else if (bus_width == 4) {
        HC1 = (HC1 & ~SDHC_HOST_CONTROL1_EXTENDED_DATA_WIDTH_ON) | SDHC_HOST_CONTROL1_DATA_TRANSFER_WIDTH_4BIT;
    } else {
        HC1 &= ~(SDHC_HOST_CONTROL1_EXTENDED_DATA_WIDTH_ON | SDHC_HOST_CONTROL1_DATA_TRANSFER_WIDTH_4BIT);
    }

    param_1->sdif_regs_addr->HostControl1 = HC1;
    return 0;
}

static int sdif_op0_arg1(unk_sdif_ctx_init *param_1) {
    int iVar1;
    sdif_arg_s local_38;

    local_38.some_arg1 = 1;
    local_38.dst_addr = 0;
    local_38.sector = 0;
    local_38.op_id = 0;
    local_38.this_size = 0x30;
    iVar1 = write_args_retry(param_1, &local_38, 0);
    if (-1 < iVar1) {
        sdif_work_reg16x16(param_1, 400000, 0);
        sdif_ack_regx14(param_1, 1);
        iVar1 = 0;
    }
    return iVar1;
}

static int sdif_loop_opx37_argx13_oparg(unk2_sdif_gigactx *gctx, sdif_arg_s *param_2, int param_3) {
    int iVar1;
    int unaff_r12;
    sdif_arg_s local_44;

    if (param_3 < 1) {
        param_3 = 1;
    }
    iVar1 = 0;
    if (0 < param_3) {
        do {
            local_44.op_id = 0x37;
            local_44.some_arg1 = 0x13;
            local_44.this_size = 0x30;
            local_44.dst_addr = 0;
            local_44.sector = (uint32_t)(gctx->sctx)->unk_half_id << 0x10;
            unaff_r12 = write_args_retry(gctx->sctx, &local_44, 0);
            if (-1 < unaff_r12) {
                if ((local_44.unk_4 & 0x20) == 0) {
                    return -0x7fcdfefb;
                }
                unaff_r12 = write_args_retry(gctx->sctx, param_2, 0);
                if (-1 < unaff_r12) {
                    return unaff_r12;
                }
            }
            iVar1 = iVar1 + 1;
        } while (iVar1 < param_3);
    }
    return unaff_r12;
}

static int sdif_loop_wopx37_opx29_argx42(unk2_sdif_gigactx *gctx, uint32_t param_2, uint32_t *param_3) {
    int iVar1;
    int iVar2;
    sdif_arg_s local_44;

    iVar2 = 0;
    local_44.dst_addr = 0;
    local_44.op_id = 0x29;
    local_44.some_arg1 = 0x42;
    local_44.this_size = 0x30;
    local_44.sector = param_2;
    while (true) {
        iVar1 = sdif_loop_opx37_argx13_oparg(gctx, &local_44, 3);
        if (iVar1 < 0) {
            return iVar1;
        }
        if ((param_2 == 0) || ((int)local_44.unk_4 < 0))
            break;
        delay(10000);
        iVar2 = iVar2 + 1;
        if (99 < iVar2) {
            return -0x7fcdfffe;
        }
    }
    if (param_3 != (uint32_t *)0x0) {
        *param_3 = local_44.unk_4;
    }
    return 0;
}

static int sdif_op2_argx32(unk_sdif_ctx_init *param_1, void *param_2) {
    int iVar1;
    sdif_arg_s local_38;

    local_38.op_id = 2;
    local_38.some_arg1 = 0x32;
    local_38.dst_addr = 0;
    local_38.sector = 0;
    local_38.this_size = 0x30;
    iVar1 = write_args_retry(param_1, &local_38, 3);
    if (-1 < iVar1) {
        memcpy(param_2, &local_38.unk_4, 0x10);
        iVar1 = 0;
    }
    return iVar1;
}

static int sdif_op3_argx82(unk2_sdif_gigactx *gctx, uint16_t *param_2) {
    int iVar1;
    sdif_arg_s local_38;

    local_38.sector = 0;
    local_38.op_id = 3;
    local_38.some_arg1 = 0x82;
    local_38.this_size = 0x30;
    iVar1 = write_args_retry(gctx->sctx, &local_38, 3);
    if (-1 < iVar1) {
        if (param_2 != (uint16_t *)0x0) {
            *param_2 = (local_38.unk_4 >> 0x10) & 0xffff;
        }
        iVar1 = 0;
    }
    return iVar1;
}

static int sdif_op7_argxy3(unk_sdif_ctx_init *param_1, int param_2) {
    int iVar1;
    sdif_arg_s local_34;

    local_34.this_size = 0x30;
    local_34.some_arg1 = 3;
    if (param_2 != 0) {
        local_34.some_arg1 = 0x13;
    }
    local_34.sector = 0;
    local_34.op_id = 7;
    if (param_2 != 0) {
        local_34.sector = (uint32_t)param_1->unk_half_id << 0x10;
    }
    iVar1 = write_args_retry(param_1, &local_34, 3);
    if (-1 < iVar1) {
        iVar1 = 0;
    }
    return iVar1;
}

static int sdif_op9_argx33(unk_sdif_ctx_init *param_1, void *param_2) {
    int iVar1;
    sdif_arg_s op;

    op.some_arg1 = 0x33;
    op.op_id = 9;
    op.this_size = 0x30;
    op.dst_addr = 0;
    op.sector = (uint32_t)param_1->unk_half_id << 0x10;
    iVar1 = write_args_retry(param_1, &op, 3);
    if (-1 < iVar1) {
        memcpy(param_2, &op.unk_4, 0x10);
        iVar1 = 0;
    }
    return iVar1;
}

static int sdif_opx10_argx13(unk_sdif_ctx_init *param_1, uint32_t param_2) {
    int iVar1;
    sdif_arg_s op;

    op.dst_addr = 0;
    op.op_id = 0x10;
    op.some_arg1 = 0x13;
    op.this_size = 0x30;
    op.sector = param_2;
    iVar1 = write_args_retry(param_1, &op, 3);
    if ((-1 < iVar1) && (iVar1 = parse_op_unk_4(op.unk_4), -1 < iVar1)) {
        iVar1 = 0;
    }
    return iVar1;
}

static uint32_t sdinit_lut0[8] = {0x2710, 0x186a0, 0xf4240, 0x989680, 0, 0, 0, 0};
static uint8_t sdinit_lut1[0x10] = {0x0, 0xA, 0xC, 0xD, 0xF, 0x14, 0x19, 0x1E, 0x23, 0x28, 0x2d, 0x32, 0x37, 0x3c, 0x46, 0x50};

int sdif_init_sd(unk2_sdif_gigactx *gctx) {
    int iret;
    uint32_t sdif_unk0;
    sdif_arg_s op;
    if ((!gctx) || (!gctx->sctx))
        return -2;
    iret = sdif_wait_card_present(gctx->sctx);
    if (iret < 0)
        return iret;
    if (!iret)
        return -0x7fcdffff;
    gctx->quirks = 0;
    if (gctx->op9_switchd) {  // already ran once, do reset?
        SceSdifReg *sdif = gctx->sctx->sdif_regs_addr;

        sdif->ClockControl = 0;
        sdif->HostControl1 = 0;
        sdif->PowerControl = 0;
        delay(10000);
    }
    iret = sdif_configure_bus(gctx->sctx);
    if (iret < 0)
        return iret;
    delay(10000);
    iret = sdif_pingwaitcfg_regs(gctx->sctx, 2);
    if (iret < 0)
        return iret;
    iret = sdif_op0_arg1(gctx->sctx);
    if (iret < 0)
        return iret;
    sdif_unk0 = gctx->sctx->unk_0;
    {  // sdif_op8_argx92
        memset(&op, 0, sizeof(sdif_arg_s));
        op.some_arg1 = 0x92;
        op.op_id = 8;
        op.this_size = 0x30;
        op.sector = 0xaa;
        if ((sdif_unk0 & 0xff8000) != 0) {
            op.sector = 0x1aa;
        }
        op.dst_addr = 0;
        iret = write_args_retry(gctx->sctx, &op, 3);
    }
    if (!iret)
        sdif_unk0 |= 0x40000000;
    gctx->sctx->unk_half_id = 0;
    iret = sdif_loop_wopx37_opx29_argx42(gctx, sdif_unk0, 0);
    if (iret < 0)
        return iret;

    uint8_t op2_argx32[0x10];
    memset(op2_argx32, 0, 0x10);
    iret = sdif_op2_argx32(gctx->sctx, op2_argx32);
    if (iret < 0)
        return iret;

    iret = sdif_op3_argx82(gctx, &gctx->sctx->unk_half_id);
    if (iret < 0)
        return iret;
    if ((!iret) && (iret = sdif_op3_argx82(gctx, &gctx->sctx->unk_half_id), iret < 0))
        return iret;
    iret = sdif_op7_argxy3(gctx->sctx, 1);
    if (iret < 0)
        return iret;
    {  // sdif_opx2a_argx13
        memset(&op, 0, sizeof(sdif_arg_s));
        op.op_id = 0x2a;
        op.some_arg1 = 0x13;
        op.sector = 0;
        op.this_size = 0x30;
        iret = sdif_loop_opx37_argx13_oparg(gctx, &op, 3);
        if ((-1 < iret) && (iret = parse_op_unk_4(op.unk_4), -1 < iret)) {
            iret = 0;
        }
    }
    if (iret < 0)
        return iret;
    sdif_op7_argxy3(gctx->sctx, 0);
    iret = sdif_op9_argx33(gctx->sctx, gctx->op9_argx33);
    if (iret < 0)
        return iret;
    iret = sdif_op7_argxy3(gctx->sctx, 1);
    if (iret < 0)
        return iret;

    uint32_t *tmptr = (uint32_t *)gctx->op9_argx33;
    int op9_2bx7e = (uint8_t)bitfield_extract((int)tmptr, 0x7e, 2);  // orig gigactx + 0x38
    iret = (int)bitfield_extract((int)tmptr, 99, 4);
    if (iret > 0xf)
        iret = 0;
    gctx->op9_lutd = (uint32_t)sdinit_lut1[iret] * sdinit_lut0[bitfield_extract((int)tmptr, 0x60, 3)];  // orig gigactx + 0x39
    if (op9_2bx7e == 1) {
        gctx->op9_switchd = (bitfield_extract((int)tmptr, 0x30, 22) + 1) * 0x400;  // orig gigactx + 0x3b
        gctx->quirks = gctx->quirks | 1;
    } else {
        if (op9_2bx7e)
            return -1;
        gctx->op9_switchd = ((int)bitfield_extract((int)tmptr, 0x3e, 12) + 1) << (((int)bitfield_extract((int)tmptr, 0x2f, 3) + 2) & 0x1f);
    }

    uint8_t opx33_argx114[0x200];
    memset(opx33_argx114, 0, 0x200);
    {  // sdif_opx33_argx114
        memset(&op, 0, sizeof(sdif_arg_s));
        op.sector_count = 0;
        op.sector = 0;
        op.op_id = 0x33;
        op.some_arg1 = 0x114;
        op.sector_size = 8;
        op.this_size = 0x30;
        op.dst_addr = (uint32_t)opx33_argx114;  // orig gigactx + 0x36;
        iret = sdif_loop_opx37_argx13_oparg(gctx, &op, 3);
        if (-1 < iret) {
            iret = 0;
        }
    }
    if (-1 < iret)
        return iret;

    iret = sdif_opx10_argx13(gctx->sctx, 0x200);
    if (-1 < iret)
        iret = 0;
    return iret;
}

static int sdif_op1_argx42(unk2_sdif_gigactx *gctx, uint32_t param_2, uint32_t *param_3) {
    int iVar1;
    int iVar2;
    sdif_arg_s op;

    iVar2 = 0;
    op.dst_addr = 0;
    op.op_id = 1;
    op.some_arg1 = 0x42;
    op.this_size = 0x30;
    op.sector = param_2;
    while (true) {
        iVar1 = write_args_retry(gctx->sctx, &op, 0);
        if (iVar1 < 0) {
            return iVar1;
        }
        if ((param_2 == 0) || ((int)op.unk_4 < 0))
            break;
        delay(10000);
        iVar2 = iVar2 + 1;
        if (99 < iVar2) {
            return -0x7fcdfffe;
        }
    }
    if (param_3 != (uint32_t *)0x0) {
        *param_3 = op.unk_4;
    }
    return 0;
}

static uint32_t *mmcinit_lut0 = sdinit_lut0;
static uint8_t mmcinit_lut1[0x10] = {0x0, 0xA, 0xC, 0xD, 0xF, 0x14, 0x1A, 0x1E, 0x23, 0x28, 0x2d, 0x34, 0x37, 0x3c, 0x46, 0x50};

// TODO: replicate a "-1" / failed init, left commented printf's for now
int sdif_init_mmc(unk2_sdif_gigactx *gctx) {
    int iret;
    sdif_arg_s op;
    if ((!gctx) || (!gctx->sctx))
        return -2;
    // printf("pre sdif_wait_reg16x12\n");
    iret = sdif_wait_card_present(gctx->sctx);
    if (iret < 0)
        return iret;
    if (!iret)
        return -1;
    gctx->quirks = 1;
    // printf("pre sdif_cfg_reg16x16\n");
    iret = sdif_configure_bus(gctx->sctx);
    if (iret < 0)
        return iret;
    // printf("pre sdif_op0_arg1\n");
    iret = sdif_op0_arg1(gctx->sctx);
    if (iret < 0)
        return iret;
    // printf("pre sdif_op1_argx42\n");
    iret = sdif_op1_argx42(gctx, gctx->sctx->unk_0 | 0x40000000, 0);
    if (iret < 0)
        return iret;

    uint8_t op2_argx32[0x10];
    memset(op2_argx32, 0, 0x10);
    // printf("pre sdif_op2_argx32\n");
    iret = sdif_op2_argx32(gctx->sctx, op2_argx32);
    if (iret < 0)
        return iret;

    {  // sdif_op3_argx13
        memset(&op, 0, sizeof(sdif_arg_s));
        op.op_id = 3;
        op.some_arg1 = 0x13;
        op.sector = 1 << 0x10;
        op.this_size = 0x30;
        // printf("pre write_args_retry [sdif_op3_argx13]\n");
        iret = write_args_retry(gctx->sctx, &op, 3);
        if ((-1 < iret) && (iret = parse_op_unk_4(op.unk_4), -1 < iret)) {
            iret = 0;
        }
    }
    if (iret < 0)
        return iret;
    gctx->sctx->unk_half_id = 1;
    // printf("pre sdif_op9_argx33\n");
    iret = sdif_op9_argx33(gctx->sctx, gctx->op9_argx33);
    if (iret < 0)
        return iret;

    uint32_t *tmptr = (uint32_t *)gctx->op9_argx33;
    iret = (int)bitfield_extract((int)tmptr, 99, 4);
    if (iret > 0xf)
        iret = 0;
    gctx->op9_lutd = (uint32_t)mmcinit_lut1[iret] * mmcinit_lut0[bitfield_extract((int)tmptr, 0x60, 3)];  // orig gigactx + 0xa9

    // printf("pre sdif_op7_argxy3\n");
    iret = sdif_op7_argxy3(gctx->sctx, 1);
    if (iret < 0)
        return iret;

    uint8_t buf[0x200];
    memset(buf, 0, 0x200);
    {  // sdif_op8_argx114
        memset(&op, 0, sizeof(sdif_arg_s));
        op.sector_count = 0;
        op.sector = 0;
        op.op_id = 8;
        op.some_arg1 = 0x114;
        op.sector_size = 0x200;
        op.this_size = 0x30;
        op.dst_addr = (uint32_t)buf;
        // printf("pre write_args_retry [sdif_op8_argx114]\n");
        iret = write_args_retry(gctx->sctx, &op, 3);
        if (-1 < iret) {
            iret = 0;
        }
    }
    if (iret < 0)
        return iret;

    switch (buf[0xc4] & 3) {
        case 1:
            gctx->op8_switchd = 26000000;
            break;
        case 2:
        case 3:
            gctx->op8_switchd = 52000000;
            break;
        default:
            gctx->op8_switchd = 0;
    }

    // printf("pre sdif_opx10_argx13\n");
    iret = sdif_opx10_argx13(gctx->sctx, 0x200);
    if (-1 < iret) {
        if (gctx->op8_switchd) {
            {  // sdif_op6_argx2b
                memset(&op, 0, sizeof(sdif_arg_s));
                op.some_arg1 = 0x2b;
                op.op_id = 6;
                op.this_size = 0x30;
                op.sector = ((1) & 0xff) << 8 | (((0xb9) & 0xff) << 0x10) | ((0) & 3) | 0x3000000;
                // printf("pre write_args_retry [sdif_op6_argx2b]\n");
                iret = write_args_retry(gctx->sctx, &op, 3);
                if (-1 < iret) {
                    iret = 0;
                }
            }
            if (iret < 0)
                return iret;
            // printf("pre sdif_work_reg16x16\n");
            iret = sdif_work_reg16x16(gctx->sctx, gctx->op9_lutd, 1);
        } else {
            // printf("pre sdif_work_reg16x16\n");
            iret = sdif_work_reg16x16(gctx->sctx, gctx->op8_switchd, 0);
        }
        if (-1 < iret)
            iret = 0;
    }
    return iret;
}
#endif

#undef CONCAT11
#undef CONCAT12
#undef CONCAT13

#endif