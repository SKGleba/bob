#include "include/utils.h"
#include "include/perv.h"

static inline void pervasive_mask_or(unsigned int addr, unsigned int val) {
    *(uint32_t*)addr |= val;
    _MEP_SYNC_BUS_
    { __attribute__((unused)) volatile uint32_t temp = v32p addr; }
}

static inline void pervasive_mask_and_not(unsigned int addr, unsigned int val) {
    *(uint32_t*)addr &= ~val; // is that right? bic on arm
    _MEP_SYNC_BUS_
    { __attribute__((unused)) volatile uint32_t temp = v32p addr; }
}

uint32_t pervasive_control_reset(int device, unsigned int mask, bool reset, bool wait) {
    uint32_t addr = PERV_GET_REG(PERV_CTRL_RESET, device);
    
    if (reset)
        v32p addr |= mask;
    else
        v32p addr &= ~mask;

    _MEP_SYNC_BUS_

    { __attribute__((unused)) volatile uint32_t temp = v32p addr; }

    if (wait) {
        if (reset) {
            while ((v32p(addr) & mask) != mask)
                ;
        } else {
            while (v32p(addr) & mask)
                ;
        }
    }

    return v32p addr;
}

uint32_t pervasive_control_gate(int device, unsigned int mask, bool open, bool wait) {
    uint32_t addr = PERV_GET_REG(PERV_CTRL_GATE, device);

    if (open)
        v32p addr |= mask;
    else
        v32p addr &= ~mask;

    _MEP_SYNC_BUS_

    { __attribute__((unused)) volatile uint32_t temp = v32p addr; }

    if (wait) {
        if (open) {
            while ((v32p(addr) & mask) != mask)
                ;
        } else {
            while (v32p(addr) & mask)
                ;
        }
    }

    return v32p addr;
}

uint32_t pervasive_control_clock(int device, unsigned int clock, bool wait) {
    uint32_t addr = PERV_GET_REG(PERV_CTRL_BASECLK, device);
    v32p addr = clock;

    _MEP_SYNC_BUS_

    { __attribute__((unused)) volatile uint32_t temp = v32p addr; }

    if (wait) {
        while (v32p(addr) != clock)
            ;
    }

    return v32p addr;
}

uint32_t pervasive_control_misc(int reg_id, unsigned int value, bool wait) {
    uint32_t addr = PERV_GET_REG(PERV_CTRL_MISC, reg_id);
    v32p addr = value;

    _MEP_SYNC_BUS_

    { __attribute__((unused)) volatile uint32_t temp = v32p addr; }

    if (wait) {
        while (v32p(addr) != value)
            ;
    }

    return v32p addr;
}
