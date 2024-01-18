#ifndef __UART_H__
#define __UART_H__

#include <hardware/uart.h>

#include "types.h"
#include "defs.h"

#ifndef UART_BUS
#define UART_BUS 1 // devkit default
#endif

#ifndef UART_RATE
#define UART_RATE UART_BAUD_115200 // devkit default
#endif

extern int g_uart_bus;

void uart_init(int bus, unsigned int clk);
void uart_write(int bus, unsigned int data);
void uart_print(int bus, char* str);
void uart_printn(int bus, char* str, int n);
int uart_scann(int bus, uint8_t* out, int outsize, unsigned int timeout);
int uart_scanns(int bus, char* out, int outsize, unsigned int timeout);
int uart_rxfifo_flush(int bus);

#endif