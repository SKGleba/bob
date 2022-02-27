#include "include/types.h"
#include "include/clib.h"

void* memset(void* s, uint8_t c, uint32_t n) {
    char* z = s;

    while (n) {
        *z++ = c;
        n--;
    }

    return s;
}

void* memcpy(void* dest, const void* src, uint32_t n) {
    const char* s = src;
    char* d = dest;

    while (n) {
        *d++ = *s++;
        n--;
    }

    return dest;
}

int memcmp(const void* s1, const void* s2, uint32_t n) {
    unsigned char u1, u2;

    for (; n--; s1++, s2++) {
        u1 = *(unsigned char*)s1;
        u2 = *(unsigned char*)s2;
        if (u1 != u2)
            return u1 - u2;
    }

    return 0;
}

uint32_t strlen(const char* str) {
    const char* s = str;

    while (*s)
        s++;

    return s - str;
}