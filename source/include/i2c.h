#ifndef __I2C_H__
#define __I2C_H__

#include "types.h"
#include "defs.h"
#include "paddr.h"

#define I2C_REGS(i)     ((void *)((i) ? I2C1_OFFSET : I2C0_OFFSET))

void i2c_init_bus(int bus);
void i2c_transfer_write(int bus, unsigned char addr, const unsigned char* buffer, int size);
void i2c_transfer_read(int bus, unsigned char addr, unsigned char* buffer, int size);
void i2c_transfer_write_read(int bus, unsigned char write_addr, const unsigned char* write_buffer, int write_size,
    unsigned char read_addr, unsigned char* read_buffer, int read_size);


#endif