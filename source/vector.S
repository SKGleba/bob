.section .text.vectors

.global vectors_exceptions
vectors_exceptions:
jmp c_RESET
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

.global s_get_build_timestamp
s_get_build_timestamp:
jmp get_build_timestamp

.global s_printFormat
s_printFormat:
jmp debug_printFormat

.global s_setDbg
s_setDbg:
jmp set_dbg_mode