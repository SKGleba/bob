#ifndef __ALICE_H__
#define __ALICE_H__

#include "types.h"

struct _alice_xcfg_s {
    void* sp_per_core[4];
    int uart_bus;
    int uart_rate;
};
typedef struct _alice_xcfg_s alice_xcfg_s;

struct _alice_core_task_s {
    int task_id;
    int args[4];
    int status;
    int ret;
    void* next;
};
typedef struct _alice_core_task_s alice_core_task_s;

struct _alice_vector_s {
    uint32_t ldr_handler_ptr[8];
    struct {
        void* exc_RESET;
        void* exc_UNDEF;
        void* exc_SWI;
        void* exc_PABT;
        void* exc_DABT;
        void* exc_RESERVED;
        void* exc_IRQ;
        void* exc_FIQ;
    } exception_handlers;
    struct {
        alice_xcfg_s* xcfg;
        void* exports_start;
        alice_core_task_s* (*core_tasks)[4];
        int *core_status;
    } configs;
};
typedef struct _alice_vector_s alice_vector_s;

enum ALICE2BOB_COMMANDS {
    ALICE_A2B_GET_RPC_STATUS = 0xA20,
    ALICE_A2B_SET_RPC_STATUS,
    ALICE_A2B_MASK_RPC_STATUS,
    ALICE_A2B_REBOOT,
    ALICE_A2B_MEMCPY,
    ALICE_A2B_MEMSET,
    ALICE_A2B_MEMSET32,
    ALICE_A2B_READ32,
    ALICE_A2B_WRITE32,
    ALICE_A2B_EXEC = 0x80000000 // OR it with paddr for bob to exec
};

#define ALICE_ACQUIRE_CMD 0x5E7A21CE
#define ALICE_RELINQUISH_CMD 0xA21CEDED

#define ALICE_DRAM_ADDR 0x40000000
#define ALICE_DRAM_SIZE 0x00040000
#define ALICE_SPAD32K_ADDR 0x1f000000
#define ALICE_SPAD32K_SIZE 0x00008000

enum ALICE_ZERO_TASKS {
    ALICE_ZERO_TASKS_NOP = 0,
    ALICE_ZERO_TASKS_ENABLE_RPC = 1
};

enum ALICE_ONE_TASKS {
    ALICE_ONE_TASKS_NOP = 0,
};

enum ALICE_TWO_TASKS {
    ALICE_TWO_TASKS_NOP = 0,
};

enum ALICE_THREE_TASKS {
    ALICE_THREE_TASKS_NOP = 0,
};

#define ALICE_CORE_TASK_STATUS_ACCEPTED 0b1
#define ALICE_CORE_TASK_STATUS_RUNNING 0b10
#define ALICE_CORE_TASK_STATUS_DONE 0b100
#define ALICE_CORE_TASK_STATUS_ISPTR 0b1000
#define ALICE_CORE_TASK_STATUS_FAILED 0x80000000

#define ALICE_CORE_TASK_TYPE_ISPTR 0x80000000

#define ALICE_CORE_STATUS_RUNNING 0b1 // core is running
#define ALICE_CORE_STATUS_WAITING 0b10 // core is waiting
#define ALICE_CORE_STATUS_TASKING 0b100 // core is running a task (chain)

void alice_armReBoot(int armClk, bool hasCS, bool hasUnk);
int alice_handleCmd(uint32_t cmd, uint32_t arg1, uint32_t arg2, uint32_t arg3);
void alice_setupInts(void);
int alice_loadAlice(void* src, bool start, int arm_clock, bool set_ints, bool enable_cs, bool dram, bool set_uart);

int alice_schedule_task(int target_core, volatile alice_core_task_s* task, bool wait_core_done, bool wait_task_done);
int alice_get_task_status(int core, bool ret, bool actual_core_task);
int alice_schedule_bob_task(int core, int task_id, bool wait_core_done, bool wait_task_done, int a0, int a1, int a2, int a3);

extern volatile alice_vector_s* alice_vectors;
extern volatile alice_xcfg_s* alice_xcfg;
extern volatile alice_core_task_s* (* volatile alice_tasks)[4];
extern volatile int(*alice_core_status)[4];

#endif