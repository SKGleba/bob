#ifndef __PERV_H__
#define __PERV_H__

#include "types.h"
#include "defs.h"

#define PERVASIVE_RESET_BASE_ADDR	0xE3101000
#define PERVASIVE_GATE_BASE_ADDR	0xE3102000
#define PERVASIVE_BASECLK_BASE_ADDR	0xE3103000
#define PERVASIVE_MISC_BASE_ADDR	0xE3100000
#define PERVASIVE2_BASE_ADDR		0xE3110000

unsigned int pervasive_read_misc(unsigned int offset);
void pervasive_clock_enable_uart(int bus);
void pervasive_reset_exit_uart(int bus);
void pervasive_clock_enable_gpio(void);
void pervasive_clock_disable_gpio(void);
void pervasive_reset_exit_gpio(void);
void pervasive_reset_enter_gpio(void);
void pervasive_clock_enable_spi(int bus);
void pervasive_clock_disable_spi(int bus);
void pervasive_reset_exit_spi(int bus);
void pervasive_reset_enter_spi(int bus);

#endif