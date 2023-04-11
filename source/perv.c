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

unsigned int pervasive_read_misc(unsigned int offset) {
    return *(unsigned int*)(PERVASIVE_MISC_BASE_ADDR + offset);
}

void pervasive_clock_enable_uart(int bus) {
    pervasive_mask_or(PERVASIVE_GATE_BASE_ADDR + 0x120 + 4 * bus, 1);
}

void pervasive_reset_exit_uart(int bus) {
    pervasive_mask_and_not(PERVASIVE_RESET_BASE_ADDR + 0x120 + 4 * bus, 1);
}

void pervasive_clock_enable_gpio(void) {
    pervasive_mask_or(PERVASIVE_GATE_BASE_ADDR + 0x100, 1);
}

void pervasive_reset_exit_gpio(void) {
    pervasive_mask_and_not(PERVASIVE_RESET_BASE_ADDR + 0x100, 1);
}

void pervasive_clock_enable_spi(int bus) {
    pervasive_mask_or(PERVASIVE_GATE_BASE_ADDR + 0x104 + 4 * bus, 1);
}

void pervasive_clock_disable_spi(int bus) {
    pervasive_mask_and_not(PERVASIVE_GATE_BASE_ADDR + 0x104 + 4 * bus, 1);
}

void pervasive_reset_exit_spi(int bus) {
    pervasive_mask_and_not(PERVASIVE_RESET_BASE_ADDR + 0x104 + 4 * bus, 1);
}
