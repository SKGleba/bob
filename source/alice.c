#include "include/types.h"
#include "include/defs.h"
#include "include/utils.h"
#include "include/debug.h"
#include "include/paddr.h"
#include "include/maika.h"
#include "include/perv.h"
#include "include/rpc.h"
#include "include/clib.h"
#include "include/compat.h"

#include "include/alice.h"

volatile alice_vector_s* alice_vectors = NULL;
volatile alice_xcfg_s* alice_xcfg = NULL;
volatile alice_core_task_s* (* volatile alice_tasks)[4] = NULL;
volatile int(*alice_core_status)[4] = NULL;

// temp, TODO: not this lol
#define ALICE_BOB_TASKS_SHBUF 0x1f85ff80 

// temp
int alice_get_task_status(int core, bool ret, bool actual_core_task) {
    volatile alice_core_task_s* task = NULL;
    if (actual_core_task) {
        if (!alice_tasks || (task = (*alice_tasks)[core], !task))
            return -1;
    } else
        task = (alice_core_task_s*)(ALICE_BOB_TASKS_SHBUF + (core * sizeof(alice_core_task_s)));

    if (ret)
        return task->ret;
    return task->status;
}

// temp wrapper for alice_schedule_task with static buf per alice core
int alice_schedule_bob_task(int core, int task_id, bool wait_core_done, bool wait_task_done, int a0, int a1, int a2, int a3) {
    volatile alice_core_task_s* task = (volatile alice_core_task_s*)(ALICE_BOB_TASKS_SHBUF + (core * sizeof(alice_core_task_s)));
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
        printf("[BOB] copy alice to %X[%X]\n", (uint32_t)dst, sz);
        memset32(dst, 0, sz);
        if (vp dst) {
            printf("[BOB] failed to clear dst area\n");
            return -1;
        }
        memcpy(dst, src, sz);
    }
    
    alice_vectors = dst;
    alice_xcfg = (alice_xcfg_s*)((uint32_t)dst + (uint32_t)(alice_vectors->configs.xcfg));
    alice_core_status = (int(*)[4])((uint32_t)dst + (uint32_t)(alice_vectors->configs.core_status));
    alice_tasks = (volatile alice_core_task_s * (* volatile)[4])((uint32_t)dst + (uint32_t)(alice_vectors->configs.core_tasks));

    if (set_uart) {
        printf("[BOB] set alice uart to %X[%X]\n", g_uart_bus, UART_RATE);
        alice_xcfg->uart_bus = g_uart_bus;
        alice_xcfg->uart_rate = UART_RATE;
    }

    if (set_ints) {
        setup_ints();
        _MEP_INTR_ENABLE_
    }

    if (start)
        compat_armReBoot(arm_clock, enable_cs, dram);

    return 0;
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

int alice_handleCmd(uint32_t cmd, uint32_t arg1, uint32_t arg2, uint32_t arg3) {
    void* exec_paddr = 0;
    maika_s* maika = (maika_s*)MAIKA_OFFSET;

    printf("[BOB] got alice cmd %X (%X, %X, %X)\n", cmd, arg1, arg2, arg3);

    if (cmd & 0x80000000 && cmd != ALICE_RELINQUISH_CMD) {
        if (cmd & 1)
            exec_paddr = (void*)(cmd & 0xFFFFFFFE);
        else
            exec_paddr = (void*)(cmd & 0x7FFFFFFE);
        uint32_t (*exec_func)(uint32_t a, uint32_t b, uint32_t c) = (void*)exec_paddr;
        maika->mailbox.cry2arm[1] = exec_func(arg1, arg2, arg3);
        maika->mailbox.arm2cry[0] = -1;
        return -1;
    }

    switch (cmd) {
    case ALICE_RELINQUISH_CMD:
        if (arg3 == cmd) {
            printf("[BOB] alice service terminated\n");
            maika->mailbox.arm2cry[3] = -1;
            maika->mailbox.arm2cry[2] = -1;
            maika->mailbox.arm2cry[1] = -1;
            return 0;
        } else
            printf("[BOB] invalid arg for compat acquire\n");
        break;
    case ALICE_A2B_GET_RPC_STATUS:
        maika->mailbox.cry2arm[1] = g_rpc_status;
        break;
    case ALICE_A2B_SET_RPC_STATUS:
        g_rpc_status = arg1;
        break;
    case ALICE_A2B_MASK_RPC_STATUS:
        if (maika->mailbox.arm2cry[2])
            g_rpc_status |= (arg1);
        else
            g_rpc_status &= ~(arg1);
        maika->mailbox.cry2arm[1] = g_rpc_status;
        break;
    case ALICE_A2B_REBOOT:
        compat_armReBoot(arg1, arg2, arg3);
        break;
    case ALICE_A2B_MEMCPY:
        memcpy((void*)arg1, (void*)arg2, arg3);
        break;
    case ALICE_A2B_MEMSET:
        memset((void*)arg1, (arg2 & 0xFF), arg3);
        break;
    case ALICE_A2B_MEMSET32:
        memset32((void*)arg1, arg2, arg3);
        break;
    case ALICE_A2B_READ32:
        if ((int)arg3 < 0)
            maika->mailbox.cry2arm[1] = readAs(arg1, arg3 & 0x7fffffff);
        else
            maika->mailbox.cry2arm[1] = vp arg1;
        break;
    case ALICE_A2B_WRITE32:
        if ((int)arg3 < 0)
            writeAs(arg1, arg2, arg3 & 0x7fffffff);
        else
            vp arg1 = arg2;
        break;
    default:
        break;
    }

    maika->mailbox.arm2cry[3] = -1;
    maika->mailbox.arm2cry[2] = -1;
    maika->mailbox.arm2cry[1] = -1;

    return -1;
}