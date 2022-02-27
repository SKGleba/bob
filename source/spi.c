#include "include/types.h"
#include "include/utils.h"
#include "include/spi.h"

void spi_write_start(int bus) {
    volatile unsigned int* spi_regs = SPI_REGS(bus);
    while (spi_regs[0xA])
        spi_regs[0];
    spi_regs[0xB];
    spi_regs[9] = 0x600;
}

void spi_write_end(int bus) {
    volatile unsigned int* spi_regs = SPI_REGS(bus);
    spi_regs[2] = 0;
    spi_regs[4] = 1;
    spi_regs[4];
    _MEP_SYNC_BUS_
}

void spi_write(int bus, unsigned int data) {
    volatile unsigned int* spi_regs = SPI_REGS(bus);
    spi_regs[1] = data;
}

int spi_read_available(int bus) {
    volatile unsigned int* spi_regs = SPI_REGS(bus);
    return spi_regs[0xA];
}

int spi_read(int bus) {
    volatile unsigned int* spi_regs = SPI_REGS(bus);
    return spi_regs[0];
}

void spi_read_end(int bus) {
    volatile unsigned int* spi_regs = SPI_REGS(bus);
    spi_regs[4] = 0;
    spi_regs[4];
    _MEP_SYNC_BUS_
}