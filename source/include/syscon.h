#ifndef __SYSCON_H__
#define __SYSCON_H__

#include "types.h"

#define SYSCON_TX_CMD_LO	0
#define SYSCON_TX_CMD_HI	1
#define SYSCON_TX_LENGTH	2
#define SYSCON_TX_DATA(i)	(3 + (i))
#define SYSCON_RX_STATUS_LO	0
#define SYSCON_RX_STATUS_HI	1
#define SYSCON_RX_LENGTH	2
#define SYSCON_RX_RESULT	3

typedef struct syscon_packet {
    unsigned char tx[32];
    unsigned char rx[32];
} syscon_packet;

int syscon_common_read(unsigned int* buffer, unsigned short cmd);
void syscon_common_write(unsigned int data, unsigned short cmd, unsigned int length);

#endif