#ifndef __ERNIE_H__
#define __ERNIE_H__

#include "types.h"
#include "defs.h"
#include "utils.h"

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

#define ERNIE_TX_SIZE(data_size) (ERNIE_TX_DATA(0) + 1 + data_size)
#define ERNIE_RX_SIZE(data_size) (ERNIE_RX_DATA(0) + 1 + data_size)

#define ERNIE_DEFAULT_PACKET_SIZE 0x20

typedef struct ernie_comms_t {
    uint8_t tx[ERNIE_DEFAULT_PACKET_SIZE];
    uint8_t rx[ERNIE_DEFAULT_PACKET_SIZE];
} ernie_comms_t;

// ernie commands & their args
enum ERNIE_COMMANDS {
    ERNIE_CMD_GET_HWINFO = 5,
    ERNIE_CMD_SET_KERMIT_BUFSZ = 0x80,
    ERNIE_CMD_GET_SCRATCHPAD = 0x90,
    ERNIE_CMD_SET_SCRATCHPAD = 0x91,
    ERNIE_CMD_3AUTH_DEFAULT = 0xA0,
    ERNIE_CMD_CTRL_HOVD = 0xB2,
    ERNIE_CMD_SET_UART0 = 0x190,
    ERNIE_CMD_GET_KERMITJIG_SHBUF = 0x2083,
    ERNIE_CMD_SET_KERMITJIG_SHBUF = 0x2085,
};

enum ERNIE_UART0_SWITCH_MODES {
    ERNIE_UART0_MODE_ERNIE,
    ERNIE_UART0_MODE_KERMIT,
    ERNIE_UART0_MODE_OFF = 0xFF,
};

#define ERNIE_3AUTH_SIZE 0x28

#ifndef ERNIE_UNUSE
extern ernie_comms_t g_ernie_comms;
uint32_t ernie_init(bool set_kbsz, bool enable_3auth);
void ernie_write(uint8_t* data, uint8_t size);
bool ernie_read(uint8_t *data, uint8_t max_size);
int ernie_exec(uint8_t* tx, uint8_t tx_size, uint8_t* rx, uint8_t rx_size);
int ernie_exec_cmd(uint16_t cmd, void *data_in, uint8_t data_in_size);
int ernie_exec_cmd_short(uint16_t cmd, uint32_t data_in, uint8_t data_in_size);
void ernie_3auth_single(uint8_t keyset_id, uint8_t* key, uint8_t* data);
#else
#define ernie_init(...) stub()
#define ernie_write(...) stub()
#define ernie_read(...) stub()
#define ernie_exec(...) stub()
#define ernie_exec_cmd(...) stub()
#define ernie_exec_cmd_short(...) stub()
#define ernie_3auth_single(...) stub()
#endif

#endif