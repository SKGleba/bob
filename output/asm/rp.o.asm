	.file	"rp.c"
	.globl g_rpc_status
	.section .far,"aw"
	.p2align 2
	.type	g_rpc_status, @object
	.size	g_rpc_status, 4
g_rpc_status:
	.zero	4
	.section	.rodata
	.p2align 2
.LC0:
	.string	"[BOB] RPC mode disabled, status: %X\n"
	.p2align 2
.LC1:
	.string	"[BOB] entering RPC mode, delay %X\n"
	.p2align 2
.LC2:
	.string	"[BOB] RPC CMD %X\n"
	.p2align 2
.LC3:
	.string	"[BOB] RPC EXEC %X\n"
	.p2align 2
.LC4:
	.string	"[BOB] RPC EXECE %X\n"
	.p2align 2
.LC5:
	.string	"[BOB] RPC RET %X\n"
	.p2align 2
.LC6:
	.string	"[BOB] exiting RPC mode\n"
	.text
	.core
	.p2align 1
	.globl rpc_loop
	.type	rpc_loop, @function
rpc_loop:
	# frame: 112   32 regs   60 locals   16 args
	add3	$sp, $sp, -112 # 0xff90
	sw	$6, 96($sp)
	movh	$6, %hi(g_rpc_status)
	ldc	$11, $lp
	add3	$6, $6, %lo(g_rpc_status)
	sw	$5, 100($sp)
	sw	$7, 92($sp)
	sw	$8, 88($sp)
	sw	$11, 84($sp)
	lw	$2, ($6)
	movh	$5, %hi(g_rpc_status)
	bgei	$2, 0, .L2
	movu	$1, .LC0
	bsr	debug_printFormat
.L1:
	lw	$8, 88($sp)
	lw	$7, 92($sp)
	lw	$6, 96($sp)
	lw	$5, 100($sp)
	lw	$11, 84($sp)
	add3	$sp, $sp, 112
	jmp	$11
.L2:
	mov	$2, 10000 # 0x2710
	movu	$1, .LC1
	bsr	debug_printFormat
	lw	$3, ($6)
	mov	$0, 512 # 0x200
	mov	$1, 10000 # 0x2710
	or3	$3, $3, 0x1
	sw	$3, ($6)
	mov	$2, 1
	add3	$6, $sp, 40
	sw	$0, 36($sp)
	sw	$1, 32($sp)
	sw	$2, 28($sp)
.L4:
	mov	$1, 34
	bsr	debug_setGpoCode
	lw	$1, 32($sp)
	bsr	delay
	lw	$3, %lo(g_rpc_status)($5)
	movh	$2, 0x80
	and	$2, $3
	beqz	$2, .L5
	or3	$3, $3, 0xb10
	mov	$7, 256 # 0x100
	sw	$3, %lo(g_rpc_status)($5)
.L6:
	lw	$3, %lo(g_rpc_status)($5)
	movh	$1, 0x80
	mov	$2, $5
	and	$1, $3
	add3	$2, $2, %lo(g_rpc_status)
	bnez	$1, .L7
	mov	$0, -2833 # 0xf4ef
	and	$3, $0
	sw	$3, ($2)
.L5:
	mov	$1, 36
	bsr	debug_setGpoCode
	mov	$3, 40
	mov	$2, 0
	mov	$1, $6
	bsr	memset
	mov	$3, 16
	mov	$2, 0
	mov	$1, $6
	bsr	jig_read_shared_buffer
	mov	$1, 35
	bsr	debug_setGpoCode
	lhu	$2, 40($sp)
	movu	$3, 0xeb0b
	bne	$2, $3, .L4
	lb	$3, 43($sp)
	blti	$3, 0, .L4
	mov	$8, $6
	mov	$7, $6
	mov	$3, 0
	mov	$2, 12
	repeat	$2,.L50
.L9:
	lb	$1, 3($7)
	add	$7, 1
.L50:
	add3	$3, $3, $1
	extub	$3
	# repeat end
	lbu	$2, 42($sp)
	bne	$2, $3, .L4
	mov	$1, 36
	bsr	debug_setGpoCode
	lb	$3, 43($sp)
	and3	$3, $3, 0x40
	beqz	$3, .L10
	mov	$3, 24
	mov	$2, 16
	add3	$1, $sp, 56
	bsr	jig_read_shared_buffer
.L10:
	lbu	$2, 43($sp)
	movu	$1, .LC2
	bsr	debug_printFormat
	mov	$1, 37
	bsr	debug_setGpoCode
	lw	$3, %lo(g_rpc_status)($5)
	lbu	$9, 43($sp)
	or3	$3, $3, 0xb100
	sw	$3, %lo(g_rpc_status)($5)
	beqi	$9, 6, .L49
	mov	$3, 6
	sltu3	$0, $3, $9
	bnez	$0, .L13
	beqi	$9, 2, .L14
	mov	$3, 2
	sltu3	$0, $3, $9
	bnez	$0, .L15
	beqz	$9, .L16
	beqi	$9, 1, .L17
.L33:
	mov	$0, -1 # 0xffff
	mov	$3, 0
	bra	.L11
.L7:
	mov	$1, $7
	bsr	delay
	bra	.L6
.L15:
	lw	$1, 44($sp)
	lw	$2, 48($sp)
	beqi	$9, 4, .L18
	mov	$3, 4
	sltu3	$0, $3, $9
	beqz	$0, .L48
	lw	$0, 32($sp)
	sw	$2, 36($sp)
	sw	$1, 32($sp)
	mov	$3, 0
	bra	.L11
.L13:
	mov	$3, 64
	beq	$9, $3, .L21
	sltu3	$0, $3, $9
	bnez	$0, .L22
	beqi	$9, 8, .L23
	sltu3	$3, $9, 8
	bnez	$3, .L24
	bnei	$9, 9, .L33
	lw	$3, 52($sp)
	lw	$2, 48($sp)
	lw	$1, 44($sp)
	bsr	memset32
	mov	$3, 0
	bra	.L11
.L22:
	mov	$3, 66
	beq	$9, $3, .L26
	sltu3	$3, $9, 66
	bnez	$3, .L27
	mov	$3, 67
	bne	$9, $3, .L33
	lw	$0, 44($sp)
	movu	$1, .LC4
	mov	$2, $0
	sw	$0, 20($sp)
	bsr	debug_printFormat
	lw	$3, 76($sp)
	lw	$4, 60($sp)
	lw	$2, 52($sp)
	sw	$3, 12($sp)
	lw	$3, 72($sp)
	lw	$1, 48($sp)
	lw	$0, 20($sp)
	sw	$3, 8($sp)
	lw	$3, 68($sp)
	sw	$3, 4($sp)
	lw	$3, 64($sp)
	sw	$3, ($sp)
	lw	$3, 56($sp)
	jsr	$0
	mov	$3, 0
	bra	.L11
.L16:
	bsr	get_build_timestamp
	mov	$3, 0
.L11:
	lw	$2, %lo(g_rpc_status)($5)
	movh	$1, 0xffff
	or3	$1, $1, 0x4eff
	and	$2, $1
	mov	$1, 34
	sw	$3, 24($sp)
	sw	$2, %lo(g_rpc_status)($5)
	sw	$0, 20($sp)
	bsr	debug_setGpoCode
	lw	$1, 36($sp)
	bsr	delay
	lw	$0, 20($sp)
	movu	$1, .LC5
	mov	$2, $0
	bsr	debug_printFormat
	mov	$1, 38
	bsr	debug_setGpoCode
	lw	$0, 20($sp)
	lb	$2, 43($sp)
	sw	$0, 44($sp)
	mov	$0, -128 # 0xff80
	or	$2, $0
	sb	$2, 43($sp)
	mov	$2, 0
	sb	$2, 42($sp)
	mov	$2, $6
	sub	$2, $7
	nor	$2, $2
	add	$2, 1
	lw	$3, 24($sp)
	erepeat	.L51
	lb	$0, 3($8)
	lb	$1, 42($sp)
	add	$8, 1
	add3	$1, $1, $0
	sb	$1, 42($sp)
.L51:
	add	$2, -1
	beqz	$2, .L52
	# erepeat end
.L52:
	lw	$1, 28($sp)
	add	$3, 16
	beqz	$1, .L30
	mov	$4, 1
	mov	$2, 0
	mov	$1, $6
	bsr	jig_update_shared_buffer
.L31:
	lbu	$3, 43($sp)
	beqi	$3, 6, .L32
	lb	$3, %lo(g_rpc_status+1)($5)
	bgei	$3, 0, .L4
.L32:
	add3	$5, $5, %lo(g_rpc_status)
	mov	$2, -256 # 0xff00
	lw	$3, ($5)
	movu	$1, .LC6
	and	$3, $2
	sw	$3, ($5)
	bsr	debug_printFormat
	mov	$1, 39
	bsr	debug_setGpoCode
	bra	.L1
.L17:
	lw	$3, 44($sp)
	lw	$0, ($3)
	mov	$3, 0
	bra	.L11
.L14:
	lw	$2, 48($sp)
	lw	$3, 44($sp)
	sw	$2, ($3)
.L49:
	mov	$0, 0
	mov	$3, 0
	bra	.L11
.L48:
	lw	$3, 52($sp)
	bsr	memset
	mov	$3, 0
	bra	.L11
.L18:
	lw	$3, 52($sp)
	bsr	memcpy
	mov	$3, 0
	bra	.L11
.L24:
	lw	$1, 44($sp)
	lw	$0, 28($sp)
	mov	$3, 0
	sw	$1, 28($sp)
	bra	.L11
.L23:
	lw	$3, 52($sp)
	lw	$2, 48($sp)
	lw	$1, 44($sp)
	bsr	debug_printRange
	mov	$0, 0
	mov	$3, 0
	bra	.L11
.L21:
	lw	$3, 48($sp)
	lw	$1, 44($sp)
	add3	$2, $sp, 56
	bsr	memcpy
	mov	$3, 0
	bra	.L11
.L27:
	lw	$3, 48($sp)
	lw	$2, 44($sp)
	add3	$1, $sp, 56
	bsr	memcpy
	lbu	$3, 48($sp)
	bra	.L11
.L26:
	lw	$0, 44($sp)
	movu	$1, .LC3
	mov	$2, $0
	sw	$0, 20($sp)
	bsr	debug_printFormat
	lw	$2, 52($sp)
	lw	$1, 48($sp)
	lw	$0, 20($sp)
	add3	$3, $sp, 56
	jsr	$0
	mov	$3, 24
	bra	.L11
.L30:
	add3	$1, $sp, 43
	mov	$4, 0
	mov	$2, 0
	bsr	jig_update_shared_buffer
	mov	$4, 0
	mov	$3, 3
	mov	$2, 0
	mov	$1, $6
	bsr	jig_update_shared_buffer
	bra	.L31
	.size	rpc_loop, .-rpc_loop
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
