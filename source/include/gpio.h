#ifndef __GPIO_H__
#define __GPIO_H__

#include <hardware/gpio.h>

#include "types.h"

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