	.file	"rp.c"
	.section	.rodata
	.p2align 2
.LC0:
	.string	"[BOB] entering RPC mode, delay %X\n"
	.p2align 2
.LC1:
	.string	"[BOB] RPC CMD %X\n"
	.p2align 2
.LC2:
	.string	"[BOB] RPC EXEC %X\n"
	.p2align 2
.LC3:
	.string	"[BOB] RPC EXECE %X\n"
	.p2align 2
.LC4:
	.string	"[BOB] RPC RET %X\n"
	.p2align 2
.LC5:
	.string	"[BOB] exiting RPC mode\n"
	.text
	.core
	.p2align 1
	.globl rpc_loop
	.type	rpc_loop, @function
rpc_loop:
	# frame: 104   32 regs   56 locals   16 args
	add3	$sp, $sp, -104 # 0xff98
	ldc	$11, $lp
	movu	$1, .LC0
	mov	$2, 10000 # 0x2710
	sw	$5, 92($sp)
	sw	$8, 80($sp)
	sw	$6, 88($sp)
	sw	$7, 84($sp)
	sw	$11, 76($sp)
	add3	$5, $sp, 32
	bsr	debug_printFormat
	mov	$0, 512 # 0x200
	mov	$1, 1
	mov	$8, 10000 # 0x2710
	sw	$0, 28($sp)
	sw	$1, 24($sp)
.L2:
	mov	$1, 34
	bsr	debug_setGpoCode
	mov	$1, $8
	bsr	delay
	mov	$1, 36
	bsr	debug_setGpoCode
	mov	$3, 40
	mov	$2, 0
	mov	$1, $5
	bsr	memset
	mov	$3, 16
	mov	$2, 0
	mov	$1, $5
	bsr	jig_read_shared_buffer
	mov	$1, 35
	bsr	debug_setGpoCode
	lhu	$2, 32($sp)
	movu	$3, 0xeb0b
	bne	$2, $3, .L2
	lb	$3, 35($sp)
	blti	$3, 0, .L2
	mov	$7, $5
	mov	$6, $5
	mov	$3, 0
	mov	$2, 12
	repeat	$2,.L34
.L4:
	lb	$1, 3($6)
	add	$6, 1
.L34:
	add3	$3, $3, $1
	extub	$3
	# repeat end
	lbu	$2, 34($sp)
	bne	$2, $3, .L2
	mov	$1, 36
	bsr	debug_setGpoCode
	lb	$3, 35($sp)
	and3	$3, $3, 0x40
	beqz	$3, .L5
	mov	$3, 24
	mov	$2, 16
	add3	$1, $sp, 48
	bsr	jig_read_shared_buffer
.L5:
	lbu	$2, 35($sp)
	movu	$1, .LC1
	bsr	debug_printFormat
	mov	$1, 37
	bsr	debug_setGpoCode
	lbu	$9, 35($sp)
	beqi	$9, 6, .L33
	mov	$3, 6
	sltu3	$0, $3, $9
	bnez	$0, .L8
	beqi	$9, 2, .L9
	mov	$3, 2
	sltu3	$0, $3, $9
	bnez	$0, .L10
	beqz	$9, .L11
	beqi	$9, 1, .L12
.L26:
	mov	$0, -1 # 0xffff
	mov	$3, 0
	bra	.L6
.L10:
	lw	$1, 36($sp)
	lw	$2, 40($sp)
	beqi	$9, 4, .L13
	mov	$3, 4
	sltu3	$0, $3, $9
	beqz	$0, .L32
	mov	$0, $8
	sw	$2, 28($sp)
	mov	$8, $1
	mov	$3, 0
	bra	.L6
.L8:
	mov	$3, 64
	beq	$9, $3, .L16
	sltu3	$0, $3, $9
	bnez	$0, .L17
	beqi	$9, 7, .L18
	bnei	$9, 8, .L26
	lw	$3, 44($sp)
	lw	$2, 40($sp)
	lw	$1, 36($sp)
	bsr	debug_printRange
	mov	$0, 0
	mov	$3, 0
	bra	.L6
.L17:
	mov	$3, 66
	beq	$9, $3, .L20
	sltu3	$3, $9, 66
	bnez	$3, .L21
	mov	$3, 67
	bne	$9, $3, .L26
	lw	$0, 36($sp)
	movu	$1, .LC3
	mov	$2, $0
	sw	$0, 16($sp)
	bsr	debug_printFormat
	lw	$3, 68($sp)
	lw	$4, 52($sp)
	lw	$2, 44($sp)
	sw	$3, 12($sp)
	lw	$3, 64($sp)
	lw	$1, 40($sp)
	lw	$0, 16($sp)
	sw	$3, 8($sp)
	lw	$3, 60($sp)
	sw	$3, 4($sp)
	lw	$3, 56($sp)
	sw	$3, ($sp)
	lw	$3, 48($sp)
	jsr	$0
	mov	$3, 0
	bra	.L6
.L11:
	bsr	get_build_timestamp
	mov	$3, 0
.L6:
	mov	$1, 34
	sw	$3, 20($sp)
	sw	$0, 16($sp)
	bsr	debug_setGpoCode
	lw	$1, 28($sp)
	bsr	delay
	lw	$0, 16($sp)
	movu	$1, .LC4
	mov	$2, $0
	bsr	debug_printFormat
	mov	$1, 38
	bsr	debug_setGpoCode
	lw	$0, 16($sp)
	lb	$2, 35($sp)
	sw	$0, 36($sp)
	mov	$0, -128 # 0xff80
	or	$2, $0
	sb	$2, 35($sp)
	mov	$2, 0
	sb	$2, 34($sp)
	mov	$2, $5
	nor	$2, $2
	add3	$6, $2, $6
	add	$6, 1
	lw	$3, 20($sp)
	erepeat	.L35
	lb	$1, 3($7)
	lb	$2, 34($sp)
	add	$7, 1
	add3	$2, $2, $1
	sb	$2, 34($sp)
.L35:
	add	$6, -1
	beqz	$6, .L36
	# erepeat end
.L36:
	lw	$1, 24($sp)
	add	$3, 16
	beqz	$1, .L24
	mov	$4, 1
	mov	$2, 0
	mov	$1, $5
	bsr	jig_update_shared_buffer
.L25:
	lbu	$3, 35($sp)
	bnei	$3, 6, .L2
	movu	$1, .LC5
	bsr	debug_printFormat
	mov	$1, 39
	bsr	debug_setGpoCode
	lw	$8, 80($sp)
	lw	$7, 84($sp)
	lw	$6, 88($sp)
	lw	$5, 92($sp)
	lw	$11, 76($sp)
	add3	$sp, $sp, 104
	jmp	$11
.L12:
	lw	$3, 36($sp)
	lw	$0, ($3)
	mov	$3, 0
	bra	.L6
.L9:
	lw	$2, 40($sp)
	lw	$3, 36($sp)
	sw	$2, ($3)
.L33:
	mov	$0, 0
	mov	$3, 0
	bra	.L6
.L32:
	lw	$3, 44($sp)
	bsr	memset
	mov	$3, 0
	bra	.L6
.L13:
	lw	$3, 44($sp)
	bsr	memcpy
	mov	$3, 0
	bra	.L6
.L18:
	lw	$1, 36($sp)
	lw	$0, 24($sp)
	mov	$3, 0
	sw	$1, 24($sp)
	bra	.L6
.L16:
	lw	$3, 40($sp)
	lw	$1, 36($sp)
	add3	$2, $sp, 48
	bsr	memcpy
	mov	$3, 0
	bra	.L6
.L21:
	lw	$3, 40($sp)
	lw	$2, 36($sp)
	add3	$1, $sp, 48
	bsr	memcpy
	lbu	$3, 40($sp)
	bra	.L6
.L20:
	lw	$0, 36($sp)
	movu	$1, .LC2
	mov	$2, $0
	sw	$0, 16($sp)
	bsr	debug_printFormat
	lw	$2, 44($sp)
	lw	$1, 40($sp)
	lw	$0, 16($sp)
	add3	$3, $sp, 48
	jsr	$0
	mov	$3, 24
	bra	.L6
.L24:
	add3	$1, $sp, 35
	mov	$4, 0
	mov	$2, 0
	bsr	jig_update_shared_buffer
	mov	$4, 0
	mov	$3, 3
	mov	$2, 0
	mov	$1, $5
	bsr	jig_update_shared_buffer
	bra	.L25
	.size	rpc_loop, .-rpc_loop
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
