#ifndef __TYPES_H__
#define __TYPES_H__

typedef unsigned char uint8_t;             ///< Unsigned 8-bit type
typedef unsigned short int uint16_t;       ///< Unsigned 16-bit type
typedef unsigned int uint32_t;             ///< Unsigned 32-bit type
typedef unsigned long long uint64_t;        ///< Unsigned 64-bit type

// dont ask
typedef int bool;
#define true 1
#define false 0

#define NULL (void*)0

typedef __builtin_va_list va_list;
#define va_start(v,l)	__builtin_va_start(v,l)
#define va_end(v)	__builtin_va_end(v)
#define va_arg(v,l)	__builtin_va_arg(v,l)
#define va_copy(d,s)	__builtin_va_copy(d,s)

#endif