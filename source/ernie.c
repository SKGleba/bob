#include "include/types.h"
#include "include/clib.h"
#include "include/gpio.h"
#include "include/spi.h"
#include "include/ernie.h"

ernie_comms_t g_ernie_comms;

void ernie_write(uint8_t *data, uint8_t size) {
    gpio_port_clear(0, GPIO_PORT_ERNIE_OUT);
    spi_write_start(0);
    for (int i = 0; i < size; i+=2)
        spi_write(0, (data[i + 1] << 8) | data[i]);
    spi_write_end(0);
    gpio_port_set(0, GPIO_PORT_ERNIE_OUT);
}

bool ernie_read(uint8_t *data, uint8_t max_size) {
    while (!gpio_query_intr(0, GPIO_PORT_ERNIE_IN)){};
    gpio_acquire_intr(0, GPIO_PORT_ERNIE_IN);
    uint8_t data_read = 0;
    uint32_t tmp_rd = 0;
    bool is_oob = false;
    while (spi_read_available(0)) {
        if (data_read >= max_size) {
            is_oob = true;
            break;
        }
        tmp_rd = spi_read(0);
        data[data_read] = tmp_rd & 0xFF;
        if (data_read + 1 < max_size)
            data[data_read + 1] = (tmp_rd >> 8) & 0xFF;
        data_read += 2;
    }
    spi_read_end(0);
    gpio_port_clear(0, GPIO_PORT_ERNIE_OUT);
    return is_oob;
}

void ernie_exec(ernie_comms_t *comms) {
    uint8_t hash = 0, result = 0;
    uint8_t length = comms->tx[ERNIE_TX_LENGTH];
    for (uint8_t i = 0; i < length + 2; i++)
        hash += comms->tx[i];
    comms->tx[2 + length] = ~hash;
    memset(&comms->tx[3 + length], -1, sizeof(comms->rx) - (3 + length));
    do {
        memset(comms->rx, -1, sizeof(comms->rx));
        ernie_write(comms->tx, length + 3);
        ernie_read(comms->rx, sizeof(comms->rx));
        result = comms->rx[ERNIE_RX_RESULT];
    } while (result == 0x80 || result == 0x81);
}

int ernie_exec_cmd(uint16_t cmd, void *data_in, uint8_t data_in_size) {
    if (data_in_size + ERNIE_TX_DATA(1) > sizeof(g_ernie_comms.tx))
        return -1;
    memset(&g_ernie_comms, 0, sizeof(g_ernie_comms));
    g_ernie_comms.tx[ERNIE_TX_CMD_LO] = cmd & 0xFF;
    g_ernie_comms.tx[ERNIE_TX_CMD_HI] = (cmd >> 8) & 0xFF;
    g_ernie_comms.tx[ERNIE_TX_LENGTH] = 1 + data_in_size;
    if (data_in)
        memcpy(&g_ernie_comms.tx[ERNIE_TX_DATA(0)], data_in, data_in_size);
    ernie_exec(&g_ernie_comms);
    return (int)*(uint32_t *)(g_ernie_comms.rx);
}

int ernie_exec_cmd_short(uint16_t cmd, uint32_t data_in, uint8_t data_in_size) {
    return ernie_exec_cmd(cmd, (data_in_size) ? &data_in : NULL, data_in_size);
}
