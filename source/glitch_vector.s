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
jmp s_IRQ
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

.global s_keygx
s_keygx:
jmp crypto_keygx

.global g_bobcprm
.type   g_bobcprm, @object
g_bobcprm:
.word PROG_cfgoff, PROG_bss_end, PROG_act_size, cfg_sp_addr
