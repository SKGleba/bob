#include "include/utils.h"
#include "include/perv.h"

static inline void pervasive_mask_or(unsigned int addr, unsigned int val) {
    *(uint32_t*)addr |= val;
    _MEP_SYNC_BUS_
    *(uint32_t*)addr;
}

static inline void pervasive_mask_and_not(unsigned int addr, unsigned int val) {
    *(uint32_t*)addr &= ~val; // is that right? bic on arm
    _MEP_SYNC_BUS_
    *(uint32_t*)addr;
}

uint32_t pervasive_control_reset(int device, unsigned int mask, bool reset, bool wait) {
    uint32_t addr = PERV_GET_REG(PERV_CTRL_RESET, device);
    
    if (reset)
        vp addr |= mask;
    else
        vp addr &= ~mask;
    
    _MEP_SYNC_BUS_
        
    vp addr;

    if (wait) {
        if (reset) {
            while ((vp(addr) & mask) != mask)
                ;
        } else {
            while (vp(addr) & mask)
                ;
        }
    }

    return vp addr;
}

uint32_t pervasive_control_gate(int device, unsigned int mask, bool open, bool wait) {
    uint32_t addr = PERV_GET_REG(PERV_CTRL_GATE, device);

    if (open)
        vp addr |= mask;
    else
        vp addr &= ~mask;

    _MEP_SYNC_BUS_

    vp addr;

    if (wait) {
        if (open) {
            while ((vp(addr) & mask) != mask)
                ;
        } else {
            while (vp(addr) & mask)
                ;
        }
    }

    return vp addr;
}
