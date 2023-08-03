#ifndef __UART_H__
#define __UART_H__

#include "types.h"
#include "defs.h"
#include "paddr.h"

#ifndef UART_BUS
#define UART_BUS 1 // devkit default
#endif

#ifndef UART_RATE
#define UART_RATE UART_BAUD_115200 // devkit default
#endif

#define UART_REGS(i)			((void *)(UART0_OFFSET + (i) * UART0_SIZE))

enum UART_BAUD_TO_CLKGEN {
    UART_BAUD_115200 = 0x1001A,
    UART_BAUD_38400 = 0x1004E,
};

extern int g_uart_bus;

void uart_init(int bus, unsigned int clk);
void uart_write(int bus, unsigned int data);
void uart_print(int bus, char* str);
void uart_printn(int bus, char* str, int n);

#endif