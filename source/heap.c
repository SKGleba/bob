#include "include/heap.h"

#include "include/utils.h"
#include "include/debug.h"
#include "include/defs.h"
#include "include/types.h"
#include "include/clib.h"

// WIP - DO NOT USE SMALL BLOCKS YET - SET HEAP_NOSMALL to disable small block allocator /SK

#ifndef HEAP_UNUSE

static heap_s *l_heap = NULL;

#ifndef HEAP_NODEBUG
int heap_debug(heap_s *heap) {
    HEAP_DBGP("heap_debug: heap @ 0x%X\n", heap);
    if (!heap)
        heap = l_heap;
    if (!heap || (heap->magic != HEAP_MB_MAGIC)) {
        HEAP_ERRP("heap_debug: sys heap not initialized\n");
        return -1;
    }
    HEAP_DBGP(" magic: 0x%X\n size: %d\n s.cfg: 0x%X\n", heap->magic, heap->size, heap->s.cfg);
#ifndef HEAP_NOSMALL
    if (heap->s.cfg) {
        HEAP_DBGP(" s.end: 0x%X\n", heap->s.end);
        for (int i = 0; i < 4; i++) {
            if (HEAP_SCFG_GET_BC(heap->s.cfg, i)) {
                HEAP_DBGP(" s.bfree[%d]: 0x%08X\n", i, heap->s.bfree[i]);
            } else
                break;
        }
    }
#endif
    int idx = 0;
    int distance = sizeof(heap_s);
    uint32_t *hdr = (uint32_t *)((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)distance);
    do {
        if (!HEAP_HDR_ISVALID(*hdr)) {
            HEAP_DBGP("heap_debug: reached invalid block header at 0x%X after %d blocks\n", hdr, idx);
            return 0;
        }
        HEAP_DBGP("heap_debug: block %d at 0x%X, size 0x%X, used %d, adhsz 0x%X\n", idx, hdr, HEAP_HDR_GETNEXT(*hdr), HEAP_HDR_ISUSED(*hdr), HEAP_HDR_GET(*hdr, _ADHSZ));
#ifndef HEAP_NOSMALL
        if (heap->s.cfg && idx < 4) {
            int bc = HEAP_SCFG_GET_BC(heap->s.cfg, idx);
            if (bc) {
                HEAP_DBGP("heap_debug: small block group %d, block count per entry %d, free slots 0x%08X\n", idx, bc, heap->s.bfree[idx]);
            }
        }
#endif
        distance += HEAP_HDR_GETNEXT(*hdr);
        hdr = (uint32_t *)((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)distance);
        idx++;
    } while (distance < heap->size);
    HEAP_DBGP("heap_debug: reached end of heap at 0x%X\n", hdr);
    return 0;
}
#endif

int heap_free(heap_s *heap, void *ptr) {
    HEAP_DBGP("heap_free: heap 0x%X, ptr 0x%X\n", heap, ptr);
    if (!ptr)
        return -1;
    if (!heap)
        heap = l_heap;
    if (!heap || (heap->magic != HEAP_MB_MAGIC)) {
        HEAP_ERRP("heap_free: bad magic @0x%X\n", heap);
        return -2;
    }
    int distance = sizeof(heap_s);
    uint32_t *hdr = (uint32_t *)((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)distance);
    if ((HEAP_CPU_PTRT)ptr < (HEAP_CPU_PTRT)heap || (HEAP_CPU_PTRT)ptr >= ((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)heap->size)) {
        HEAP_ERRP("heap_free: 0x%X oob 0x%X/0x%X\n", ptr, heap, ((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)heap->size));
        return -4;
    }

    // check if its a small block
#ifndef HEAP_NOSMALL
    int is_small = 0;
    if (heap->s.cfg && ((HEAP_CPU_PTRT)ptr < ((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)heap->s.end)))
        is_small = 1;
#endif

    // its a big block
    uint32_t *prev = (uint32_t *)((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)distance);
    do {
        if (!HEAP_HDR_ISVALID(*hdr)) {
            HEAP_ERRP("heap_free: bad hdr @0x%X\n", hdr);
            return -3;
        }
#ifndef HEAP_NOSMALL
        if (is_small) {
            if (((HEAP_CPU_PTRT)ptr > (HEAP_CPU_PTRT)hdr) && ((HEAP_CPU_PTRT)ptr < (HEAP_CPU_PTRT)HEAP_HDR_GETNEXT(*hdr))) {
                int sbc = HEAP_SCFG_GET_BC(heap->s.cfg, (is_small - 1));
                for (int i = 0; i < 32; i++) {
                    if ((HEAP_CPU_PTRT)ptr == ((HEAP_CPU_PTRT)hdr + HEAP_HDR_HSZ + (HEAP_CPU_PTRT)((sbc * HEAP_SB_BS) * i))) {
                        if (heap->s.bfree[(is_small - 1)] & (1U << i)) {
                            HEAP_ERRP("heap_free: (WARN) small dfree for 0x%X\n", ptr);
                            return -6;
                        }
                        heap->s.bfree[(is_small - 1)] |= (1U << i);
                        HEAP_DBGP("heap_free: freed small block at 0x%X, group %d, slot %d\n", ptr, (is_small - 1), i);
                        return 0;
                    }
                }
            } else
                is_small++;
        } else 
#endif
        if ((HEAP_CPU_PTRT)ptr == ((HEAP_CPU_PTRT)hdr + HEAP_HDR_HSZ)) {
            if (!HEAP_HDR_ISUSED(*hdr))
                HEAP_ERRP("heap_free: (WARN) dfree for 0x%X\n", hdr);
            *hdr = HEAP_HDR_SET(*hdr, _USED, 0);
            HEAP_DBGP("heap_free: freed block at 0x%X\n", hdr);
            // merge with prev if free
            if ((prev != hdr) && (!HEAP_HDR_ISUSED(*prev))) {
                uint32_t nsz = HEAP_HDR_GETNEXT(*prev) + HEAP_HDR_GETNEXT(*hdr);
                HEAP_DBGP("heap_free: merging with prev block at 0x%X : newsz %d\n", prev, nsz);
                *prev = HEAP_HDR_CFG(HEAP_HDR_US2SYSC((nsz - HEAP_MIN_BS)), 0, !(nsz & (HEAP_MIN_BS - 1)));
                hdr = prev;
            }
            // merge with next if free
            prev = hdr;
            distance = (uint32_t)((HEAP_CPU_PTRT)hdr - (HEAP_CPU_PTRT)heap);
            distance += HEAP_HDR_GETNEXT(*hdr);
            hdr = (uint32_t *)((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)distance);
            if (distance < heap->size) {
                if (!HEAP_HDR_ISVALID(*hdr)) {
                    HEAP_DBGP("heap_free: was last block at 0x%X, destroying\n", prev);
                    *prev = HEAP_HDR_SET(*prev, _MAGIC, 0);
                } else if (!HEAP_HDR_ISUSED(*hdr)) {
                    uint32_t nsz = HEAP_HDR_GETNEXT(*prev) + HEAP_HDR_GETNEXT(*hdr);
                    HEAP_DBGP("heap_free: merging with next block at 0x%X : newsz %d\n", hdr, nsz);
                    *prev = HEAP_HDR_CFG(HEAP_HDR_US2SYSC((nsz - HEAP_MIN_BS)), 0, !(nsz & (HEAP_MIN_BS - 1)));
                }
            }
            return 0;
        }
        prev = hdr;
        distance += HEAP_HDR_GETNEXT(*hdr);
        hdr = (uint32_t *)((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)distance);
    } while (distance < heap->size);
    HEAP_ERRP("heap_free: no 0x%X, traveled 0x%X/0x%X\n", ptr, distance, heap->size);
    return -5;
}

void *heap_alloc(heap_s *heap, int size) {
    HEAP_DBGP("heap_alloc: heap 0x%X, size %d\n", heap, size);
    if (!heap)
        heap = l_heap;
    if (!heap || (heap->magic != HEAP_MB_MAGIC)) {
        HEAP_ERRP("heap_alloc: bad magic @0x%X\n", heap);
        return NULL;
    }
    if (size <= 0)
        return NULL;

    int bsize = 0;
    int distance = sizeof(heap_s);
    uint32_t *hdr = (uint32_t *)((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)distance);
#ifndef HEAP_NOSMALL
    // if it fits in small bl;ocks, try that first
    if (heap->s.cfg && (size <= (HEAP_SB_BS * 0xFF))) {
        int bc = 0;
        for (int i = 0; i < 4; i++) {
            bc = HEAP_SCFG_GET_BC(heap->s.cfg, i);
            if (bc) {
                if (size > (bc * HEAP_SB_BS))
                    continue;
                if (!(heap->s.bfree[i])) // no free slots
                    continue;
                for (int j = 0; j < 32; j++) {
                    if (heap->s.bfree[i] & (1U << j)) {
                        for (int k = 0; k < i; k++) {
                            distance += HEAP_HDR_GETNEXT(*hdr);
                            hdr = (uint32_t *)((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)distance);
                            if (!HEAP_HDR_ISVALID(*hdr)) {
                                HEAP_ERRP("heap_alloc: no SBG %d found at 0x%X\n", k, hdr);
                                return NULL;
                            }
                        }
                        void *ptr = (void *)((HEAP_CPU_PTRT)hdr + (HEAP_CPU_PTRT)((bc * HEAP_SB_BS) * j));
                        heap->s.bfree[i] &= ~(1U << j);
                        HEAP_DBGP("heap_alloc: allocated small block at 0x%X, size %d, group %d, slot %d\n", ptr, size, i, j);
                        return ptr;
                    }
                }
                HEAP_ERRP("heap_alloc: !BUG! NFS @0x%X:%08X\n", i, heap->s.bfree[i]);
            } else
                break;
        }
    }
    distance = (heap->s.end) ? heap->s.end : sizeof(heap_s);
    hdr = (uint32_t *)((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)distance);
#endif

    // find nearest big-enough free block (or uninitialized space)
    do {
        bsize = 0;
        if (!HEAP_HDR_ISVALID(*hdr))
            break;
        bsize = (int)HEAP_HDR_GETNEXT(*hdr);
        distance += bsize;
        if (HEAP_HDR_ISUSED(*hdr) || (bsize < HEAP_HDR_US2SYSS(size)))
            hdr = (uint32_t *)((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)distance);
        else
            break;
    } while (distance < heap->size);
    if ((distance >= heap->size) || (!bsize && ((distance + HEAP_HDR_US2SYSS(size)) > heap->size))) {
        HEAP_ERRP("heap_alloc: NFB for sz 0x%X:0x%X/0x%X\n", size, distance, heap->size);
        return NULL;
    }

    if (bsize) {
        if ((bsize - HEAP_HDR_US2SYSS(size)) >= (HEAP_MIN_SPLITC * HEAP_MIN_BS)) {
            uint32_t nsz = bsize - HEAP_HDR_US2SYSS(size);
            HEAP_DBGP("heap_alloc: splitting block at 0x%X : %d -> %d & %d\n", hdr, bsize, HEAP_HDR_US2SYSS(size), nsz);
            *hdr = HEAP_HDR_CFG(HEAP_HDR_US2SYSC(size), 1, 0);
            distance = (uint32_t)((HEAP_CPU_PTRT)hdr - (HEAP_CPU_PTRT)heap);
            distance += HEAP_HDR_GETNEXT(*hdr);
            hdr = (uint32_t *)((HEAP_CPU_PTRT)heap + (HEAP_CPU_PTRT)distance);
            *hdr = HEAP_HDR_CFG(HEAP_HDR_US2SYSC(nsz - HEAP_MIN_BS), 0, !(nsz & (HEAP_MIN_BS - 1)));
        } else
            *hdr = HEAP_HDR_SET(*hdr, _USED, 1);
    } else
        *hdr = HEAP_HDR_CFG(HEAP_HDR_US2SYSC(size), 1, 0);

    return (void *)((HEAP_CPU_PTRT)hdr + HEAP_HDR_HSZ);
}

int heap_start(void* start, int size, uint32_t smallcfg) {
    HEAP_DBGP("heap_start: start 0x%X, size %d, scfg 0x%X\n", start, size, smallcfg);
    heap_s* heap = (heap_s*)start;
    if (!heap) {
        heap = l_heap;
        if (!heap) {
            heap = (heap_s*)HEAP_DEFAULT_ADDR;
            size = (int)HEAP_DEFAULT_SIZE;
            HEAP_DBGP("heap_start: using default heap @ 0x%X, size %d\n", heap, size);
        }
    }
    if (heap->magic == HEAP_MB_MAGIC) {
        HEAP_ERRP("heap_start: (FAILED) already @ 0x%X\n", heap);
        return -3; // already initialized
    }

    int minsz = sizeof(heap_s) + (HEAP_MIN_INITBC * HEAP_MIN_BS);
#ifndef HEAP_NOSMALL
    for (int i = 0; i < 4; i++) {
        if (HEAP_SCFG_GET_BC(smallcfg, i))
            minsz += ((HEAP_SCFG_GET_BC(smallcfg, i) * HEAP_SB_BS) * 32);
    }
#endif
    if (size < minsz) {
        HEAP_ERRP("heap_start: (FAILED) sz 0x%X < minsz 0x%X\n", size, minsz);
        return -1;
    }

    memset(heap, 0, sizeof(heap_s));
    heap->size = ((uint32_t)size & ~0b111);
    heap->magic = HEAP_MB_MAGIC;

#ifndef HEAP_NOSMALL
    // alloc big blocks for small blocks
    if (smallcfg) {
        int bc = 0;
        void *lasb = NULL;
        for (int i = 0; i < 4; i++) {
            bc = HEAP_SCFG_GET_BC(smallcfg, i);
            if (bc) {
                lasb = heap_alloc(heap, (bc * HEAP_SB_BS) * 32);
                if (!lasb) {
                    HEAP_ERRP("heap_start: (FAILED) SBG %d alloc failed\n", i);
                    return -4;
                }
                heap->s.bfree[i] = -1; // bit set = slot free
            } else
                break;
        }
        if (lasb) {
            heap->s.cfg = smallcfg;
            heap->s.end = (uint32_t)((HEAP_CPU_PTRT)lasb - (HEAP_CPU_PTRT)heap);
            heap->s.end += HEAP_HDR_GETNEXT((*(uint32_t *)((HEAP_CPU_PTRT)lasb - HEAP_HDR_HSZ)));
        }
    }
#endif
    return 0;
}

#endif