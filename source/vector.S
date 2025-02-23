.section .text.vectors

.global vectors_exceptions
vectors_exceptions:
jmp s_RESET
jmp c_OTHER_EXC
jmp c_OTHER_EXC
jmp c_OTHER_EXC
jmp c_OTHER_EXC
jmp s_SWI
jmp s_DBG
jmp c_OTHER_EXC
jmp c_OTHER_EXC
jmp c_OTHER_EXC
jmp c_OTHER_EXC
jmp c_OTHER_EXC
jmp c_OTHER_EXC

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

.global s_rpc_loop
s_rpc_loop:
jmp rpc_loop

.global s_ce_framework
s_ce_framework:
jmp ce_framework

.global g_state
.type   g_state, @object
g_state:
.word 0x0

.global g_config
.type   g_config, @object
g_config:
.word 0x0, 0x0, 0x0, 0x0
