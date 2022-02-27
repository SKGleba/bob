#include "include/types.h"
#include "include/clib.h"
#include "include/maika.h"

// --maika::readas--
static volatile readas32_t* const READAS32 = (void*)READAS_REG;

uint32_t readAs(uint32_t addr, uint32_t mode) {
    READAS32->addr = addr;
    READAS32->data = 0xDEADBABE;
    READAS32->mode = mode;

    while (READAS32->data == 0xDEADBABE) {} // wait until RAS replies

    return READAS32->data;
}

void writeAs(uint32_t addr, uint32_t data, uint32_t mode) {
    READAS32->addr = addr;
    READAS32->data = data;
    READAS32->mode = mode | RAS_MODE_WRITE;
}


// --maika::krctrl--
static volatile keyring_ctrl_t* const KRCTRL = (void*)KEYRING_CONTROLLER;

uint32_t keyring_slot_data(int set, void* data, int datasize, uint32_t keyslot) {
    if (set) {
        memcpy((void *)KRCTRL->data, data, datasize);
        KRCTRL->keyslot = (uint32_t)keyslot;
    } else
        memcpy(data, (void*)KEYRING_SLOT(keyslot), datasize);
    return KRCTRL->resp;
}

uint32_t keyring_slot_prot(int set, uint32_t prot, uint32_t keyslot) {
    if (set)
        KRCTRL->set_prot = (uint32_t)((prot << 16) | keyslot);
    KRCTRL->get_prot = keyslot;
    return KRCTRL->resp;
}