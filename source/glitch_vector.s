.section .text.vectors

.global vectors_exceptions
vectors_exceptions:
jmp s_GLITCH
jmp s_GLITCH
jmp s_GLITCH
jmp s_GLITCH
jmp s_GLITCH
jmp s_GLITCH
jmp s_GLITCH
jmp s_GLITCH
jmp s_GLITCH
jmp s_GLITCH
jmp s_GLITCH
jmp s_GLITCH
jmp s_GLITCH

.global vectors_interrupts
vectors_interrupts:
jmp s_IRQ
jmp s_IRQ
jmp s_IRQ
jmp s_IRQ
jmp s_IRQ
jmp s_IRQ
jmp s_IRQ
jmp s_ARM_REQ
jmp s_IRQ
jmp s_IRQ
jmp s_IRQ
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT
jmp c_OTHER_INT

.global s_init
s_init:
jmp init

.global s_glitch_init
s_glitch_init:
jmp glitch_init

.global s_get_build_timestamp
s_get_build_timestamp:
jmp get_build_timestamp

.global s_printFormat
s_printFormat:
jmp debug_printFormat

.global s_alice_stopReloadAlice
s_alice_stopReloadAlice:
jmp alice_stopReloadAlice

.global jmp_s_reset_xc
jmp_s_reset_xc:
jmp s_RESET

.global jmp_s_swi_xc
jmp_s_swi_xc:
jmp s_SWI

.global jmp_s_dbg_xc
jmp_s_dbg_xc:
jmp s_DBG

.global jmp_s_glitch_xc
jmp_s_glitch_xc:
jmp s_GLITCH

.global jmp_c_other_xc
jmp_c_other_xc:
jmp c_OTHER_EXC
