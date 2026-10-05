#include "include/defs.h"

.section .text.exports

.macro Y name func
.global x_\name
x_\name:
	jmp \func
.endm

.macro X func
    Y \func \func
.endm

#ifdef BOBT_FSM
    #define IFSM(_z) X _z
#else
    #define IFSM(_z) Y _z stub
#endif

#ifndef COMPAT_UNUSE
    #define IFCOMPAT(_z) X _z
#else
    #define IFCOMPAT(_z) Y _z stub
#endif

#ifndef ALICE_UNUSE
    #define IFALICE(_z) X _z
#else
    #define IFALICE(_z) Y _z stub
#endif

#ifndef REGINA_UNUSE
    #define IFREGINA(_z) X _z
#else
    #define IFREGINA(_z) Y _z stub
#endif

#ifndef DRAM_UNUSE
    #define IFDRAM(_z) X _z
#else
    #define IFDRAM(_z) Y _z stub
#endif

#ifndef SDIF_UNUSE
    #define IFSDIF(_z) X _z
#else
    #define IFSDIF(_z) Y _z stub
#endif

.word 0xB0B1D2FC
IFALICE(alice_stopReloadAlice)
X rpc_loop
X ce_framework
X get_build_timestamp
X c3p_machine
IFSM(tfsm_init)
X debug_printFormat
X debug_s_regdump
X memcpy
X memset
X memset32
IFCOMPAT(compat_armReBoot)
IFCOMPAT(compat_handleAllegrex)
IFCOMPAT(compat_pspemuColdInit)
X set_exception_table
IFALICE(alice_get_task_status)
IFALICE(alice_schedule_bob_task)
IFDRAM(dram_init)
IFSDIF(stor_read_sd)
IFSDIF(stor_write_sd)
IFSDIF(stor_read_emmc)
IFSDIF(stor_write_emmc)
X intr_mask
IFALICE(alice_loadAlice)
IFREGINA(regina_loadRegina)


