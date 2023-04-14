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
	# frame: 88   24 regs   44 locals   16 args
	add3	$sp, $sp, -88 # 0xffa8
	ldc	$11, $lp
	mov	$2, 10000 # 0x2710
	movu	$1, .LC0
	sw	$5, 76($sp)
	sw	$6, 72($sp)
	sw	$7, 68($sp)
	sw	$11, 64($sp)
	mov	$6, 10000 # 0x2710
	bsr	debug_printFormat
	mov	$5, 1
.L2:
	mov	$1, 34
	bsr	debug_setGpoCode
	mov	$1, $6
	bsr	delay
	mov	$1, 36
	bsr	debug_setGpoCode
	mov	$3, 40
	mov	$2, 0
	add3	$1, $sp, 24
	bsr	memset
	mov	$3, 16
	mov	$2, 0
	add3	$1, $sp, 24
	bsr	jig_read_shared_buffer
	mov	$1, 35
	bsr	debug_setGpoCode
	lhu	$2, 24($sp)
	movu	$3, 0xeb0b
	bne	$2, $3, .L2
	lb	$3, 27($sp)
	blti	$3, 0, .L2
	add3	$1, $sp, 24
	mov	$3, 0
	mov	$2, 12
	repeat	$2,.L28
.L4:
	lb	$0, 3($1)
	add	$1, 1
.L28:
	add3	$3, $3, $0
	extub	$3
	# repeat end
	lbu	$2, 26($sp)
	bne	$2, $3, .L2
	mov	$1, 36
	bsr	debug_setGpoCode
	lb	$3, 27($sp)
	and3	$3, $3, 0x40
	beqz	$3, .L5
	mov	$3, 24
	mov	$2, 16
	add3	$1, $sp, 40
	bsr	jig_read_shared_buffer
.L5:
	lbu	$2, 27($sp)
	movu	$1, .LC1
	bsr	debug_printFormat
	mov	$1, 37
	bsr	debug_setGpoCode
	lbu	$3, 27($sp)
	beqi	$3, 5, .L7
	mov	$0, 5
	sltu3	$0, $0, $3
	bnez	$0, .L8
	beqi	$3, 2, .L9
	mov	$0, 2
	sltu3	$0, $0, $3
	bnez	$0, .L10
	beqz	$3, .L11
	beqi	$3, 1, .L12
.L22:
	mov	$0, -1 # 0xffff
	mov	$7, 0
	bra	.L6
.L10:
	beqi	$3, 3, .L13
	bnei	$3, 4, .L22
	lw	$3, 36($sp)
	lw	$2, 32($sp)
	lw	$1, 28($sp)
	mov	$7, 0
	bsr	memcpy
	bra	.L6
.L8:
	mov	$0, 64
	beq	$3, $0, .L15
	sltu3	$0, $0, $3
	bnez	$0, .L16
	beqi	$3, 6, .L27
	bnei	$3, 7, .L22
	mov	$0, $5
	mov	$7, 0
	lw	$5, 28($sp)
	bra	.L6
.L16:
	mov	$2, 66
	beq	$3, $2, .L19
	sltu3	$2, $3, 66
	bnez	$2, .L20
	mov	$2, 67
	bne	$3, $2, .L22
	lw	$7, 28($sp)
	movu	$1, .LC3
	mov	$2, $7
	bsr	debug_printFormat
	lw	$3, 60($sp)
	lw	$4, 44($sp)
	lw	$2, 36($sp)
	sw	$3, 12($sp)
	lw	$3, 56($sp)
	lw	$1, 32($sp)
	sw	$3, 8($sp)
	lw	$3, 52($sp)
	sw	$3, 4($sp)
	lw	$3, 48($sp)
	sw	$3, ($sp)
	lw	$3, 40($sp)
	jsr	$7
	mov	$7, 0
	bra	.L6
.L11:
	bsr	get_build_timestamp
	mov	$7, 0
.L6:
	mov	$2, $0
	movu	$1, .LC4
	sw	$0, 20($sp)
	bsr	debug_printFormat
	mov	$1, 38
	bsr	debug_setGpoCode
	lb	$3, 27($sp)
	lw	$0, 20($sp)
	mov	$2, -128 # 0xff80
	or	$3, $2
	sb	$3, 27($sp)
	mov	$4, $5
	add3	$3, $7, 16
	mov	$2, 0
	add3	$1, $sp, 24
	sw	$0, 28($sp)
	bsr	jig_update_shared_buffer
	lbu	$3, 27($sp)
	bnei	$3, 6, .L2
	movu	$1, .LC5
	bsr	debug_printFormat
	mov	$1, 39
	bsr	debug_setGpoCode
	lw	$7, 68($sp)
	lw	$6, 72($sp)
	lw	$5, 76($sp)
	lw	$11, 64($sp)
	add3	$sp, $sp, 88
	jmp	$11
.L12:
	lw	$3, 28($sp)
	mov	$7, 0
	lw	$0, ($3)
	bra	.L6
.L9:
	lw	$2, 32($sp)
	lw	$3, 28($sp)
	sw	$2, ($3)
.L27:
	mov	$0, 0
	mov	$7, 0
	bra	.L6
.L13:
	lw	$3, 36($sp)
	lb	$2, 32($sp)
	lw	$1, 28($sp)
	mov	$7, 0
	bsr	memset
	bra	.L6
.L7:
	mov	$0, $6
	mov	$7, 0
	lw	$6, 28($sp)
	bra	.L6
.L15:
	lw	$3, 32($sp)
	lw	$1, 28($sp)
	add3	$2, $sp, 40
	mov	$7, 0
	bsr	memcpy
	bra	.L6
.L20:
	lw	$3, 32($sp)
	lw	$2, 28($sp)
	add3	$1, $sp, 40
	bsr	memcpy
	lbu	$7, 32($sp)
	bra	.L6
.L19:
	lw	$7, 28($sp)
	movu	$1, .LC2
	mov	$2, $7
	bsr	debug_printFormat
	lw	$2, 36($sp)
	lw	$1, 32($sp)
	add3	$3, $sp, 40
	jsr	$7
	mov	$7, 24
	bra	.L6
	.size	rpc_loop, .-rpc_loop
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
