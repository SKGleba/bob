#include "include/types.h"
#include "include/utils.h"
#include "include/perv.h"

#include "include/i2c.h"

static inline void i2c_wait_busy(volatile unsigned int* i2c_regs) {
    while (i2c_regs[7])
        ;
}

void i2c_init_bus(int bus) {
    volatile unsigned int* i2c_regs = I2C_REGS(bus);

    pervasive_control_gate((PERV_CTRL_GATE_DEV_I2C0 + bus), 1, true, false);
    pervasive_control_reset((PERV_CTRL_RESET_DEV_I2C0 + bus), 1, false, false);

    i2c_regs[0xB] = 0x100F70F;
    i2c_regs[2] = 1;
    i2c_regs[3] = 1;
    i2c_regs[5] = 7;
    _MEP_SYNC_BUS_

    i2c_wait_busy(i2c_regs);

    i2c_regs[0xA] = i2c_regs[0xA];
    i2c_regs[0xB] = 0x1000000;

    i2c_regs[6] = 4; // or 5?
}

void i2c_transfer_write(int bus, unsigned char addr, const unsigned char* buffer, int size) {
    int i;
    volatile unsigned int* i2c_regs = I2C_REGS(bus);

    i2c_regs[2] = 1;
    i2c_regs[3] = 1;
    i2c_regs[4] = addr >> 1;

    for (i = 0; i < size; i++)
        i2c_regs[0] = buffer[i];

    i2c_regs[5] = (size << 8) | 2;

    i2c_wait_busy(i2c_regs);

    i2c_regs[5] = 4;

    i2c_wait_busy(i2c_regs);
}

void i2c_transfer_write_short(int bus, unsigned char addr, uint32_t data, int size) {
    i2c_transfer_write(bus, addr, (unsigned char*)&data, size);
}

void i2c_transfer_read(int bus, unsigned char addr, unsigned char* buffer, int size) {
    int i;
    volatile unsigned int* i2c_regs = I2C_REGS(bus);

    i2c_regs[2] = 1;
    i2c_regs[3] = 1;
    i2c_regs[4] = addr >> 1;
    i2c_regs[5] = (size << 8) | 0x13;

    i2c_wait_busy(i2c_regs);

    for (i = 0; i < size; i++)
        buffer[i] = i2c_regs[1];

    i2c_regs[5] = 4;

    i2c_wait_busy(i2c_regs);
}

void i2c_transfer_write_read(int bus, unsigned char write_addr, const unsigned char* write_buffer, int write_size,
    unsigned char read_addr, unsigned char* read_buffer, int read_size) {
    int i;
    volatile unsigned int* i2c_regs = I2C_REGS(bus);

    i2c_regs[2] = 1;
    i2c_regs[3] = 1;
    i2c_regs[4] = write_addr >> 1;

    for (i = 0; i < write_size; i++)
        i2c_regs[0] = write_buffer[i];

    i2c_regs[5] = (write_size << 8) | 2;

    i2c_wait_busy(i2c_regs);

    i2c_regs[5] = 5;

    i2c_wait_busy(i2c_regs);

    i2c_regs[5] = (read_size << 8) | 0x13;

    i2c_wait_busy(i2c_regs);

    for (i = 0; i < read_size; i++)
        read_buffer[i] = i2c_regs[1];

    i2c_regs[5] = 4;

    i2c_wait_busy(i2c_regs);
}