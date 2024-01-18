#ifndef __MAIKA_H__
#define __MAIKA_H__

#include <hardware/maika.h>

#include "types.h"

/*
    Funcs
*/
// read data from [addr] with/as [mode]
uint32_t readAs(uint32_t addr, uint32_t mode);

// write [data] to [addr] with/as [mode]
void writeAs(uint32_t addr, uint32_t data, uint32_t mode);

uint32_t keyring_slot_data(bool set, void* data, int datasize, uint32_t keyslot);
uint32_t keyring_slot_prot(bool set, uint32_t prot, uint32_t keyslot);

#undef reg

#endif