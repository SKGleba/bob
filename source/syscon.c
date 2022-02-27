#include "include/types.h"
#include "include/clib.h"
#include "include/gpio.h"
#include "include/spi.h"
#include "include/syscon.h"

static void syscon_packet_start(struct syscon_packet* packet) {
    int i = 0;
    unsigned char cmd_size = packet->tx[2];
    unsigned char tx_total_size = cmd_size + 3;
    unsigned int offset;
    (void)offset;
    gpio_port_clear(0, GPIO_PORT_SYSCON_OUT);
    spi_write_start(0);
    if (cmd_size <= 29) {
        offset = 2;
    }
    do {
        spi_write(0, (packet->tx[i + 1] << 8) | packet->tx[i]);
        i += 2;
    } while (i < tx_total_size);
    spi_write_end(0);
    gpio_port_set(0, GPIO_PORT_SYSCON_OUT);
}

static unsigned char syscon_cmd_sync(struct syscon_packet* packet) {
    int i = 0;
    while (!gpio_query_intr(0, GPIO_PORT_SYSCON_IN))
        ;
    gpio_acquire_intr(0, GPIO_PORT_SYSCON_IN);
    while (spi_read_available(0)) {
        unsigned int data = spi_read(0);
        packet->rx[i] = data & 0xFF;
        packet->rx[i + 1] = (data >> 8) & 0xFF;
        i += 2;
    }
    spi_read_end(0);
    gpio_port_clear(0, GPIO_PORT_SYSCON_OUT);
    return packet->rx[SYSCON_RX_RESULT];
}

int syscon_common_read(unsigned int* buffer, unsigned short cmd) {
    struct syscon_packet packet;
    packet.tx[SYSCON_TX_CMD_LO] = cmd & 0xFF;
    packet.tx[SYSCON_TX_CMD_HI] = (cmd >> 8) & 0xFF;
    packet.tx[SYSCON_TX_LENGTH] = 1;
    memset(packet.rx, 0x69, sizeof(packet.rx));
    syscon_packet_start(&packet);
    syscon_cmd_sync(&packet);
    memcpy(buffer, &packet.rx[4], packet.rx[SYSCON_RX_LENGTH] - 2);
    return *(uint32_t*)packet.rx;
}

void syscon_common_write(unsigned int data, unsigned short cmd, unsigned int length) {
    unsigned int i;
    unsigned char hash, result;
    struct syscon_packet packet;
    packet.tx[SYSCON_TX_CMD_LO] = cmd & 0xFF;
    packet.tx[SYSCON_TX_CMD_HI] = (cmd >> 8) & 0xFF;
    packet.tx[SYSCON_TX_LENGTH] = length;
    packet.tx[SYSCON_TX_DATA(0)] = data & 0xFF;
    packet.tx[SYSCON_TX_DATA(1)] = (data >> 8) & 0xFF;
    packet.tx[SYSCON_TX_DATA(2)] = (data >> 16) & 0xFF;
    packet.tx[SYSCON_TX_DATA(3)] = (data >> 24) & 0xFF;
    hash = 0;
    for (i = 0; i < length + 2; i++)
        hash += packet.tx[i];
    packet.tx[2 + length] = ~hash;
    memset(&packet.tx[3 + length], -1, sizeof(packet.rx) - (3 + length));
    do {
        memset(packet.rx, -1, sizeof(packet.rx));
        syscon_packet_start(&packet);

        result = syscon_cmd_sync(&packet);
    } while (result == 0x80 || result == 0x81);
}