#include "include/types.h"
#include "include/uart.h"

void uart_init(int bus) {
    volatile unsigned int* uart_regs = UART_REGS(bus);
    volatile unsigned int* uartclkgen_regs = UARTCLKGEN_REGS(bus);

    uart_regs[1] = 0; // disable device

    *uartclkgen_regs = 0x1001A; // Baudrate = 115200

    uart_regs[8] = 3;
    uart_regs[4] = 1;
    uart_regs[0xC] = 0;
    uart_regs[0x18] = 0x303;
    uart_regs[0x10] = 0;
    uart_regs[0x14] = 0;
    uart_regs[0x19] = 0x10001;

    uart_regs[1] = 1; // enable device

    while (!(uart_regs[0xA] & 0x200))
        asm("syncm\n");
}

void uart_write(int bus, unsigned int data) {
    volatile unsigned int* uart_regs = UART_REGS(bus);

    while (!(uart_regs[0xA] & 0x100))
        asm("syncm\n");

    uart_regs[0x1C] = data;
}

void uart_print(int bus, char* str) {
    while (*str) {
        if (*str == '\n')
            uart_write(bus, '\r');

        uart_write(bus, *str++);
    }
}

void uart_printn(int bus, char* str, int n) {
    char* z = str;
    
    while (n && *z) {
        if (*z == '\n')
            uart_write(bus, '\r');

        uart_write(bus, *z++);
        
        n--;
    }
}