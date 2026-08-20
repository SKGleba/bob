#include "include/alice.h"

#include <hardware/paddr.h>
#include <hardware/xbar.h>

#include "include/clib.h"
#include "include/compat.h"
#include "include/debug.h"
#include "include/defs.h"
#include "include/maika.h"
#include "include/perv.h"
#include "include/rpc.h"
#include "include/types.h"
#include "include/utils.h"
#include "include/stor.h"

#ifndef ALICE_UNUSE

volatile alice_vector_s* alice_vectors = NULL;
volatile alice_xcfg_s* alice_xcfg = NULL;
volatile alice_core_task_s* (* volatile alice_tasks)[4] = NULL;
volatile int(*alice_core_status)[4] = NULL;
volatile uint32_t alice_b2a_shmem = ALICE_B2A_SHBUF;

// temp
int alice_get_task_status(int core, bool ret, bool actual_core_task) {
    volatile alice_core_task_s* task = NULL;
    if (actual_core_task) {
        if (!alice_tasks || (task = (*alice_tasks)[core], !task))
            return -1;
    } else
        task = (alice_core_task_s*)(alice_b2a_shmem + (core * sizeof(alice_core_task_s)));

    if (ret)
        return task->ret;
    return task->status;
}

// temp wrapper for alice_schedule_task with static buf per alice core
int alice_schedule_bob_task(int core, int task_id, bool wait_core_done, bool wait_task_done, int a0, int a1, int a2, int a3) {
    volatile alice_core_task_s* task = (volatile alice_core_task_s*)(alice_b2a_shmem + (core * sizeof(alice_core_task_s)));
    memset((void*)task, 0, sizeof(alice_core_task_s));
    task->task_id = task_id;
    task->args[0] = a0;
    task->args[1] = a1;
    task->args[2] = a2;
    task->args[3] = a3;
    return alice_schedule_task(core, task, wait_core_done, wait_task_done);
}

int alice_loadAlice(void* src, bool start, int arm_clock, bool set_ints, bool enable_cs, bool dram, bool set_uart) {
    void* dst = (void*)(dram ? ALICE_DRAM_ADDR : ALICE_SPAD32K_ADDR);
    uint32_t sz = dram ? ALICE_DRAM_SIZE : ALICE_SPAD32K_SIZE;
    
    if (src != dst) {
        INFOF("[BOB] copy alice to %X[%X]\n", (uint32_t)dst, sz);
        memset32(dst, 0, sz);
        if (vp(dst)) {
            ERROR("[BOB] failed to clear dst area\n");
            return -1;
        }
        memcpy(dst, src, sz);
    }
    
    alice_vectors = dst;
    alice_xcfg = (alice_xcfg_s*)((uint32_t)dst + (uint32_t)(alice_vectors->configs.xcfg));
    alice_core_status = (int(*)[4])((uint32_t)dst + (uint32_t)(alice_vectors->configs.core_status));
    alice_tasks = (volatile alice_core_task_s * (* volatile)[4])((uint32_t)dst + (uint32_t)(alice_vectors->configs.core_tasks));

    if (set_uart) {
        INFOF("[BOB] set alice uart to %X[%X]\n", g_uart_bus, UART_RATE);
        alice_xcfg->uart_bus = g_uart_bus;
        alice_xcfg->uart_rate = UART_RATE;
    }

    if (set_ints) {
        // cleanup
        maika_s* maika = (maika_s*)MAIKA_OFFSET;
        maika->mailbox.arm2cry[0] = -1;
        maika->mailbox.arm2cry[1] = -1;
        maika->mailbox.arm2cry[2] = -1;
        maika->mailbox.arm2cry[3] = -1;
        maika->mailbox.cry2arm_inv[0] = -1;
        maika->mailbox.cry2arm_inv[1] = -1;
        maika->mailbox.cry2arm_inv[2] = -1;
        maika->mailbox.cry2arm_inv[3] = -1;
        setup_ints(); // actually enable mailbox ifs & irqs - on soc v<3.2 this can retrigger irqs
        _MEP_INTR_ENABLE_
    }

    if (start)
        compat_armReBoot(arm_clock, enable_cs, dram);

    INFO("[BOB] alice loaded\n");

    return 0;
}

// TODO: flag setup ints
int alice_stopReloadAlice(uint32_t reload_config, uint8_t *cefw_status) {
    if (!reload_config)
        reload_config = (((vp PERV2_ARM_BOOT_ALIAS_DRAM) ? ALICE_DRAM_ADDR : ALICE_SPAD32K_ADDR) << 1) | ((vp PERV2_ARM_BOOT_ALIAS_DRAM) ? ALICE_RELOAD_USE_DRAM : 0);

    INFO("[BOB] killing arm...\n");
    compat_killArm(false);

    if (cefw_status)
        *cefw_status = 0xA2;

    return alice_loadAlice((void *)((reload_config & ALICE_RELOAD_SOURCE) >> 1), true, vp(PERV_GET_REG(PERV_CTRL_BASECLK, 0)) & 0xf, true,
                           !!(reload_config & ALICE_RELOAD_ENABLE_CS), !!(reload_config & ALICE_RELOAD_USE_DRAM), !!(reload_config & ALICE_RELOAD_SET_UART));
}

int alice_schedule_task(int target_core, volatile alice_core_task_s* task, bool wait_core_done, bool wait_task_done) {
    if (!alice_core_status || !alice_tasks) {
        if (!alice_vectors)
            alice_loadAlice((void*)((vp PERV2_ARM_BOOT_ALIAS_DRAM) ? ALICE_DRAM_ADDR : ALICE_SPAD32K_ADDR), false, 0, false, false, (bool)(vp PERV2_ARM_BOOT_ALIAS_DRAM), false);
        else
            return -1;
    }

    if ((*alice_core_status)[target_core] & ALICE_CORE_STATUS_TASKING) {
        if (!wait_core_done)
            return -2;
        while ((*alice_core_status)[target_core] & ALICE_CORE_STATUS_TASKING)
            ;
    }

    task->status = 0;
    (*alice_tasks)[target_core] = task;

    if (!wait_task_done)
        return 0;

    do {
        if (task->status & ALICE_CORE_TASK_STATUS_FAILED)
            break;
    } while (!(task->status & ALICE_CORE_TASK_STATUS_DONE));

    return task->ret;
}

uint32_t alice_handleCmd(uint32_t cmdep) {
    volatile struct _alice_a2b_cmd_s* cmds = (volatile struct _alice_a2b_cmd_s*)(cmdep & 0x7FFFFFFC);
    if (cmdep & 1) // in second half
        cmds = (volatile struct _alice_a2b_cmd_s*)((uint32_t)cmds | 0x80000000);
    
    uint32_t cmd = cmds->cmd;
    if (cmd & 0x80000000) { // actually its a func addr
        uint32_t (*exec_func)(uint32_t a, uint32_t b, uint32_t c) = (void*)(cmd & 0xFFFFFFFE);
        if (!(cmd & 1))
            exec_func = (void*)((uint32_t)exec_func & 0x7FFFFFFE);
        INFOF("[BOB] exec %X(%X, %X, %X)\n", exec_func, cmds->arg[0], cmds->arg[1], cmds->arg[2]);
        cmds->ret = exec_func(cmds->arg[0], cmds->arg[1], cmds->arg[2]);
        return (uint32_t)cmdep;
    }

    INFOF("[BOB] got alice cmd %X (%X, %X, %X)\n", cmd, cmds->arg[0], cmds->arg[1], cmds->arg[2]);
    switch (cmd) {
    case ALICE_A2B_GET_RPC_STATUS:
        cmds->ret = g_rpc_status;
        break;
    case ALICE_A2B_SET_RPC_STATUS:
        g_rpc_status = cmds->arg[0];
        break;
    case ALICE_A2B_MASK_RPC_STATUS:
        if (cmds->arg[1])
            g_rpc_status |= (cmds->arg[0]);
        else
            g_rpc_status &= ~(cmds->arg[0]);
        cmds->ret = g_rpc_status;
        break;
    case ALICE_A2B_REBOOT:
        compat_armReBoot(cmds->arg[0], cmds->arg[1], cmds->arg[2]);
        break;
    case ALICE_A2B_MEMCPY:
        cmds->ret = (int)memcpy((void*)cmds->arg[0], (void*)cmds->arg[1], cmds->arg[2]);
        break;
    case ALICE_A2B_MEMSET:
        cmds->ret = (int)memset((void*)cmds->arg[0], (cmds->arg[1] & 0xFF), cmds->arg[2]);
        break;
    case ALICE_A2B_MEMSET32:
        cmds->ret = (int)memset32((void*)cmds->arg[0], cmds->arg[1], cmds->arg[2]);
        break;
    case ALICE_A2B_READ32:
        if ((int)cmds->arg[2] < 0)
            cmds->ret = (int)readAs(cmds->arg[0], cmds->arg[2] & 0x7fffffff);
        else
            cmds->ret = (int)vp cmds->arg[0];
        break;
    case ALICE_A2B_WRITE32:
        if ((int)cmds->arg[2] < 0)
            writeAs(cmds->arg[0], cmds->arg[1], cmds->arg[2] & 0x7fffffff);
        else
            vp cmds->arg[0] = cmds->arg[1];
        break;
    case ALICE_A2B_STOP_RELOAD_ALICE:
        alice_stopReloadAlice(cmds->arg[0], NULL);
        break;
    case ALICE_A2B_INIT_STORAGE:
        if (cmds->arg[0])
            cmds->ret = stor_init_emmc(cmds->arg[1], cmds->arg[2]);
        else
            cmds->ret = stor_init_sd(cmds->arg[1]);
        break;
    case ALICE_A2B_READ_SD:
        cmds->ret = stor_read_sd(cmds->arg[0], (void*)cmds->arg[1], cmds->arg[2]);
        break;
    case ALICE_A2B_WRITE_SD:
        cmds->ret = stor_write_sd(cmds->arg[0], (void*)cmds->arg[1], cmds->arg[2]);
        break;
    case ALICE_A2B_READ_EMMC:
        cmds->ret = stor_read_emmc(cmds->arg[0], (void*)cmds->arg[1], cmds->arg[2]);
        break;
    case ALICE_A2B_WRITE_EMMC:
        cmds->ret = stor_write_emmc(cmds->arg[0], (void*)cmds->arg[1], cmds->arg[2]);
        break;
    case ALICE_A2B_EXPORT_SDIF_CTX:
        cmds->ret = stor_export_ctx(cmds->arg[0], (unk2_sdif_gigactx*)cmds->arg[1], (unk_sdif_ctx_init*)cmds->arg[2]);
        break;
    case ALICE_A2B_IMPORT_SDIF_CTX:
        cmds->ret = stor_import_ctx(cmds->arg[0], (unk2_sdif_gigactx*)cmds->arg[1], (unk_sdif_ctx_init*)cmds->arg[2]);
        break;
    case ALICE_A2B_SET_B2A_SHBUF:
        if (cmds->arg[1] < ALICE_B2A_SHBUF_MINSIZE) {
            ERRORF("[BOB] alice cmd set_b2a_shbuf: invalid size %X\n", cmds->arg[1]);
            cmds->ret = -1;
            break;
        }
        cmds->arg[1] = alice_b2a_shmem;
        alice_b2a_shmem = cmds->arg[0];
        cmds->ret = 0;
        break;
    case ALICE_A2B_MGR_INTR:
        cmds->ret = intr_mask(cmds->arg[0], (bool)cmds->arg[1], (bool)cmds->arg[2]);
        break;
    case ALICE_A2B_SET_LOGLEVEL:
        cmds->ret = g_debug_level;
        g_debug_level = cmds->arg[0];
        break;
    case ALICE_A2B_SET_LOGROUTE:
        cmds->ret = g_debug_route;
        g_debug_route = cmds->arg[0];
        break;
    default:
        cmds->ret = stub();
        break;
    }

    INFOF("[BOB] alice cmd %X done, ret %X\n", cmd, cmds->ret);

    return (uint32_t)cmdep;
}

#else

int alice_stopReloadAlice(uint32_t reload_config) {
    return stub();
}

#endif