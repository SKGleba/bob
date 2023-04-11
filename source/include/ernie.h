#ifndef __ERNIE_H__
#define __ERNIE_H__

#include "types.h"

// basics
#define ERNIE_TX_CMD_LO	0
#define ERNIE_TX_CMD_HI	1
#define ERNIE_TX_LENGTH	2
#define ERNIE_TX_DATA(i)	(3 + (i))
#define ERNIE_RX_STATUS_LO	0
#define ERNIE_RX_STATUS_HI	1
#define ERNIE_RX_LENGTH	2
#define ERNIE_RX_RESULT	3
#define ERNIE_RX_DATA(i)	(4 + (i))
#define ERNIE_PACKET_SIZE 0x20

typedef struct ernie_comms_t {
    uint8_t tx[ERNIE_PACKET_SIZE];
    uint8_t rx[ERNIE_PACKET_SIZE];
} ernie_comms_t;

extern ernie_comms_t g_ernie_comms;

// ernie commands & their args
enum ERNIE_COMMANDS {
    ERNIE_CMD_GET_HWINFO = 5,
    ERNIE_CMD_SET_KERMIT_BUFSZ = 0x80,
    ERNIE_CMD_GET_SCRATCHPAD = 0x90,
    ERNIE_CMD_SET_SCRATCHPAD = 0x91,
    ERNIE_CMD_SET_UART0 = 0x190,
    ERNIE_CMD_GET_KERMITJIG_SHBUF = 0x2083,
    ERNIE_CMD_SET_KERMITJIG_SHBUF = 0x2085,
};

enum ERNIE_UART0_SWITCH_MODES {
    ERNIE_UART0_MODE_ERNIE,
    ERNIE_UART0_MODE_KERMIT,
    ERNIE_UART0_MODE_OFF = 0xFF,
};

// cfuncs
void ernie_init(bool init_kbsz);
void ernie_write(uint8_t* data, uint8_t size);
bool ernie_read(uint8_t *data, uint8_t max_size);
void ernie_exec(ernie_comms_t *comms);
int ernie_exec_cmd(uint16_t cmd, void *data_in, uint8_t data_in_size);
int ernie_exec_cmd_short(uint16_t cmd, uint32_t data_in, uint8_t data_in_size);

#endif