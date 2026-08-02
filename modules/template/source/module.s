.section .text.modinfo

.global xm_j_init
xm_j_init:
    jmp xm_init

.global xm_bssinfo
xm_bssinfo:
    .word __mod_bss_start__, __mod_bss_end__
    