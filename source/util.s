.global delay
.type	delay, @function
delay:
    add3 $1, $1, -1
    bnez $1, delay
    ret

.global cbus_read
.type	cbus_read, @function
cbus_read:
    movu $3, _cb_r_ins+2
    sh $1, ($3)
    .word 0x0
    .word 0x0
    .word 0x0
    .word 0x0
    .global _cb_r_ins
    _cb_r_ins:
        .word 0xf014
    .word 0x0
    ret

.global cbus_write
.type	cbus_write, @function
cbus_write:
    movu $3, _cb_w_ins+2
    sh $1, ($3)
    .word 0x0
    .word 0x0
    .word 0x0
    .word 0x0
    .global _cb_w_ins
    _cb_w_ins:
        .word 0xf204
    .word 0x0
    ret

.global set_dbg_mode
.type	set_dbg_mode, @function
set_dbg_mode:
    bnez $1, 2f
1:
    ldc $0, $lp
    stc $0, $depc
    mov $0, $0
    dret
    mov $0, $0
    bra 3f
2: dbreak
3: nop
    ret

.global enable_icache
.type	enable_icache, @function
enable_icache:
    ldc $0, $cfg
    beqz $1, 2f
1:
    or3 $0, $0, 0x2
    stc $0, $cfg
    bra 3f
2:
    mov $1, -3 # 0xfffd
    and $0, $1
    stc $0, $cfg
3: syncm
    ldc $0, $cfg
    and3 $0, $0, 0x2
    sltu3 $0, $0, 1
    xor3 $0, $0, 0x1
    extub $0
    ret
