.section .text.exs

.global ex_save_ctx
.type	ex_save_ctx, @function
ex_save_ctx:
sw $1, 0x4($sp)
sw $2, 0x8($sp)
sw $3, 0xC($sp)
sw $4, 0x10($sp)
sw $5, 0x14($sp)
sw $6, 0x18($sp)
sw $7, 0x1C($sp)
sw $8, 0x20($sp)
sw $9, 0x24($sp)
sw $10, 0x28($sp)
sw $11, 0x2C($sp)
sw $12, 0x30($sp)
sw $tp, 0x34($sp)
sw $gp, 0x38($sp)
ldc $12, $tmp
sw $12, 0x3C($sp)
sw $0, 0x40($sp)
ldc $12, $sar
sw $12, 0x44($sp)
ldc $12, $rpb
sw $12, 0x48($sp)
ldc $12, $rpe
sw $12, 0x4C($sp)
ldc $12, $rpc
sw $12, 0x50($sp)
ldc $12, $hi
sw $12, 0x54($sp)
ldc $12, $lo
sw $12, 0x58($sp)
ldc $12, $epc
sw $12, 0x5C($sp)
ret

.global ex_restore_ctx
.type	ex_restore_ctx, @function
ex_restore_ctx:
lw $1, 0x4($sp)
lw $2, 0x8($sp)
lw $3, 0xC($sp)
lw $4, 0x10($sp)
lw $5, 0x14($sp)
lw $6, 0x18($sp)
lw $7, 0x1C($sp)
lw $8, 0x20($sp)
lw $9, 0x24($sp)
lw $10, 0x28($sp)
lw $11, 0x2C($sp)
lw $tp, 0x34($sp)
lw $gp, 0x38($sp)
lw $12, 0x40($sp)
stc $12, $tmp
lw $12, 0x44($sp)
stc $12, $sar
lw $12, 0x48($sp)
stc $12, $rpb
lw $12, 0x4C($sp)
stc $12, $rpe
lw $12, 0x50($sp)
stc $12, $rpc
lw $12, 0x54($sp)
stc $12, $hi
lw $12, 0x58($sp)
stc $12, $lo
lw $12, 0x5C($sp)
stc $12, $epc
lw $12, 0x30($sp)
ret

.global s_SWI
.type	s_SWI, @function
s_SWI:
di
stc $sp, $tmp
add3 $sp, $sp, -0x60
sw $0, 0x0($sp)
ldc $0, $lp
bsr ex_save_ctx
bsr c_SWI
bsr ex_restore_ctx
ldc $0, $tmp
stc $0, $lp
lw $0, 0x0($sp)
add3 $sp, $sp, 0x60
ei
reti

.global s_IRQ
.type	s_IRQ, @function
s_IRQ:
di
stc $sp, $tmp
add3 $sp, $sp, -0x60
sw $0, 0x0($sp)
ldc $0, $lp
bsr ex_save_ctx
bsr c_IRQ
bsr ex_restore_ctx
ldc $0, $tmp
stc $0, $lp
lw $0, 0x0($sp)
add3 $sp, $sp, 0x60
ei
reti

.global s_ARM_REQ
.type	s_ARM_REQ, @function
s_ARM_REQ:
di
stc $sp, $tmp
add3 $sp, $sp, -0x60
sw $0, 0x0($sp)
ldc $0, $lp
bsr ex_save_ctx
bsr c_ARM_REQ
bsr ex_restore_ctx
ldc $0, $tmp
stc $0, $lp
lw $0, 0x0($sp)
add3 $sp, $sp, 0x60
ei
reti

.global s_DBG
.type	s_DBG, @function
s_DBG:
di
stc $sp, $tmp
add3 $sp, $sp, -0x60
sw $0, 0x0($sp)
ldc $0, $lp
bsr ex_save_ctx
bsr c_DBG
bsr ex_restore_ctx
ldc $0, $tmp
stc $0, $lp
add3 $sp, $sp, 0x60
ldc $0, $depc
ei
jmp $0

.global s_GLITCH
.type	s_GLITCH, @function
s_GLITCH:
di
movh $sp, 0x5
or3	$sp, $sp, 0xfff0
.LGLITCH:
bsr glitch_init
bra .LGLITCH

.global s_RESET
.type	s_RESET, @function
s_RESET:
di
mov $gp, $0
ldc $0, $pc
movh $sp, 0x4
or3	$sp, $sp, 0x9000
sltu3 $0, $sp, $0
beqz $0, .LNG
movh $sp, 0x80
or3	$sp, $sp, 0x9000
mov $0, $gp
movh $gp, 0x80
or3	$gp, $gp, 0xfc00
bra .LJMP
.LNG:
mov $0, $gp
movh $gp, 0x4
or3	$gp, $gp, 0xfc00
.LJMP:
jmp c_RESET
