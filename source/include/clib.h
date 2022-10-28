#ifndef __CLIB_H__
#define __CLIB_H__

#include "types.h"

void* memset(void* s, uint8_t c, uint32_t n);
void* memset32(void* s, uint32_t c, uint32_t n);
void* memset8(void* s, uint8_t c, uint32_t n);
void* memcpy(void* dest, const void* src, uint32_t n);
int memcmp(const void* s1, const void* s2, uint32_t n);
uint32_t strlen(const char* str);

#endif