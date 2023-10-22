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
	.string	"[BOB] RPC blocked\n"
	.p2align 2
.LC3:
	.string	"[BOB] RPC unblocked\n"
	.p2align 2
.LC4:
	.string	"[BOB] RPC CMD %X\n"
	.p2align 2
.LC5:
	.string	"[BOB] RPC EXEC %X\n"
	.p2align 2
.LC6:
	.string	"[BOB] RPC EXECE %X\n"
	.p2align 2
.LC7:
	.string	"[BOB] RPC RET %X\n"
	.p2align 2
.LC8:
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
	lw	$3, ($6)
	movh	$5, %hi(g_rpc_status)
	bgei	$3, 0, .L2
	lw	$2, ($6)
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
	mov	$2, 4096 # 0x1000
	movu	$1, .LC1
	bsr	debug_printFormat
	lw	$3, ($6)
	mov	$0, 128
	mov	$1, 4096 # 0x1000
	or3	$3, $3, 0x1
	sw	$3, ($6)
	mov	$2, 0
	add3	$6, $sp, 40
	sw	$0, 36($sp)
	sw	$1, 32($sp)
	sw	$2, 28($sp)
.L4:
	lw	$1, 32($sp)
	bsr	delay
	lw	$3, %lo(g_rpc_status)($5)
	movh	$0, 0x80
	and	$3, $0
	beqz	$3, .L5
	lw	$3, %lo(g_rpc_status)($5)
	movu	$1, .LC2
	mov	$7, 10240 # 0x2800
	or3	$3, $3, 0x2
	sw	$3, %lo(g_rpc_status)($5)
	bsr	debug_printFormat
.L6:
	mov	$1, $7
	bsr	delay
	mov	$1, $7
	bsr	delay
	lw	$3, %lo(g_rpc_status)($5)
	movh	$1, 0x80
	mov	$8, $5
	and	$3, $1
	add3	$8, $8, %lo(g_rpc_status)
	bnez	$3, .L6
	movu	$1, .LC3
	bsr	debug_printFormat
	lw	$3, ($8)
	mov	$2, -3 # 0xfffd
	and	$3, $2
	sw	$3, ($8)
.L5:
	mov	$3, 40
	mov	$2, 0
	mov	$1, $6
	bsr	memset
	mov	$3, 16
	mov	$2, 0
	mov	$1, $6
	bsr	jig_read_shared_buffer
	lhu	$2, 40($sp)
	movu	$3, 0xeb0b
	bne	$2, $3, .L4
	lbu	$1, 43($sp)
	mov	$3, $1
	extb	$3
	blti	$3, 0, .L4
	mov	$8, $6
	mov	$7, $6
	mov	$3, 0
	mov	$2, 12
	repeat	$2,.L62
.L8:
	lb	$0, 3($7)
	add	$7, 1
.L62:
	add3	$3, $3, $0
	extub	$3
	# repeat end
	lbu	$2, 42($sp)
	bne	$2, $3, .L4
	and3	$1, $1, 0x40
	beqz	$1, .L9
	mov	$3, 24
	mov	$2, 16
	add3	$1, $sp, 56
	bsr	jig_read_shared_buffer
.L9:
	lbu	$2, 43($sp)
	movu	$1, .LC4
	bsr	debug_printFormat
	lw	$3, %lo(g_rpc_status)($5)
	or3	$3, $3, 0x4
	sw	$3, %lo(g_rpc_status)($5)
	lbu	$3, 43($sp)
	beqi	$3, 10, .L11
	mov	$0, 10
	sltu3	$0, $0, $3
	bnez	$0, .L12
	beqi	$3, 4, .L13
	mov	$0, 4
	sltu3	$0, $0, $3
	bnez	$0, .L14
	beqi	$3, 1, .L15
	beqz	$3, .L16
	beqi	$3, 2, .L17
	beqi	$3, 3, .L18
.L45:
	mov	$0, -1 # 0xffff
	mov	$3, 0
	bra	.L10
.L14:
	beqi	$3, 7, .L19
	mov	$0, 7
	sltu3	$0, $0, $3
	bnez	$0, .L20
	beqi	$3, 5, .L21
	bnei	$3, 6, .L45
.L61:
	mov	$0, 0
	mov	$3, 0
	bra	.L10
.L20:
	beqi	$3, 8, .L23
	bnei	$3, 9, .L45
	lw	$3, 52($sp)
	lw	$2, 48($sp)
	lw	$1, 44($sp)
	bsr	memset32
	mov	$3, 0
	bra	.L10
.L12:
	mov	$0, 64
	beq	$3, $0, .L25
	sltu3	$0, $0, $3
	bnez	$0, .L26
	beqi	$3, 12, .L27
	sltu3	$2, $3, 12
	bnez	$2, .L28
	beqi	$3, 13, .L29
	bnei	$3, 14, .L45
	lw	$3, 52($sp)
	lw	$2, 48($sp)
	lw	$1, 44($sp)
	bsr	alice_get_task_status
	mov	$3, 0
	bra	.L10
.L26:
	mov	$0, 67
	beq	$3, $0, .L31
	sltu3	$0, $0, $3
	bnez	$0, .L32
	mov	$2, 65
	beq	$3, $2, .L33
	mov	$2, 66
	bne	$3, $2, .L45
	lw	$0, 44($sp)
	movu	$1, .LC5
	mov	$2, $0
	sw	$0, 20($sp)
	bsr	debug_printFormat
	lw	$2, 52($sp)
	lw	$1, 48($sp)
	lw	$0, 20($sp)
	add3	$3, $sp, 56
	jsr	$0
	mov	$3, 24
	bra	.L10
.L32:
	mov	$2, 68
	beq	$3, $2, .L35
	mov	$2, 69
	bne	$3, $2, .L45
	lw	$3, 68($sp)
	lw	$4, 56($sp)
	lw	$2, 48($sp)
	sw	$3, 8($sp)
	lw	$3, 64($sp)
	lw	$1, 44($sp)
	sw	$3, 4($sp)
	lw	$3, 60($sp)
	sw	$3, ($sp)
	lw	$3, 52($sp)
	bsr	alice_loadAlice
	mov	$3, 0
	bra	.L10
.L16:
	bsr	get_build_timestamp
	mov	$3, 0
.L10:
	lw	$2, %lo(g_rpc_status)($5)
	mov	$1, -5 # 0xfffb
	sw	$0, 20($sp)
	and	$2, $1
	lw	$1, 36($sp)
	sw	$2, %lo(g_rpc_status)($5)
	sw	$3, 24($sp)
	bsr	delay
	lw	$0, 20($sp)
	movu	$1, .LC7
	mov	$2, $0
	bsr	debug_printFormat
	lw	$0, 20($sp)
	lb	$2, 43($sp)
	sw	$0, 44($sp)
	mov	$0, -128 # 0xff80
	or	$2, $0
	sb	$2, 43($sp)
	mov	$2, 0
	sb	$2, 42($sp)
	mov	$2, $6
	nor	$2, $2
	add3	$7, $2, $7
	add	$7, 1
	lw	$3, 24($sp)
	erepeat	.L63
	lb	$1, 3($8)
	lb	$2, 42($sp)
	add	$8, 1
	add3	$2, $2, $1
	sb	$2, 42($sp)
.L63:
	add	$7, -1
	beqz	$7, .L64
	# erepeat end
.L64:
	lw	$1, 28($sp)
	beqz	$1, .L42
	mov	$4, 1
	add	$3, 16
	mov	$2, 0
	mov	$1, $6
	bsr	jig_update_shared_buffer
.L43:
	lbu	$2, 43($sp)
	mov	$3, 134
	beq	$2, $3, .L44
	lw	$3, %lo(g_rpc_status)($5)
	and3	$3, $3, 0x8000
	beqz	$3, .L4
.L44:
	add3	$5, $5, %lo(g_rpc_status)
	mov	$2, -256 # 0xff00
	lw	$3, ($5)
	movu	$1, .LC8
	and	$3, $2
	sw	$3, ($5)
	bsr	debug_printFormat
	bra	.L1
.L15:
	lw	$2, 52($sp)
	lw	$1, 44($sp)
	bgei	$2, 0, .L37
	movh	$3, 0x7fff
	or3	$3, $3, 0xffff
	and	$2, $3
	bsr	readAs
	mov	$3, 0
	bra	.L10
.L37:
	lw	$0, ($1)
	mov	$3, 0
	bra	.L10
.L17:
	lw	$3, 52($sp)
	lw	$1, 44($sp)
	lw	$2, 48($sp)
	bgei	$3, 0, .L38
	movh	$0, 0x7fff
	or3	$0, $0, 0xffff
	and	$3, $0
	bsr	writeAs
	bra	.L61
.L38:
	sw	$2, ($1)
	mov	$0, 0
	mov	$3, 0
	bra	.L10
.L18:
	lw	$3, 52($sp)
	lb	$2, 48($sp)
	lw	$1, 44($sp)
	bsr	memset
	mov	$3, 0
	bra	.L10
.L13:
	lw	$3, 52($sp)
	lw	$2, 48($sp)
	lw	$1, 44($sp)
	bsr	memcpy
	mov	$3, 0
	bra	.L10
.L21:
	lw	$1, 48($sp)
	lw	$2, 44($sp)
	lw	$0, 32($sp)
	sw	$1, 36($sp)
	sw	$2, 32($sp)
	mov	$3, 0
	bra	.L10
.L19:
	lw	$3, 44($sp)
	lw	$0, 28($sp)
	sw	$3, 28($sp)
	mov	$3, 0
	bra	.L10
.L23:
	lw	$3, 52($sp)
	lw	$2, 48($sp)
	lw	$1, 44($sp)
	bsr	debug_printRange
	mov	$0, 0
	mov	$3, 0
	bra	.L10
.L11:
	lw	$3, 52($sp)
	lw	$2, 48($sp)
	lw	$1, 44($sp)
	bsr	compat_armReBoot
	mov	$0, 0
	mov	$3, 0
	bra	.L10
.L28:
	lw	$1, 44($sp)
	bsr	set_exception_table
	mov	$0, 0
	mov	$3, 0
	bra	.L10
.L27:
	lw	$0, 44($sp)
	beqz	$0, .L39
	lw	$3, 48($sp)
	beqz	$3, .L40
	bsr	setup_ints
.L40:
	ei
	mov	$0, 0
	mov	$3, 0
	bra	.L10
.L39:
	di
	mov	$3, 0
	bra	.L10
.L29:
	mov	$3, 0
	sw	$3, 12($sp)
	sw	$3, 8($sp)
	lw	$3, 48($sp)
	lw	$4, 52($sp)
	mov	$2, 1
	sw	$3, 4($sp)
	lw	$3, 44($sp)
	mov	$1, 0
	sw	$3, ($sp)
	mov	$3, 1
	bsr	alice_schedule_bob_task
	mov	$3, 0
	bra	.L10
.L25:
	lw	$3, 48($sp)
	lw	$1, 44($sp)
	add3	$2, $sp, 56
	bsr	memcpy
	mov	$3, 0
	bra	.L10
.L33:
	lw	$3, 48($sp)
	lw	$2, 44($sp)
	add3	$1, $sp, 56
	bsr	memcpy
	lbu	$3, 48($sp)
	bra	.L10
.L31:
	lw	$0, 44($sp)
	movu	$1, .LC6
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
	bra	.L10
.L35:
	lw	$3, 72($sp)
	lw	$4, 56($sp)
	lw	$2, 48($sp)
	sw	$3, 12($sp)
	lw	$3, 68($sp)
	lw	$1, 44($sp)
	sw	$3, 8($sp)
	lw	$3, 64($sp)
	sw	$3, 4($sp)
	lw	$3, 60($sp)
	sw	$3, ($sp)
	lw	$3, 52($sp)
	bsr	alice_schedule_bob_task
	mov	$3, 0
	bra	.L10
.L42:
	add3	$1, $sp, 44
	mov	$4, 0
	add	$3, 12
	mov	$2, 4
	bsr	jig_update_shared_buffer
	mov	$4, 0
	mov	$3, 4
	mov	$2, 0
	mov	$1, $6
	bsr	jig_update_shared_buffer
	bra	.L43
	.size	rpc_loop, .-rpc_loop
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
