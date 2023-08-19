	.file	"compat.c"
	.section .frodata,"a"
	.p2align 2
	.type	skso_iv, @object
	.size	skso_iv, 16
skso_iv:
	.byte	-95
	.byte	50
	.byte	90
	.byte	-40
	.byte	-71
	.byte	33
	.byte	47
	.byte	-17
	.byte	114
	.byte	22
	.byte	-17
	.byte	-5
	.byte	48
	.byte	-53
	.byte	77
	.byte	-4
	.section .farbss,"aw"
	.p2align 2
	.type	compat_state,@object
	.size	compat_state,4
compat_state:
	.zero	4
	.text
	.core
	.p2align 1
	.globl compat_Cry2Arm0
	.type	compat_Cry2Arm0, @function
compat_Cry2Arm0:
	extuh	$1
	bnez	$1, .L2
.L4:
	movh	$3, 0xe000
	lw	$0, ($3)
	ret
.L2:
	movh	$3, 0xe000
	sw	$1, ($3)
	syncm
	erepeat	.L7
	lw	$2, ($3)
.L7:
	and3	$2, $2, 0xffff
	beqz	$2, .L8
	# erepeat end
.L8:
	bra	.L4
	.size	compat_Cry2Arm0, .-compat_Cry2Arm0
	.p2align 1
	.type	compat_IRQ7_resetPervDevice, @function
compat_IRQ7_resetPervDevice:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	mov	$4, 0
	mov	$3, 1
	mov	$2, 1
	mov	$1, 100
	sw	$11, 4($sp)
	bsr	pervasive_control_reset
	mov	$4, 1
	mov	$3, 0
	mov	$2, 1
	mov	$1, 100
	bsr	pervasive_control_reset
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	compat_IRQ7_resetPervDevice, .-compat_IRQ7_resetPervDevice
	.p2align 1
	.type	compat_IRQ7_setEmmcKeyslots, @function
compat_IRQ7_setEmmcKeyslots:
	movh	$3, 0xe003
	movh	$2, 0x1fef
	or3	$3, $3, 0x24
	or3	$2, $2, 0x20f
	sw	$2, ($3)
	movh	$2, 0x1fef
	or3	$2, $2, 0x20e
	sw	$2, ($3)
	movh	$3, 0xe007
	movh	$2, 0x20e
	or3	$3, $3, 0x8
	or3	$2, $2, 0x20f
	sw	$2, ($3)
	movh	$3, 0xe007
	beqz	$1, .L11
	mov	$2, 0
	sw	$2, ($3)
	ret
.L11:
	mov	$2, 1
	sw	$2, ($3)
	ret
	.size	compat_IRQ7_setEmmcKeyslots, .-compat_IRQ7_setEmmcKeyslots
	.p2align 1
	.type	compat_IRQ7_setSomeEmmcDatax14, @function
compat_IRQ7_setSomeEmmcDatax14:
	movh	$3, 0xe310
	movu	$1, 16777199
	lw	$3, ($3)
	mov	$2, 32
	and	$1, $3
	beq	$1, $2, .L13
	movu	$2, 16777215
	and	$3, $2
	mov	$2, 50
	beq	$3, $2, .L13
	movh	$3, 0xe007
	or3	$3, $3, 0x14
	mov	$2, 6
	sw	$2, ($3)
.L13:
	ret
	.size	compat_IRQ7_setSomeEmmcDatax14, .-compat_IRQ7_setSomeEmmcDatax14
	.p2align 1
	.type	compat_IRQ7_genSKSO, @function
compat_IRQ7_genSKSO:
	# frame: 232   24 regs   192 locals   16 args
	ldc	$11, $lp
	add	$sp, -24
	movh	$3, 0xacb4
	sw	$11, 4($sp)
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	or3	$3, $3, 0xacb1
	add3	$sp, $sp, -208 # 0xff30
	sw	$3, 48($sp)
	movh	$3, 0xe005
	mov	$6, 1
	or3	$3, $3, 0x3c
	sw	$6, 52($sp)
	lw	$3, ($3)
	mov	$5, 0
	mov	$4, 1297 # 0x511
	sw	$3, 56($sp)
	add3	$2, $sp, 64
	mov	$3, 32
	mov	$1, 0
	sw	$5, 60($sp)
	bsr	keyring_slot_data
	mov	$4, 1298 # 0x512
	mov	$3, 32
	add3	$2, $sp, 96
	mov	$1, 0
	bsr	keyring_slot_data
	mov	$4, 1303 # 0x517
	mov	$3, 32
	add3	$2, $sp, 128
	mov	$1, 0
	bsr	keyring_slot_data
	mov	$4, 1305 # 0x519
	mov	$3, 32
	add3	$2, $sp, 160
	mov	$1, 0
	bsr	keyring_slot_data
	mov	$3, 32
	mov	$2, 0
	add3	$1, $sp, 16
	bsr	memset
	mov	$4, 1300 # 0x514
	mov	$3, 32
	add3	$2, $sp, 16
	mov	$1, 0
	bsr	keyring_slot_data
	movh	$1, 0xe005
	mov	$3, 32
	add3	$2, $sp, 16
	or3	$1, $1, 0x200
	bsr	memcpy
	mov	$3, 9147 # 0x23bb
	sw	$5, 12($sp)
	sw	$5, 8($sp)
	sw	$5, 4($sp)
	sw	$3, ($sp)
	mov	$4, 144
	add3	$3, $sp, 192
	add3	$2, $sp, 48
	mov	$1, 0
	bsr	crypto_bigmacDefaultCmd
	mov	$5, $0
	bnez	$0, .L15
	mov	$4, 1301 # 0x515
	mov	$3, 32
	add3	$2, $sp, 16
	mov	$1, 0
	bsr	keyring_slot_data
	movh	$1, 0xe005
	mov	$3, 32
	add3	$2, $sp, 16
	or3	$1, $1, 0x200
	bsr	memcpy
	movh	$3, %hi(skso_iv)
	add3	$3, $3, %lo(skso_iv)
	sw	$3, 8($sp)
	mov	$3, 8585 # 0x2189
	sw	$3, ($sp)
	add3	$3, $sp, 48
	sw	$5, 12($sp)
	sw	$5, 4($sp)
	mov	$4, 160
	mov	$2, $3
	mov	$1, 0
	bsr	crypto_bigmacDefaultCmd
	bnez	$0, .L15
	movh	$1, 0x4001
	mov	$3, 160
	add3	$2, $sp, 48
	or3	$1, $1, 0xff00
	bsr	memcpy
	mov	$3, 32
	mov	$2, 0
	add3	$1, $sp, 16
	bsr	memset
	mov	$4, 1302 # 0x516
	mov	$3, 32
	add3	$2, $sp, 16
	mov	$1, 1
	sb	$6, 16($sp)
	bsr	keyring_slot_data
.L15:
	add3	$sp, $sp, 208
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
	.size	compat_IRQ7_genSKSO, .-compat_IRQ7_genSKSO
	.section	.rodata
	.p2align 2
.LC0:
	.string	"ARM"
	.text
	.core
	.p2align 1
	.type	compat_IRQ7_armPanic, @function
compat_IRQ7_armPanic:
	# frame: 16   16 regs
	movh	$3, %hi(compat_state)
	mov	$2, 9
	add	$sp, -16
	ldc	$11, $lp
	sw	$2, %lo(compat_state)($3)
	mov	$1, 0
	mov	$2, 15
	sw	$11, 4($sp)
	bsr	cbus_write
#APP
;# 91 "source/compat.c" 1
	mov $0, $0

;# 0 "" 2
#NO_APP
	syncm
#APP
;# 93 "source/compat.c" 1
	mov $0, $0

;# 0 "" 2
#NO_APP
	mov	$2, 0
	movu	$1, .LC0
	bsr	PANIC
	.size	compat_IRQ7_armPanic, .-compat_IRQ7_armPanic
	.section	.rodata
	.p2align 2
.LC1:
	.string	"NOEXIT"
	.text
	.core
	.p2align 1
	.type	compat_IRQ7_forceExitSm, @function
compat_IRQ7_forceExitSm:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	mov	$1, 1
	sw	$11, 4($sp)
	bsr	crypto_waitStopBigmacOps
	mov	$4, 0
	movu	$3, 0x16000
	movu	$2, 0x80a000
	mov	$1, 0
	bsr	crypto_memset
	movh	$3, 0xe000
	mov	$2, -1 # 0xffff
	sw	$2, 20($3)
	mov	$1, 260 # 0x104
	sw	$2, 24($3)
	sw	$2, 28($3)
	sw	$2, 68($3)
	sw	$2, 72($3)
	sw	$2, 76($3)
	mov	$2, 7
	movh	$3, %hi(compat_state)
	sw	$2, %lo(compat_state)($3)
	bsr	compat_Cry2Arm0
#APP
;# 112 "source/compat.c" 1
	jmp vectors_exceptions

;# 0 "" 2
#NO_APP
	mov	$2, 0
	movu	$1, .LC1
	bsr	PANIC
	.size	compat_IRQ7_forceExitSm, .-compat_IRQ7_forceExitSm
	.section	.rodata
	.p2align 2
.LC2:
	.string	"[BOB] got ARM cmd %X\n"
	.p2align 2
.LC3:
	.string	"[BOB] compat service terminated\n"
	.p2align 2
.LC4:
	.string	"[BOB] invalid arg for alice acquire\n"
	.text
	.core
	.p2align 1
	.globl compat_IRQ7_handleCmd
	.type	compat_IRQ7_handleCmd, @function
compat_IRQ7_handleCmd:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$6, 8($sp)
	movh	$6, %hi(compat_state)
	add3	$6, $6, %lo(compat_state)
	ldc	$11, $lp
	lw	$0, ($6)
	sw	$5, 12($sp)
	sw	$7, 4($sp)
	sw	$11, ($sp)
	mov	$5, $1
	mov	$7, $4
	bgei	$0, 0, .L22
	bsr	alice_handleCmd
	sw	$0, ($6)
.L21:
	lw	$7, 4($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, ($sp)
	add	$sp, 24
	jmp	$11
.L22:
	mov	$1, 33
	bsr	debug_setGpoCode
	mov	$2, $5
	movu	$1, .LC2
	bsr	debug_printFormat
	mov	$0, 3073 # 0xc01
	beq	$5, $0, .L24
	sltu3	$0, $0, $5
	bnez	$0, .L25
	mov	$3, 1537 # 0x601
	beq	$5, $3, .L26
	mov	$3, 2817 # 0xb01
	beq	$5, $3, .L27
	mov	$3, 257 # 0x101
	bne	$5, $3, .L21
.L26:
	mov	$2, -1 # 0xffff
	movh	$3, 0xe000
	sw	$2, 16($3)
	mov	$1, 0
	bsr	compat_Cry2Arm0
	beqz	$0, .L35
	mov	$1, 29
	bsr	debug_setGpoCode
	movu	$1, 0x802d
	bsr	compat_Cry2Arm0
	bra	.L21
.L25:
	mov	$0, 3585 # 0xe01
	beq	$5, $0, .L27
	sltu3	$0, $0, $5
	bnez	$0, .L28
	mov	$3, 3329 # 0xd01
	bne	$5, $3, .L21
.L24:
	movh	$3, 0xe006
	or3	$3, $3, 0x2180
	lw	$3, ($3)
	and3	$3, $3, 0x4
	beqz	$3, .L21
.L27:
	mov	$1, 28
	bsr	debug_setGpoCode
	bsr	compat_IRQ7_resetPervDevice
	xor3	$1, $5, 0xc01
	sltu3	$1, $1, 1
	xor3	$1, $1, 0x1
	bsr	compat_IRQ7_setEmmcKeyslots
	mov	$3, 3585 # 0xe01
	bne	$5, $3, .L21
	bsr	compat_IRQ7_setSomeEmmcDatax14
	bra	.L21
.L28:
	mov	$3, 3841 # 0xf01
	beq	$5, $3, .L29
	movh	$3, 0x5e7a
	or3	$3, $3, 0x21ce
	bne	$5, $3, .L21
	bne	$7, $5, .L31
	mov	$5, -1 # 0xffff
	movu	$1, .LC3
	sw	$5, ($6)
	bsr	debug_printFormat
	movh	$3, 0xe000
	sw	$5, 28($3)
	sw	$5, 24($3)
	sw	$5, 20($3)
	bra	.L21
.L31:
	movu	$1, .LC4
	bsr	debug_printFormat
	bra	.L21
.L29:
	mov	$1, 30
	bsr	debug_setGpoCode
	bsr	compat_IRQ7_genSKSO
	bra	.L21
.L35:
	mov	$3, 1537 # 0x601
	beq	$5, $3, .L34
	mov	$1, 31
	bsr	debug_setGpoCode
	bsr	compat_IRQ7_armPanic
.L34:
	mov	$1, 32
	bsr	debug_setGpoCode
	bsr	compat_IRQ7_forceExitSm
	.size	compat_IRQ7_handleCmd, .-compat_IRQ7_handleCmd
	.p2align 1
	.globl compat_pListCopy
	.type	compat_pListCopy, @function
compat_pListCopy:
	# frame: 32   32 regs
	add	$sp, -32
	sw	$5, 20($sp)
	sw	$6, 16($sp)
	sw	$7, 12($sp)
	sw	$8, 8($sp)
	ldc	$11, $lp
	mov	$6, $1
	mov	$5, $2
	mov	$8, $3
	mov	$7, $4
	sw	$11, 4($sp)
.L39:
	bnez	$8, .L42
	lw	$8, 8($sp)
	lw	$7, 12($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L42:
	lw	$3, 4($5)
	beqz	$7, .L40
	lw	$1, ($5)
	mov	$2, $6
	bsr	memcpy
.L41:
	lw	$3, 4($5)
	add	$8, -1
	add	$5, 8
	add3	$6, $6, $3
	bra	.L39
.L40:
	lw	$2, ($5)
	mov	$1, $6
	bsr	memcpy
	bra	.L41
	.size	compat_pListCopy, .-compat_pListCopy
	.p2align 1
	.globl compat_armReBoot
	.type	compat_armReBoot, @function
compat_armReBoot:
	# frame: 32   32 regs
	add	$sp, -32
	sw	$5, 20($sp)
	sw	$6, 16($sp)
	sw	$7, 12($sp)
	mov	$5, $2
	ldc	$11, $lp
	mov	$7, $1
	mov	$6, $3
	mov	$4, 1
	mov	$3, 1
	movu	$2, 65551
	mov	$1, 0
	sw	$8, 8($sp)
	sw	$11, 4($sp)
	bsr	pervasive_control_reset
	beqz	$5, .L44
	mov	$4, 1
	mov	$3, 1
	mov	$2, 1
	mov	$1, 1
	bsr	pervasive_control_reset
.L44:
	mov	$4, 1
	mov	$3, 0
	mov	$2, -1 # 0xffff
	mov	$1, 0
	bsr	pervasive_control_gate
	beqz	$5, .L45
	mov	$4, 1
	mov	$3, 0
	mov	$2, -1 # 0xffff
	mov	$1, 1
	bsr	pervasive_control_gate
.L45:
	movh	$3, 0xe310
	or3	$3, $3, 0x2180
	mov	$2, -129 # 0xff7f
	lw	$8, ($3)
	mov	$4, 1
	mov	$3, 1
	and	$2, $8
	mov	$1, 96
	bsr	pervasive_control_gate
	mov	$4, 1
	mov	$3, 0
	mov	$2, -1 # 0xffff
	mov	$1, 97
	bsr	pervasive_control_reset
	mov	$4, 1
	mov	$3, 1
	or3	$2, $8, 0x80
	mov	$1, 96
	bsr	pervasive_control_gate
	mov	$3, 1
	mov	$2, 1
	mov	$1, 0
	bsr	pervasive_control_clock
	mov	$3, 1
	mov	$2, 0
	mov	$1, 12
	bsr	pervasive_control_misc
	mov	$3, 1
	mov	$2, 1
	mov	$1, 20
	bsr	pervasive_control_misc
	movh	$3, 0xe310
	or3	$3, $3, 0xc0
	erepeat	.L65
	nop
.L65:
	lw	$2, ($3)
	beqi	$2, 1, .L66
	# erepeat end
.L66:
	sw	$2, ($3)
	movh	$3, 0xe310
	or3	$3, $3, 0xc0
	erepeat	.L67
	nop
.L67:
	lw	$2, ($3)
	bnei	$2, 1, .L68
	# erepeat end
.L68:
	mov	$4, 1
	mov	$3, 1
	movh	$2, 0xc0
	mov	$1, 0
	bsr	pervasive_control_gate
	mov	$4, 1
	mov	$3, 0
	mov	$2, -1 # 0xffff
	mov	$1, 0
	bsr	pervasive_control_gate
	mov	$3, 1
	and3	$2, $7, 0xf
	mov	$1, 0
	bsr	pervasive_control_clock
	movh	$3, 0xe311
	and3	$6, $6, 0x1
	or3	$3, $3, 0xc00
	sw	$6, ($3)
	erepeat	.L69
	nop
.L69:
	lw	$2, ($3)
	beq	$6, $2, .L70
	# erepeat end
.L70:
	movh	$2, 0xc1
	bnez	$5, .L49
	movh	$2, 0x1
.L49:
	mov	$4, 1
	mov	$3, 1
	mov	$1, 0
	bsr	pervasive_control_gate
	beqz	$5, .L50
	mov	$4, 1
	mov	$3, 1
	mov	$2, 1
	mov	$1, 1
	bsr	pervasive_control_gate
	mov	$4, 1
	mov	$3, 0
	mov	$2, -1 # 0xffff
	mov	$1, 1
	bsr	pervasive_control_reset
.L50:
	mov	$4, 1
	mov	$3, 0
	mov	$2, -1 # 0xffff
	mov	$1, 0
	bsr	pervasive_control_reset
	lw	$8, 8($sp)
	lw	$7, 12($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
	.size	compat_armReBoot, .-compat_armReBoot
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
