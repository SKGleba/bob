#ifndef __SPI_H__
#define __SPI_H__

#include <hardware/spi.h>

void spi_write_start(int bus);
void spi_write_end(int bus);
void spi_write(int bus, unsigned int data);
int spi_read_available(int bus);
int spi_read(int bus);
void spi_read_end(int bus);
void spi_init(int bus);

#endif