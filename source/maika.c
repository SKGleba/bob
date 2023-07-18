#include "include/types.h"
#include "include/clib.h"
#include "include/paddr.h"
#include "include/maika.h"

// --maika::readas--
uint32_t readAs(uint32_t addr, uint32_t mode) {
    maika_s* maika = (maika_s*)MAIKA_OFFSET;
    
    maika->aio.readAs.addr = addr;
    maika->aio.readAs.data = 0xDEADBABE;
    maika->aio.readAs.mode = mode;

    while (maika->aio.readAs.data == 0xDEADBABE) {} // wait until RAS replies

    return maika->aio.readAs.data;
}

void writeAs(uint32_t addr, uint32_t data, uint32_t mode) {
    maika_s* maika = (maika_s*)MAIKA_OFFSET;
    
    maika->aio.readAs.addr = addr;
    maika->aio.readAs.data = data;
    maika->aio.readAs.mode = mode | MAIKA_RAS_MODE_WRITE;
}


// --maika::krctrl--
uint32_t keyring_slot_data(bool set, void* data, int datasize, uint32_t keyslot) {
    maika_s* maika = (maika_s*)MAIKA_OFFSET;
    if (datasize > MAIKA_KEYSLOT_SIZE || keyslot > (MAIKA_KEYSLOT_COUNT * 2))
        return -1;
    if (!set) {
        if (keyslot < MAIKA_KEYSLOT_COUNT)
            return -2;
        keyslot = keyslot - MAIKA_KEYSLOT_COUNT; // first 0x400 keyslots are in bigmac
        memcpy(data, (maika_s*)maika->keyring[keyslot], datasize);
        return keyslot;
    }
    memcpy((void*)maika->keyring_ctrl.data, data, datasize);
    maika->keyring_ctrl.keyslot = (uint32_t)keyslot;
    return maika->keyring_ctrl.resp;
}

uint32_t keyring_slot_prot(bool set, uint32_t prot, uint32_t keyslot) {
    maika_s* maika = (maika_s*)MAIKA_OFFSET;
    if (set)
        maika->keyring_ctrl.set_prot = (uint32_t)((prot << 16) | keyslot);
    maika->keyring_ctrl.get_prot = keyslot;
    return maika->keyring_ctrl.resp;
}