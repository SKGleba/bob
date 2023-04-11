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
	sw	$11, 68($sp)
	mov	$5, 10000 # 0x2710
	bsr	debug_printFormat
.L2:
	mov	$1, $5
	bsr	delay
	mov	$3, 40
	mov	$2, 0
	add3	$1, $sp, 24
	bsr	memset
	mov	$3, 16
	mov	$2, 0
	add3	$1, $sp, 24
	bsr	jig_read_shared_buffer
	lhu	$2, 24($sp)
	movu	$3, 0xeb0b
	bne	$2, $3, .L2
	lbu	$2, 27($sp)
	mov	$3, $2
	extb	$3
	blti	$3, 0, .L2
	add3	$0, $sp, 24
	mov	$3, 0
	mov	$1, 12
	repeat	$1,.L31
.L4:
	lb	$9, 3($0)
	add	$0, 1
.L31:
	add3	$3, $3, $9
	extub	$3
	# repeat end
	lbu	$1, 26($sp)
	bne	$1, $3, .L2
	movu	$1, .LC1
	bsr	debug_printFormat
	lb	$3, 27($sp)
	and3	$3, $3, 0x40
	beqz	$3, .L5
	mov	$3, 24
	mov	$2, 16
	add3	$1, $sp, 40
	bsr	jig_read_shared_buffer
.L5:
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
	bra	.L6
.L10:
	beqi	$3, 3, .L13
	bnei	$3, 4, .L22
	lw	$3, 36($sp)
	lw	$2, 32($sp)
	lw	$1, 28($sp)
	bsr	memcpy
	bra	.L6
.L8:
	mov	$0, 65
	beq	$3, $0, .L15
	sltu3	$0, $0, $3
	bnez	$0, .L16
	beqi	$3, 6, .L30
	mov	$2, 64
	bne	$3, $2, .L22
	lw	$3, 32($sp)
	lw	$1, 28($sp)
	add3	$2, $sp, 40
	bsr	memcpy
	bra	.L6
.L16:
	mov	$2, 66
	beq	$3, $2, .L19
	mov	$2, 67
	bne	$3, $2, .L22
	lw	$6, 28($sp)
	movu	$1, .LC3
	mov	$2, $6
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
	jsr	$6
	bra	.L6
.L11:
	bsr	get_build_timestamp
.L6:
	mov	$2, $0
	movu	$1, .LC4
	sw	$0, 20($sp)
	bsr	debug_printFormat
	lb	$3, 27($sp)
	lw	$0, 20($sp)
	and3	$3, $3, 0x40
	sw	$0, 28($sp)
	beqz	$3, .L21
	mov	$4, 0
	mov	$3, 24
	mov	$2, 16
	add3	$1, $sp, 40
	bsr	jig_update_shared_buffer
.L21:
	lb	$3, 27($sp)
	mov	$2, -128 # 0xff80
	mov	$4, 1
	or	$3, $2
	sb	$3, 27($sp)
	mov	$2, 0
	mov	$3, 16
	add3	$1, $sp, 24
	bsr	jig_update_shared_buffer
	lbu	$3, 27($sp)
	bnei	$3, 6, .L2
	movu	$1, .LC5
	bsr	debug_printFormat
	lw	$6, 72($sp)
	lw	$5, 76($sp)
	lw	$11, 68($sp)
	add3	$sp, $sp, 88
	jmp	$11
.L12:
	lw	$3, 28($sp)
	lw	$0, ($3)
	bra	.L6
.L9:
	lw	$2, 32($sp)
	lw	$3, 28($sp)
	sw	$2, ($3)
.L30:
	mov	$0, 0
	bra	.L6
.L13:
	lw	$3, 36($sp)
	lb	$2, 32($sp)
	lw	$1, 28($sp)
	bsr	memset
	bra	.L6
.L7:
	mov	$0, $5
	lw	$5, 28($sp)
	bra	.L6
.L15:
	lw	$3, 32($sp)
	lw	$2, 28($sp)
	add3	$1, $sp, 40
	bsr	memcpy
	bra	.L6
.L19:
	lw	$6, 28($sp)
	movu	$1, .LC2
	mov	$2, $6
	bsr	debug_printFormat
	lw	$2, 36($sp)
	lw	$1, 32($sp)
	add3	$3, $sp, 40
	jsr	$6
	bra	.L6
	.size	rpc_loop, .-rpc_loop
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
