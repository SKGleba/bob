.section .cfgdata

.global g_bobcprm
.type   g_bobcprm, @object
g_bobcprm:
.word PROG_act_size, PROG_bss_end, cfg_sp_addr, cfg_sp_size

.global g_config
.type   g_config, @object
g_config:
.word 0x0, 0x0, 0x0, 0x0

.global g_iceparams
.type   g_iceparams, @object
g_iceparams:
.word 0,0,0,0,0,0,0,0,0,0,0,0
.word 0,0,0,0,0,0,0,0,0,0,0,0
.word 0,0,0 # padding for 1+4x!ext stuffing

.global g_debug_route
.type   g_debug_route, @object
g_debug_route:
.word 0x0

.global g_debug_level
.type   g_debug_level, @object
g_debug_level:
.word 0x3

.global g_state
.type   g_state, @object
g_state:
.word 0x0

.global g_exparam
.type   g_exparam, @object
g_exparam:
.word (((PROG_exports_end - PROG_exports_start) / 4) | (PROG_xpoff << 16))
