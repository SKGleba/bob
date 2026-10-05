.section .text.vectors

.global vectors_exceptions
vectors_exceptions:
#if !defined(BOBT_GLITCH)
    jmp s_RESET
    #if !defined(BOBT_FSM)
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
    #endif
#else
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
#endif

.global vectors_interrupts
vectors_interrupts:
#ifndef BOBT_FSM
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
#else
    .word 0,0,0 # padding | TODO: some module-specific calls?
#endif

.global s_init
s_init:
jmp init

.global s_glitch_init
s_glitch_init:
jmp glitch_init

.global g_cfgoff
g_cfgoff:
.word PROG_cfgoff
