#ifndef __GPIO_H__
#define __GPIO_H__

#include "types.h"
#include "paddr.h"

enum GPIO_PORT_MODES {
    GPIO_PORT_MODE_INPUT = 0,
    GPIO_PORT_MODE_OUTPUT
};

enum GPIO_INT_MODES {
    GPIO_INT_MODE_HIGH_LEVEL_SENS = 0,
    GPIO_INT_MODE_LOW_LEVEL_SENS,
    GPIO_INT_MODE_RISING_EDGE,
    GPIO_INT_MODE_FALLING_EDGE
};

enum GPIO0_PORTS {
    GPIO_PORT_OLED = 0,
    GPIO_PORT_ERNIE_OUT = 3,
    GPIO_PORT_ERNIE_IN,
    GPIO_PORT_GAMECARD_LED = 6,
    GPIO_PORT_PS_LED,
    GPIO_PORT_HDMI_BRIDGE = 15,
    GPIO_PORT_GPO0,
    GPIO_PORT_GPO1,
    GPIO_PORT_GPO2,
    GPIO_PORT_GPO3,
    GPIO_PORT_GPO4,
    GPIO_PORT_GPO5,
    GPIO_PORT_GPO6,
    GPIO_PORT_GPO7,
};

#define GPIO_REGS(i)			        ((void *)((i) ? GPIO1_OFFSET : GPIO0_OFFSET))

void gpio_set_port_mode(int bus, int port, int mode);
int gpio_port_read(int bus, int port);
void gpio_port_set(int bus, int port);
void gpio_port_clear(int bus, int port);
void gpio_set_intr_mode(int bus, int port, int mode);
int gpio_query_intr(int bus, int port);
int gpio_acquire_intr(int bus, int port);
void gpio_init(bool init_leds);
void gpio_enable_port(int bus, int port);

#endif