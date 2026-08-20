#ifndef __UART_H__
#define __UART_H__

#include <hardware/uart.h>

#include "types.h"
#include "defs.h"
#include "utils.h"

#ifdef UART_UNUSE
#define UART_NOINIT
#endif

#ifndef UART_BUS
#define UART_BUS 1 // devkit default
#endif

#ifndef UART_RATE
#define UART_RATE UART_BAUD_115200 // devkit default
#endif

#define UART_BUS_COUNT 7 // 0-6, setting to 7+ will default to g_uart_bus

extern int g_uart_bus;

#ifndef UART_NOINIT
void uart_init(int bus, unsigned int clk);
#else
#define uart_init(bus, clk) stub()
#endif

#ifndef UART_UNUSE
void uart_write(int bus, unsigned int data);
void uart_print(int bus, char* str);
void uart_printn(int bus, char* str, int n);
void uart_printr(int bus, uint8_t *data, int n);
int uart_scann(int bus, uint8_t* out, int outsize, unsigned int timeout);
int uart_scanns(int bus, char* out, int outsize, unsigned int timeout);
int uart_rxfifo_flush(int bus);
#else
#define uart_write(bus, data) stub()
#define uart_print(bus, str) stub()
#define uart_printn(bus, str, n) stub()
#define uart_printr(bus, data, n) stub()
#define uart_scann(bus, out, outsize, timeout) stub()
#define uart_scanns(bus, out, outsize, timeout) stub()
#define uart_rxfifo_flush(bus) stub()
#endif

#endif