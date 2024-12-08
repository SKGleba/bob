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

#define SECTOR_SIZE (512)

/* SD Card-Specific Data structure layout */
#define CSD_STRUCTURE_OFFSET    126
#define CSD_STRUCTURE_SIZE      2

#define CSD_TAAC_VALUE_OFFSET   115
#define CSD_TAAC_VALUE_SIZE     4
#define CSD_TAAC_UNIT_OFFSET    112
#define CSD_TAAC_UNIT_SIZE      3

#define CSD_TRAN_SPEED_VALUE_OFFSET 99
#define CSD_TRAN_SPEED_VALUE_SIZE   4
#define CSD_TRAN_SPEED_UNIT_OFFSET  96
#define CSD_TRAN_SPEED_UNIT_SIZE    3

/* CSD Version 2.0-only definitions */
#define CSD_20_C_SIZE_OFFSET        48
#define CSD_20_C_SIZE_SIZE          22

/* CSD Version 1.0-only definitions */
#define CSD_10_C_SIZE_OFFSET        62
#define CSD_10_C_SIZE_SIZE          12
#define CSD_10_C_SIZE_MULT_OFFSET   47
#define CSD_10_C_SIZE_MULT_SIZE     3

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
    sdif_command_s *psVar1;
    uint32_t uVar2;
    uint16_t uVar4;
    uint32_t uVar5;
    int iVar6;
    sdif_command_s *psVar7;
    int iVar8;
    uint8_t *puVar9;
    uint32_t *puVar10;

    psVar1 = ctx->sdif_arg;
    if (psVar1 != NULL) {
        if (ctx->sdif_arg2 == NULL) {
            if (((param_2 & 2) != 0) && ((psVar1->cmd_settings & 8) != 0)) {
                psVar1->cmd_settings = psVar1->cmd_settings | 0x80000000;
            }
        } else if (param_3 == 0) {
            if ((((param_2 & 0x20) != 0) && ((psVar1->cmd_settings & 0x700) == 0x100)) && (0 < (int)psVar1->block_count)) {
                uVar2 = psVar1->dst_addr;

//                puVar3 = ctx->sdif_regs_addr;

                psVar1->block_count = psVar1->block_count - 1;

                /* Wait for readable data in controller buffer */
                while (!(sdif->PresentState & SDHC_PRESENT_STATE_BUFFER_READ_ENABLED))
                    ;

                iVar6 = 0;
                if (0 < (int)psVar1->block_size) {
                    do {
                        iVar8 = psVar1->block_size - iVar6;
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
                    } while (iVar6 < (int)psVar1->block_size);
                }
                psVar1->dst_addr = psVar1->dst_addr + psVar1->block_size;
            }
            if ((((param_2 & 0x10) != 0) && ((psVar1->cmd_settings & 0x700) == 0x200)) && (0 < (int)psVar1->block_count)) {
                uVar2 = psVar1->dst_addr;
//                puVar3 = ctx->sdif_regs_addr;
                psVar1->block_count = psVar1->block_count - 1;

                /* Wait for free space in controller write buffer */
                while (!(sdif->PresentState & SDHC_PRESENT_STATE_BUFFER_WRITE_ENABLED))
                    ;

                iVar6 = 0;
                if (0 < (int)psVar1->block_size) {
                    do {
                        iVar8 = psVar1->block_size - iVar6;
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
                    } while (iVar6 < (int)psVar1->block_size);
                }
                psVar1->dst_addr = psVar1->dst_addr + psVar1->block_size;
            }
            if ((param_2 & 2) != 0) {
                psVar7 = NULL;
                if ((int)v8p((int)&ctx->dev_id + 1) != 0x0) {

                    psVar1->cmd_settings = psVar1->cmd_settings | 0x80000000;
                }
                ctx->sdif_arg2 = psVar7;
            }
        } else {
            ctx->sdif_arg2 = NULL;
            psVar1->status = ((param_3 & 0x10) == 0) + 0x80320002;
            psVar1->cmd_settings = psVar1->cmd_settings | 0x40000000;
            sdif_cfgwait_regs16_x19nx1b(ctx, param_3);
        }
    }
    return;
}

static void sdif_prep_txarg(unk_sdif_ctx_init *param_1, sdif_command_s *param_2) {
    SceSdifReg *sdif = param_1->sdif_regs_addr;
    uint32_t uVar1;
    uint32_t uVar2;
    int iVar3;
    uint32_t uVar4;

    param_2->status = 0;
    uVar4 = param_2->cmd_settings & 0xf8;
    if (((((uVar4 == 0x90) || (uVar4 == 0x80)) || (uVar4 == 0x78)) || ((uVar4 == 0x60 || (uVar4 == 0x50)))) || (uVar4 == 0x40)) {
        param_2->Response[0] = sdif->Response[0];
    } else if (uVar4 == 0x30) {
        uVar4 = sdif->Response[0];
        uVar1 = sdif->Response[1];
        uVar2 = sdif->Response[2];
        iVar3 = sdif->Response[3];
        param_2->response[0] = uVar4 << 8;
        param_2->response[1] = uVar1 << 8 | uVar4 >> 0x18;
        param_2->response[2] = uVar2 << 8 | uVar1 >> 0x18;
        param_2->response[3] = iVar3 << 8 | uVar2 >> 0x18;
    } else if (((uVar4 == 0x28) || (uVar4 == 0x10)) && (param_2->response[0] = sdif->Response[0], (param_2->cmd_settings & 0x800) != 0)) {
        param_2->response[3] = sdif->Response[3];
    }

    if ((param_2->cmd_settings & 0x3000) != 0) {
        /* Reset command and data logic (including DMA) */
        sdif->SoftwareReset = (SDHC_SOFTWARE_RESET_DAT_LINE | SDHC_SOFTWARE_RESET_CMD_LINE);

        while (sdif->SoftwareReset & (SDHC_SOFTWARE_RESET_DAT_LINE | SDHC_SOFTWARE_RESET_CMD_LINE)) {
            /* Wait until reset is complete */
        }
    }
    return;
}

static void sdif_tx_maybe(unk_sdif_ctx_init *ctx, uint32_t param_2, uint32_t param_3) {
    sdif_command_s *psVar1;

    psVar1 = ctx->sdif_arg;
    if (psVar1 != NULL) {
        if (param_3 == 0) {
            if ((param_2 & 1) != 0) {
                v8p((int)&ctx->dev_id + 1) = 1;
                sdif_prep_txarg(ctx, psVar1);
                if ((ctx->sdif_arg2 == NULL) && ((psVar1->cmd_settings & 8) == 0)) {
                    psVar1->cmd_settings = psVar1->cmd_settings | 0x80000000;
                }
            }
        } else {
            psVar1->status = ((param_3 & 1) == 0) + 0x80320002;
            psVar1->cmd_settings = psVar1->cmd_settings | 0x40000000;
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

static uint32_t write_args(unk_sdif_ctx_init *ctx, sdif_command_s *op) {
    SceSdifReg *sdif = ctx->sdif_regs_addr;
    uint16_t transferMode;
    sdif_command_s *psVar2;
    uint16_t uVar3;
    uint32_t uVar4;

    op->status = 0;
    op->cmd_settings = op->cmd_settings & 0x3fffffff;
    v8p((int)&ctx->dev_id + 1) = 0;
    ctx->sdif_arg2 = NULL;
    ctx->sdif_arg = op;
    do {
        while (sdif->PresentState & SDHC_PRESENT_STATE_CMD_INHIBITED) {
            /* Wait until CMD line is not in use */
        }
    } while (
            /* Check that command doesn't need DAT lines, or wait until they are free */
            (op->cmd_index != 12) && 
            (
                (
                    (op->cmd_settings & 7) == 4 || 
                    ((op->cmd_settings & 0xf8) == 0x28)
                ) && (sdif->PresentState & SDHC_PRESENT_STATE_DAT_INHIBITED)
            )
        );

    uVar4 = op->cmd_settings & 0xf8;
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
    uVar4 = op->cmd_settings & 7;
    if (uVar4 == 4) {
        ctx->sdif_arg2 = op;

        sdif->TimeoutControl = SDHC_TIMEOUT_CONTROL_DATA_TIMEOUT_2_27;
        sdif->HostControl1 = (sdif->HostControl1 & ~SDHC_HOST_CONTROL1_DMA_SELECT_Msk) | SDHC_HOST_CONTROL1_DMA_SELECT_SDMA;

        sdif->BlockSize = SDHC_BLOCK_SIZE_HOST_SDMA_BOUNDARY_512K | (uint16_t)op->block_size;
        sdif->BlockCount = (uint16_t)op->block_count;

        if (op->cmd_settings & 0x100) {
            transferMode = SDHC_TRANSFER_MODE_DATA_DIRECTION_WRITE;
        } else {
            transferMode = SDHC_TRANSFER_MODE_DATA_DIRECTION_READ;
        }

        if ((op->cmd_settings & 0x800) != 0) {
            transferMode |= SDHC_TRANSFER_MODE_AUTO_CMD12_ENABLE;
        }

        if (op->block_count == 0) {
            op->block_count = 1;
        } else if (op->block_count == 1) {
            transferMode |= (SDHC_TRANSFER_MODE_BLOCK_COUNT_ENABLE | SDHC_TRANSFER_MODE_SINGLE_BLOCK);
        } else if (1 < (int)op->block_count) {
            transferMode = (SDHC_TRANSFER_MODE_BLOCK_COUNT_ENABLE | SDHC_TRANSFER_MODE_MULTI_BLOCK);
        }

        sdif->Argument1  = op->argument1;
        sdif->TransferMode = transferMode;

        /* Kickstart SDIF command */
        sdif->Command = (uint16_t)(op->cmd_index << SDHC_COMMAND_COMMAND_INDEX_Pos) | SDHC_COMMAND_DATA_PRESENT_YES | uVar3;
    } else if (((uVar4 == 3) || (uVar4 == 2)) || (uVar4 == 1)) {
        sdif->Argument1 = op->argument1;

        sdif->TransferMode = SDHC_TRANSFER_MODE_DATA_DIRECTION_READ;
        sdif->Command = (uint16_t)(op->cmd_index << SDHC_COMMAND_COMMAND_INDEX_Pos) | uVar3;
    }

    while ((op->cmd_settings & 0xc0000000) == 0) {
        if (sdif->NormalInterruptStatus || sdif->ErrorInterruptStatus) {
            sdif_trans_action((uint32_t) * (volatile uint8_t *)&ctx->dev_id, ctx);
        }
        delay(1000);
    }

    uVar4 = 0;
    psVar2 = NULL;
    if (op->cmd_settings & 0x40000000) {
        uVar4 = op->status;
    }
    ctx->sdif_arg = psVar2;
    return uVar4;
}

static int write_args_retry(unk_sdif_ctx_init *ctx, sdif_command_s *op, int retry_n) {
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
    sdif_command_s op;

    op.this_size = 0x30;
    op.cmd_settings = 0x3013;
    if (unk_arg1_0x302b != 0) {
        op.cmd_settings = 0x302b;
    }
    op.cmd_index = 0xc;
    op.argument1 = 0;
    iVar1 = write_args_retry(ctx, &op, 3);
    if (-1 < iVar1) {
        iVar1 = 0;
    }
    return iVar1;
}

static int R1_card_status_to_errcode(uint32_t card_status) {
    const uint32_t AKE_SEQ_ERROR = (1U << 3);
    const uint32_t ERASE_RESET = (1U << 13);
    const uint32_t CARD_ECC_DISABLED = (1U << 14);
    const uint32_t WP_ERASE_SKIP = (1U << 15);
    const uint32_t CSD_OVERWRITE = (1U << 16);
    const uint32_t rsvd_DEFERRED_RESPONSE = (1U << 17); /* Reserved for eSD */
    const uint32_t rsvd_18 = (1U << 18);                /* Reserved! */
    const uint32_t ERROR = (1U << 19);
    const uint32_t CC_ERROR = (1U << 20);
    const uint32_t CARD_ECC_FAILED = (1U << 21);
    const uint32_t ILLEGAL_COMMAND = (1U << 22);
    const uint32_t COM_CRC_ERROR = (1U << 23);
    const uint32_t LOCK_UNLOCK_FAILED = (1U << 24);
    const uint32_t WP_VIOLATION = (1U << 26);
    const uint32_t ERASE_PARAM = (1U << 27);
    const uint32_t ERASE_SEQ_ERROR = (1U << 28);
    const uint32_t BLOCK_LEN_ERROR = (1U << 29);
    const uint32_t ADDRESS_ERROR = (1U << 30);
    const uint32_t OUT_OF_RANGE = (1U << 31);

    const uint32_t ERRORS_MASK = (OUT_OF_RANGE | ADDRESS_ERROR | BLOCK_LEN_ERROR
        | ERASE_SEQ_ERROR | ERASE_PARAM | WP_VIOLATION | LOCK_UNLOCK_FAILED | COM_CRC_ERROR
        | ILLEGAL_COMMAND | CARD_ECC_FAILED | CC_ERROR | ERROR | rsvd_18 | rsvd_DEFERRED_RESPONSE
        | CSD_OVERWRITE | WP_ERASE_SKIP | CARD_ECC_DISABLED | ERASE_RESET | AKE_SEQ_ERROR);

    if ((card_status & ERRORS_MASK) == 0) {
        return 0;
    }

    int i = 0;
    while (i < 32) {
        if ((card_status & ERRORS_MASK) & (1 << i)) {
            break;
        }
        i++;
    }

    /* 0x80320100 + i */
    return i - 2144206592;
}

static int do_op_0x17(unk_sdif_ctx_init *ctx, uint32_t unk_sector_arg) {
    int iVar1;
    sdif_command_s local_34;

    local_34.dst_addr = 0;
    local_34.cmd_index = 0x17;
    local_34.cmd_settings = 0x13;
    local_34.this_size = 0x30;
    local_34.argument1 = unk_sector_arg;
    iVar1 = write_args_retry(ctx, &local_34, 3);
    if ((-1 < iVar1) && (iVar1 = R1_card_status_to_errcode(local_34.response[0]), -1 < iVar1)) {
        iVar1 = 0;
    }
    return iVar1;
}

static int sdif_do_op_0xd(unk_sdif_ctx_init *ctx, uint32_t *p_response) {
    int iret;
    sdif_command_s op;

    op.cmd_settings = 0x13;
    op.cmd_index = 0xd;
    op.this_size = 0x30;
    op.dst_addr = 0;
    op.argument1 = (uint32_t)ctx->unk_half_id << 0x10;
    iret = write_args_retry(ctx, &op, 3);
    if (-1 < iret) {
        if (p_response != NULL) {
            *p_response = op.reponse[0];
        }
        iret = R1_card_status_to_errcode(op.response[0]);
        if (-1 < iret) {
            iret = 0;
        }
    }
    return iret;
}

int sdif_read_sector_sd(unk2_sdif_gigactx *gctx, uint32_t sector, uint32_t dst, uint32_t nsectors) {
    int iret;
    sdif_command_s op;

    op.this_size = 0x30;
    if (nsectors == 1) {
        op.cmd_index = 0x11;
        op.cmd_settings = 0x114;
    } else {
        op.cmd_settings = 0x914;
        op.cmd_index = 0x12;
    }
    op.argument1 = sector;
    if (!(gctx->quirks & 1))
        op.argument1 = sector * SECTOR_SIZE;
    op.block_size = 0x200;
    op.dst_addr = dst;
    op.block_count = nsectors;
    iret = write_args_retry(gctx->sctx, &op, 0);
    if (iret < 0) {
        if (op.cmd_index == 0x12) {
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
    sdif_command_s op;

    op.this_size = 0x30;
    if (nsectors == 1) {
        op.cmd_index = 0x18;
        op.cmd_settings = 0x214;
    } else {
        op.cmd_settings = 0xa14;
        op.cmd_index = 0x19;
    }
    op.argument1 = sector;
    if (!(gctx->quirks & 1))
        op.argument1 = sector  * SECTOR_SIZE;
    op.block_size = 0x200;
    op.dst_addr = dst;
    op.block_count = nsectors;
    iret = write_args_retry(gctx->sctx, &op, 0);
    if (iret < 0) {
        if (op.cmd_index == 0x19) {
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
    sdif_command_s op;

    op.cmd_settings = 0x114;
    op.this_size = 0x30;
    op.cmd_index = (nsectors != 1) + 0x11;
    op.argument1 = sector;
    if (!(gctx->quirks & 1))
        op.argument1 = sector * SECTOR_SIZE;
    op.block_size = 0x200;
    op.dst_addr = dst;
    op.block_count = nsectors;
    if ((op.cmd_index != 0x12) || (iret = do_op_0x17(gctx->sctx, nsectors), -1 < iret)) {
        iret = write_args_retry(gctx->sctx, &op, 0);
        if (iret < 0) {
            if ((((op.cmd_index == 0x12) && (iret != -0x7fcdfee3)) && (iret != -0x7fcdfee2)) && (iret != -0x7fcdfee1)) {
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
    sdif_command_s op;

    op.cmd_settings = 0x214;
    op.this_size = 0x30;
    op.cmd_index = (nsectors != 1) + 0x18;
    op.argument1 = sector;
    if (!(gctx->quirks & 1))
        op.argument1 = sector * SECTOR_SIZE;
    op.block_size = 0x200;
    op.dst_addr = dst;
    op.block_count = nsectors;
    if ((op.cmd_index != 0x19) || (iret = do_op_0x17(gctx->sctx, nsectors), -1 < iret)) {
        iret = write_args_retry(gctx->sctx, &op, 0);
        if (iret < 0) {
            if ((((op.cmd_index == 0x12) && (iret != -0x7fcdfee3)) && (iret != -0x7fcdfee2)) && (iret != -0x7fcdfee1)) {
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

static uint32_t bitfield_extract(void *ptr, uint32_t start_bit, uint32_t numbits) {
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
    sdif_command_s local_38;

    local_38.cmd_settings = 1;
    local_38.dst_addr = 0;
    local_38.argument1 = 0;
    local_38.cmd_index = 0;
    local_38.this_size = 0x30;
    iVar1 = write_args_retry(param_1, &local_38, 0);
    if (-1 < iVar1) {
        sdif_work_reg16x16(param_1, 400000, 0);
        sdif_ack_regx14(param_1, 1);
        iVar1 = 0;
    }
    return iVar1;
}

static int sdif_loop_opx37_argx13_oparg(unk2_sdif_gigactx *gctx, sdif_command_s *param_2, int param_3) {
    int iVar1;
    int unaff_r12;
    sdif_command_s local_44;

    if (param_3 < 1) {
        param_3 = 1;
    }
    iVar1 = 0;
    if (0 < param_3) {
        do {
            local_44.cmd_index = 0x37;
            local_44.cmd_settings = 0x13;
            local_44.this_size = 0x30;
            local_44.dst_addr = 0;
            local_44.argument1 = (uint32_t)(gctx->sctx)->unk_half_id << 0x10;
            unaff_r12 = write_args_retry(gctx->sctx, &local_44, 0);
            if (-1 < unaff_r12) {
                if ((local_44.response[0] & 0x20) == 0) {
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
    sdif_command_s local_44;

    iVar2 = 0;
    local_44.dst_addr = 0;
    local_44.cmd_index = 0x29;
    local_44.cmd_settings = 0x42;
    local_44.this_size = 0x30;
    local_44.argument1 = param_2;
    while (true) {
        iVar1 = sdif_loop_opx37_argx13_oparg(gctx, &local_44, 3);
        if (iVar1 < 0) {
            return iVar1;
        }
        if ((param_2 == 0) || ((int)local_44.response[0] < 0))
            break;
        delay(10000);
        iVar2 = iVar2 + 1;
        if (99 < iVar2) {
            return -0x7fcdfffe;
        }
    }
    if (param_3 != (uint32_t *)0x0) {
        *param_3 = local_44.response[0];
    }
    return 0;
}

static int sdif_op2_argx32(unk_sdif_ctx_init *param_1, void *param_2) {
    int iVar1;
    sdif_command_s local_38;

    local_38.cmd_index = 2;
    local_38.cmd_settings = 0x32;
    local_38.dst_addr = 0;
    local_38.argument1 = 0;
    local_38.this_size = 0x30;
    iVar1 = write_args_retry(param_1, &local_38, 3);
    if (-1 < iVar1) {
        memcpy(param_2, local_38.response, sizeof(local_38.response));
        iVar1 = 0;
    }
    return iVar1;
}

static int sdif_op3_argx82(unk2_sdif_gigactx *gctx, uint16_t *param_2) {
    int iVar1;
    sdif_command_s local_38;

    local_38.argument1 = 0;
    local_38.cmd_index = 3;
    local_38.cmd_settings = 0x82;
    local_38.this_size = 0x30;
    iVar1 = write_args_retry(gctx->sctx, &local_38, 3);
    if (-1 < iVar1) {
        if (param_2 != (uint16_t *)0x0) {
            *param_2 = (local_38.response[0] >> 0x10) & 0xffff;
        }
        iVar1 = 0;
    }
    return iVar1;
}

static int sdif_op7_argxy3(unk_sdif_ctx_init *param_1, int param_2) {
    int iVar1;
    sdif_command_s local_34;

    local_34.this_size = 0x30;
    local_34.cmd_settings = 3;
    if (param_2 != 0) {
        local_34.cmd_settings = 0x13;
    }
    local_34.argument1 = 0;
    local_34.cmd_index = 7;
    if (param_2 != 0) {
        local_34.argument1 = (uint32_t)param_1->unk_half_id << 0x10;
    }
    iVar1 = write_args_retry(param_1, &local_34, 3);
    if (-1 < iVar1) {
        iVar1 = 0;
    }
    return iVar1;
}

static int sdif_op9_argx33(unk_sdif_ctx_init *param_1, void *param_2) {
    int iVar1;
    sdif_command_s op;

    op.cmd_settings = 0x33;
    op.cmd_index = 9;
    op.this_size = 0x30;
    op.dst_addr = 0;
    op.argument1 = (uint32_t)param_1->unk_half_id << 0x10;
    iVar1 = write_args_retry(param_1, &op, 3);
    if (-1 < iVar1) {
        memcpy(param_2, op.response, sizeof(op.response));
        iVar1 = 0;
    }
    return iVar1;
}

static int sdif_opx10_argx13(unk_sdif_ctx_init *param_1, uint32_t param_2) {
    int iVar1;
    sdif_command_s op;

    op.dst_addr = 0;
    op.cmd_index = 0x10;
    op.cmd_settings = 0x13;
    op.this_size = 0x30;
    op.argument1 = param_2;
    iVar1 = write_args_retry(param_1, &op, 3);
    if ((-1 < iVar1) && (iVar1 = R1_card_status_to_errcode(op.response[0]), -1 < iVar1)) {
        iVar1 = 0;
    }
    return iVar1;
}

/**
 * TRAN_SPEED unit and time value look-up tables
 * 
 * N.B.: to remove the need for floating point arithmetic, values in the
 * time value LUT are pre-multiplied by 10, and values in the unit LUT are
 * pre-divided by 10 to compensate.
 */
static const uint32_t CSD_TRAN_SPEED_unit_LUT[] = {
    10000,      /* 100 Kbit/s */
    100000,     /* 1   Mbit/s */
    1000000,    /* 10  Mbit/s */
    10000000,   /* 100 Mbit/s */
    0, 0, 0, 0  /* Reserved */
};

static const uint8_t CSD_TRAN_SPEED_value_LUT[] = {
    0, 10, 12, 13, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 70, 80
};

int sdif_init_sd(unk2_sdif_gigactx *gctx) {
    int iret;
    uint32_t sdif_unk0;
    sdif_command_s op;
    if ((!gctx) || (!gctx->sctx))
        return -2;
    iret = sdif_wait_card_present(gctx->sctx);
    if (iret < 0)
        return iret;
    if (!iret)
        return -0x7fcdffff;
    gctx->quirks = 0;
    if (gctx->gcsdCardSizeInBlocks) {  // already ran once, do reset?
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
        memset(&op, 0, sizeof(op));
        op.cmd_settings = 0x92;
        op.cmd_index = 8;
        op.this_size = 0x30;
        op.argument1 = 0xaa;
        if ((sdif_unk0 & 0xff8000) != 0) {
            op.argument1 = 0x1aa;
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
        memset(&op, 0, sizeof(op));
        op.cmd_index = 0x2a;
        op.cmd_settings = 0x13;
        op.argument1 = 0;
        op.this_size = 0x30;
        iret = sdif_loop_opx37_argx13_oparg(gctx, &op, 3);
        if ((-1 < iret) && (iret = R1_card_status_to_errcode(op.response[0]), -1 < iret)) {
            iret = 0;
        }
    }
    if (iret < 0)
        return iret;
    sdif_op7_argxy3(gctx->sctx, 0);
    iret = sdif_op9_argx33(gctx->sctx, gctx->cardSpecificData);
    if (iret < 0)
        return iret;

    iret = sdif_op7_argxy3(gctx->sctx, 1);
    if (iret < 0)
        return iret;

    // orig gigactx + 0x38
    int csd_structure_version = (uint8_t)bitfield_extract(gctx->cardSpecificData, CSD_STRUCTURE_OFFSET, CSD_STRUCTURE_SIZE);
    {
        int tran_speed_val = (int)bitfield_extract(gctx->cardSpecificData, CSD_TRAN_SPEED_VALUE_OFFSET, CSD_TRAN_SPEED_VALUE_SIZE);
        if (tran_speed_val > 0xf)
            tran_speed_val = 0;

        int tran_speed_unit = (int)bitfield_extract(gctx->cardSpecificData, CSD_TRAN_SPEED_UNIT_OFFSET, CSD_TRAN_SPEED_UNIT_SIZE);

        // orig gigactx + 0x39
        gctx->maxTransferSpeed = (uint32_t)CSD_TRAN_SPEED_value_LUT[tran_speed_val] * CSD_TRAN_SPEED_unit_LUT[tran_speed_unit];
    }

    if (csd_structure_version == 1) { //CSD Version 2.0
        /**
         * memory capacity = (C_SIZE + 1) * 512Kbytes, BLOCKNR = memory capacity / SECTOR_SIZE
         * ==> BLOCKNR = (C_SIZE + 1) * (512 * 1024) / 512 = (C_SIZE + 1) * 1024 
         */
        // orig gigactx + 0x3b
        gctx->gcsdCardSizeInBlocks = (bitfield_extract(gctx->cardSpecificData, CSD_20_C_SIZE_OFFSET, CSD_20_C_SIZE_SIZE) + 1) * 1024;

        /* SDHC/SDXC use sector-based addressing */
        gctx->quirks = gctx->quirks | 1;
    } else if (csd_structure_version == 0) { //CSD Version 1.0
        /**
         * MULT = 2^(C_SIZE_MULT + 2)
         * BLOCKNR = (C_SIZE + 1) * MULT
         */
        uint32_t C_SIZE = bitfield_extract(gctx->cardSpecificData, CSD_10_C_SIZE_OFFSET, CSD_10_C_SIZE_SIZE);
        uint32_t C_SIZE_MULT = bitfield_extract(gctx->cardSpecificData, CSD_10_C_SIZE_MULT_OFFSET, CSD_10_C_SIZE_MULT_SIZE);

        gctx->gcsdCardSizeInBlocks = (C_SIZE + 1) << (2 + C_SIZE_MULT);
    } else { // unknown CSD version
            return -1;
    }

    uint8_t opx33_argx114[0x200];
    memset(opx33_argx114, 0, 0x200);
    {  // sdif_opx33_argx114
        memset(&op, 0, sizeof(op));
        op.block_count = 0;
        op.argument1 = 0;
        op.cmd_index = 0x33;
        op.cmd_settings = 0x114;
        op.block_size = 8;
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
    sdif_command_s op;

    iVar2 = 0;
    op.dst_addr = 0;
    op.cmd_index = 1;
    op.cmd_settings = 0x42;
    op.this_size = 0x30;
    op.argument1 = param_2;
    while (true) {
        iVar1 = write_args_retry(gctx->sctx, &op, 0);
        if (iVar1 < 0) {
            return iVar1;
        }
        if ((param_2 == 0) || ((int)op.response[0] < 0))
            break;
        delay(10000);
        iVar2 = iVar2 + 1;
        if (99 < iVar2) {
            return -0x7fcdfffe;
        }
    }
    if (param_3 != (uint32_t *)0x0) {
        *param_3 = op.response[0];
    }
    return 0;
}

// TODO: replicate a "-1" / failed init, left commented printf's for now
int sdif_init_mmc(unk2_sdif_gigactx *gctx) {
    int iret;
    sdif_command_s op;
    if ((!gctx) || (!gctx->sctx))
        return -2;
    // printf("pre sdif_wait_reg16x12\n");
    iret = sdif_wait_card_present(gctx->sctx);
    if (iret < 0)
        return iret;

    if (!iret) /* device not present */
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
        memset(&op, 0, sizeof(op));
        op.cmd_index = 3;
        op.cmd_settings = 0x13;
        op.argument1 = 1 << 0x10;
        op.this_size = 0x30;
        // printf("pre write_args_retry [sdif_op3_argx13]\n");
        iret = write_args_retry(gctx->sctx, &op, 3);
        if ((-1 < iret) && (iret = R1_card_status_to_errcode(op.response[0]), -1 < iret)) {
            iret = 0;
        }
    }
    if (iret < 0)
        return iret;

    gctx->sctx->unk_half_id = 1;
    // printf("pre sdif_op9_argx33\n");
    iret = sdif_op9_argx33(gctx->sctx, gctx->cardSpecificData);
    if (iret < 0)
        return iret;

    {
        int tran_speed_val = (int)bitfield_extract(gctx->cardSpecificData, CSD_TRAN_SPEED_VALUE_OFFSET, CSD_TRAN_SPEED_VALUE_SIZE);
        if (tran_speed_val > 0xf)
            tran_speed_val = 0;

        int tran_speed_unit = (int)bitfield_extract(gctx->cardSpecificData, CSD_TRAN_SPEED_UNIT_OFFSET, CSD_TRAN_SPEED_UNIT_SIZE);

        // orig gigactx + 0xa9
        gctx->maxTransferSpeed = (uint32_t)CSD_TRAN_SPEED_value_LUT[tran_speed_val] * CSD_TRAN_SPEED_unit_LUT[trans_speed_unit];
    }

    // printf("pre sdif_op7_argxy3\n");
    iret = sdif_op7_argxy3(gctx->sctx, 1);
    if (iret < 0)
        return iret;

    uint8_t buf[0x200];
    memset(buf, 0, 0x200);
    {  // sdif_op8_argx114
        memset(&op, 0, sizeof(op));
        op.block_count = 0;
        op.argument1 = 0;
        op.cmd_index = 8;
        op.cmd_settings = 0x114;
        op.block_size = 0x200;
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
                memset(&op, 0, sizeof(op));
                op.cmd_settings = 0x2b;
                op.cmd_index = 6;
                op.this_size = 0x30;
                op.argument1 = ((1) & 0xff) << 8 | (((0xb9) & 0xff) << 0x10) | ((0) & 3) | 0x3000000;
                // printf("pre write_args_retry [sdif_op6_argx2b]\n");
                iret = write_args_retry(gctx->sctx, &op, 3);
                if (-1 < iret) {
                    iret = 0;
                }
            }
            if (iret < 0)
                return iret;
            // printf("pre sdif_work_reg16x16\n");
            iret = sdif_work_reg16x16(gctx->sctx, gctx->maxTransferSpeed, 1);
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