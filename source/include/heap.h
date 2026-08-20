#ifndef __HEAP_H__
#define __HEAP_H__

#include "types.h"
#include "defs.h"

// vvv platform-specific vvv
#define HEAP_CPU_PTRT uint32_t
#define HEAP_DEFAULT_ADDR (&PROG_heap_start)
#define HEAP_DEFAULT_SIZE ((HEAP_CPU_PTRT)&cfg_PROG_load_end - (HEAP_CPU_PTRT)&PROG_heap_start)
#define HEAP_STUB_FUNC stub()
#define HEAP_DBGP(...) INFOF("[BOB] " __VA_ARGS__)
#define HEAP_ERRP(...) ERRORF("[BOB] " __VA_ARGS__)
// ^^^ platform-specific ^^^

// vvv user config vvv
#define HEAP_MIN_INITBC 8 // min block count that must fit for init()
#define HEAP_MIN_SPLITC 4 // min unused block count to split a free block into 2 blocks on alloc()
#define HEAP_SB_BS 4 // small block size in bytes
// ^^^ user config ^^^

// vvv DONT CHANGE THAT vvv
#define HEAP_MIN_BS 8 // resolution
#define HEAP_HDR_BSS 3 // shift thx to block size
#define HEAP_HDR_HSZ (sizeof(uint32_t))
// ^^^ DONT CHANGE THAT ^^^

enum HEAP_HDR_BITS {
    HEAP_HDRb_SIZE = 0, // in HEAP_MIN_BS-byte blocks
    HEAP_HDRb_SIZE__L = HEAP_HDRb_SIZE + 24,
    HEAP_HDRb_MAGIC,
    HEAP_HDRb_MAGIC__L = HEAP_HDRb_MAGIC + 4,
    HEAP_HDRb_ADHSZ,
    HEAP_HDRb_ADHSZ__L = HEAP_HDRb_ADHSZ,
    HEAP_HDRb_USED,
    HEAP_HDRb_USED__L = HEAP_HDRb_USED,
};

#define HEAP_HDR_MAGIC 0b10101

#define HEAP_HDR_FMASK(_f) ((1U << ((HEAP_HDRb##_f##__L - HEAP_HDRb##_f) + 1)) - 1U)

#define HEAP_HDR_GET(_h, _f) (((_h) >> HEAP_HDRb##_f) & HEAP_HDR_FMASK(_f))

#define HEAP_HDR_CLR(_h, _f) ((_h) & ~(HEAP_HDR_FMASK(_f) << HEAP_HDRb##_f))

#define HEAP_HDR_SET(_h, _f, _v) \
    (HEAP_HDR_CLR(_h, _f) | (((uint32_t)(_v) & HEAP_HDR_FMASK(_f)) << HEAP_HDRb##_f))

#define HEAP_HDR_CFG(_s, _u, _a) \
    (((_s) & HEAP_HDR_FMASK(_SIZE)) | (HEAP_HDR_MAGIC << HEAP_HDRb_MAGIC) | (((_u) & HEAP_HDR_FMASK(_USED)) << HEAP_HDRb_USED) | (((_a) & HEAP_HDR_FMASK(_ADHSZ)) << HEAP_HDRb_ADHSZ))


#define HEAP_HDR_ISVALID(_h) (HEAP_HDR_GET(_h, _MAGIC) == HEAP_HDR_MAGIC)
#define HEAP_HDR_ISUSED(_h) (!!(HEAP_HDR_GET(_h, _USED)))
#define HEAP_HDR_GETNEXT(_h) (((HEAP_HDR_GET(_h, _SIZE) << HEAP_HDR_BSS) + HEAP_MIN_BS + (HEAP_HDR_GET(_h, _ADHSZ) * HEAP_HDR_HSZ)) + HEAP_HDR_HSZ)
#define HEAP_HDR_US2SYSS(_u) ((((uint32_t)(_u) + (HEAP_MIN_BS - 1)) & ~(HEAP_MIN_BS - 1)) + HEAP_HDR_HSZ)
#define HEAP_HDR_US2SYSC(_u) (((HEAP_HDR_US2SYSS(_u) - HEAP_HDR_HSZ) >> HEAP_HDR_BSS) - 1)
#define HEAP_HDR_SYSSMRG2C(_h1, _h2) (HEAP_HDR_GETNEXT(_h1) + HEAP_HDR_GETNEXT(_h2))

struct _heap_s {
    uint32_t magic;
    int size;
    struct {
        uint32_t cfg;
        uint32_t end;
        uint32_t bfree[4];
    } s; // small blocks
};
typedef struct _heap_s heap_s;

#define HEAP_MB_MAGIC 0x0B0BAA16

#define HEAP_SCFG_GET_BC(_cfg, _n) (((_cfg) >> (8 * (_n))) & 0xFF)
#define HEAP_SCFG_SET_BC(_one, _two, _three, _four) \
    ((((_one) & 0xFF) << 0) | (((_two) & 0xFF) << 8) | (((_three) & 0xFF) << 16) | (((_four) & 0xFF) << 24))

#ifdef HEAP_UNUSE
#define HEAP_NODEBUG
#undef HEAP_ONINIT
#define heap_free(heap, ptr) HEAP_STUB_FUNC
#define heap_alloc(heap, size) HEAP_STUB_FUNC
#define heap_start(start, size, smallcfg) HEAP_STUB_FUNC
#else
int heap_free(heap_s *heap, void *ptr);
void *heap_alloc(heap_s *heap, int size);
int heap_start(void* start, int size, uint32_t smallcfg);
#endif

#ifdef HEAP_NODEBUG
#undef HEAP_DBGP
#define HEAP_DBGP(...)
#define heap_debug(heap) HEAP_STUB_FUNC
#else
int heap_debug(heap_s *heap);
#endif

#endif