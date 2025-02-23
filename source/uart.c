#include "include/types.h"
#include "include/perv.h"
#include "include/uart.h"
#include "include/defs.h"

int g_uart_bus = UART_BUS;

#ifndef UART_UNUSE

void uart_init(int bus, unsigned int clk) {
    volatile unsigned int* uart_regs = UART_REGS(bus);
    volatile unsigned int* uart_clkgen = (volatile unsigned int* )PERV_GET_REG(PERV_CTRL_UARTCLKGEN, bus);

    pervasive_control_gate((PERV_CTRL_GATE_DEV_UART0 + bus), 1, true, false);
    pervasive_control_reset((PERV_CTRL_RESET_DEV_UART0 + bus), 1, false, false);

    uart_regs[1] = 0; // disable device

    *uart_clkgen = clk; // Baudrate

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

// read [bus] rx reg until there is valid data or [timeout]+1 times
int uart_read(int bus, unsigned int timeout, bool wait) {
    unsigned int num = 0;
    volatile unsigned int* uart_regs = UART_REGS(bus);

    while ((num = (uart_regs[0x1A] & 0b111111), !num) && (wait || (timeout--, timeout + 1))) {
        asm("syncm\n");
    }

    return ((uart_regs[0x1E] & 0xFF) | (!num << 31));
}

int uart_rxfifo_flush(int bus) {
    int le_data = 0;
    if (bus >= UART_BUS_COUNT)
        bus = g_uart_bus;
    volatile unsigned int* uart_regs = UART_REGS(bus);
    while (uart_regs[0x1A] & 0b111111) {
        le_data = uart_regs[0x1E];
    }
    return (le_data & 0xFF);
}

void uart_print(int bus, char* str) {
    if (bus >= UART_BUS_COUNT)
        bus = g_uart_bus;
    while (*str) {
        if (*str == '\n')
            uart_write(bus, '\r');

        uart_write(bus, *str++);
    }
}

void uart_printn(int bus, char* str, int n) {
    char* z = str;

    if (bus >= UART_BUS_COUNT)
        bus = g_uart_bus;

    while (n && *z) {
        if (*z == '\n')
            uart_write(bus, '\r');

        uart_write(bus, *z++);
        
        n--;
    }
}

// setting [timeout] to 0 will make it wait indefinitely
int uart_scann(int bus, uint8_t* out, int outsize, unsigned int timeout) {
    int data;
    if (bus >= UART_BUS_COUNT)
        bus = g_uart_bus;
    for (int i = 0; i < outsize; i++) {
        data = uart_read(bus, timeout, !timeout);
        if (data < 0)
            return -1;
        out[i] = (char)data;
    }
    return 0;
}

// setting [timeout] to 0 will make it wait indefinitely
int uart_scanns(int bus, char* out, int outsize, unsigned int timeout) {
    int data;
    if (bus >= UART_BUS_COUNT)
        bus = g_uart_bus;
    for (int i = 0; i < outsize; i++) {
        data = uart_read(bus, timeout, !timeout);
        if (data < 0)
            return -1;
        out[i] = (char)data;
        if ((char)data == '\n') {
            if (i && out[i - 1] == '\r')
                return 0;
        }
    }
    return -1;
}

#endif