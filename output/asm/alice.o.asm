	.file	"alice.c"
	.globl alice_vectors
	.section .far,"aw"
	.p2align 2
	.type	alice_vectors, @object
	.size	alice_vectors, 4
alice_vectors:
	.zero	4
	.globl alice_xcfg
	.p2align 2
	.type	alice_xcfg, @object
	.size	alice_xcfg, 4
alice_xcfg:
	.zero	4
	.globl alice_tasks
	.p2align 2
	.type	alice_tasks, @object
	.size	alice_tasks, 4
alice_tasks:
	.zero	4
	.globl alice_core_status
	.p2align 2
	.type	alice_core_status, @object
	.size	alice_core_status, 4
alice_core_status:
	.zero	4
	.text
	.core
	.p2align 1
	.globl alice_get_task_status
	.type	alice_get_task_status, @function
alice_get_task_status:
	beqz	$3, .L2
	movh	$3, %hi(alice_tasks)
	add3	$3, $3, %lo(alice_tasks)
	lw	$0, ($3)
	beqz	$0, .L7
	lw	$3, ($3)
	sll	$1, 2
	add3	$1, $3, $1
	lw	$1, ($1)
	bnez	$1, .L4
.L7:
	mov	$0, -1 # 0xffff
	ret
.L2:
	movu	$3, 16527356
	add3	$1, $1, $3
	sll	$1, 5
.L4:
	beqz	$2, .L5
	lw	$0, 24($1)
	ret
.L5:
	lw	$0, 20($1)
	ret
	.size	alice_get_task_status, .-alice_get_task_status
	.p2align 1
	.globl alice_schedule_bob_task
	.type	alice_schedule_bob_task, @function
alice_schedule_bob_task:
	# frame: 40   32 regs   4 locals
	add3	$sp, $sp, -40 # 0xffd8
	sw	$7, 20($sp)
	mov	$7, $3
	movu	$3, 16527356
	sw	$5, 28($sp)
	add3	$5, $1, $3
	sll	$5, 5
	ldc	$11, $lp
	sw	$6, 24($sp)
	sw	$8, 16($sp)
	mov	$6, $1
	mov	$8, $2
	mov	$1, $5
	mov	$3, 32
	mov	$2, 0
	sw	$11, 12($sp)
	sw	$4, 4($sp)
	bsr	memset
	lw	$3, 40($sp)
	sw	$8, ($5)
	lw	$4, 4($sp)
	sw	$3, 4($5)
	lw	$3, 44($sp)
	mov	$2, $5
	mov	$1, $6
	sw	$3, 8($5)
	lw	$3, 48($sp)
	sw	$3, 12($5)
	lw	$3, 52($sp)
	sw	$3, 16($5)
	mov	$3, $7
	bsr	alice_schedule_task
	lw	$8, 16($sp)
	lw	$7, 20($sp)
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 40
	jmp	$11
	.size	alice_schedule_bob_task, .-alice_schedule_bob_task
	.section	.rodata
	.p2align 2
.LC0:
	.string	"[BOB] copy alice to %X[%X]\n"
	.p2align 2
.LC1:
	.string	"[BOB] failed to clear dst area\n"
	.p2align 2
.LC2:
	.string	"[BOB] set alice uart to %X[%X]\n"
	.text
	.core
	.p2align 1
	.globl alice_loadAlice
	.type	alice_loadAlice, @function
alice_loadAlice:
	# frame: 40   32 regs   8 locals
	add3	$sp, $sp, -40 # 0xffd8
	sw	$3, ($sp)
	lw	$3, 44($sp)
	ldc	$11, $lp
	sw	$6, 24($sp)
	sw	$8, 16($sp)
	sw	$5, 28($sp)
	sw	$7, 20($sp)
	sw	$11, 12($sp)
	mov	$8, $1
	mov	$6, $2
	sw	$4, 4($sp)
	beqz	$3, .L16
	movh	$7, 0x4000
	movh	$5, 0x4
.L10:
	beq	$8, $7, .L11
	mov	$3, $5
	mov	$2, $7
	movu	$1, .LC0
	bsr	debug_printFormat
	mov	$3, $5
	mov	$2, 0
	mov	$1, $7
	bsr	memset32
	lw	$3, ($7)
	beqz	$3, .L12
	movu	$1, .LC1
	bsr	debug_printFormat
	mov	$0, -1 # 0xffff
.L9:
	lw	$8, 16($sp)
	lw	$7, 20($sp)
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 40
	jmp	$11
.L16:
	movh	$7, 0x1f00
	movu	$5, 0x8000
	bra	.L10
.L12:
	mov	$3, $5
	mov	$2, $8
	mov	$1, $7
	bsr	memcpy
.L11:
	movh	$3, %hi(alice_vectors)
	sw	$7, %lo(alice_vectors)($3)
	lw	$3, 64($7)
	movh	$8, %hi(alice_xcfg)
	add3	$8, $8, %lo(alice_xcfg)
	add3	$3, $3, $7
	sw	$3, ($8)
	lw	$3, 76($7)
	movh	$2, %hi(alice_core_status)
	add3	$3, $3, $7
	sw	$3, %lo(alice_core_status)($2)
	lw	$3, 72($7)
	add3	$7, $3, $7
	movh	$3, %hi(alice_tasks)
	add3	$3, $3, %lo(alice_tasks)
	sw	$7, ($3)
	lw	$3, 48($sp)
	beqz	$3, .L14
	movh	$7, %hi(g_uart_bus)
	add3	$7, $7, %lo(g_uart_bus)
	movu	$3, 65562
	lw	$2, ($7)
	movu	$1, .LC2
	bsr	debug_printFormat
	lw	$3, ($8)
	lw	$2, ($7)
	sw	$2, 16($3)
	movu	$2, 65562
	sw	$2, 20($3)
.L14:
	lw	$3, 4($sp)
	beqz	$3, .L15
	bsr	setup_ints
	ei
.L15:
	beqz	$6, .L17
	lw	$3, 44($sp)
	lw	$2, 40($sp)
	lw	$1, ($sp)
	bsr	compat_armReBoot
	mov	$0, 0
	bra	.L9
.L17:
	mov	$0, 0
	bra	.L9
	.size	alice_loadAlice, .-alice_loadAlice
	.p2align 1
	.globl alice_schedule_task
	.type	alice_schedule_task, @function
alice_schedule_task:
	# frame: 48   32 regs   12 args
	add3	$sp, $sp, -48 # 0xffd0
	sw	$8, 24($sp)
	mov	$8, $3
	movh	$3, %hi(alice_core_status)
	ldc	$11, $lp
	lw	$3, %lo(alice_core_status)($3)
	sw	$5, 36($sp)
	sw	$6, 32($sp)
	sw	$7, 28($sp)
	sw	$11, 20($sp)
	mov	$6, $1
	mov	$5, $2
	mov	$7, $4
	beqz	$3, .L25
	movh	$3, %hi(alice_tasks)
	add3	$3, $3, %lo(alice_tasks)
	lw	$3, ($3)
	bnez	$3, .L26
.L25:
	movh	$3, %hi(alice_vectors)
	lw	$3, %lo(alice_vectors)($3)
	bnez	$3, .L33
	movh	$3, 0xe311
	or3	$3, $3, 0xc00
	movh	$1, 0x4000
	lw	$2, ($3)
	bnez	$2, .L28
	movh	$1, 0x1f00
.L28:
	lw	$2, ($3)
	mov	$3, 0
	sw	$3, 8($sp)
	sw	$2, 4($sp)
	sw	$3, ($sp)
	mov	$4, 0
	mov	$2, 0
	bsr	alice_loadAlice
.L26:
	movh	$3, %hi(alice_core_status)
	mov	$1, $6
	lw	$3, %lo(alice_core_status)($3)
	sll	$1, 2
	add3	$3, $3, $1
	lw	$2, ($3)
	and3	$2, $2, 0x4
	beqz	$2, .L29
	beqz	$8, .L35
	erepeat	.L48
	lw	$2, ($3)
.L48:
	and3	$2, $2, 0x4
	beqz	$2, .L49
	# erepeat end
.L49:
.L29:
	mov	$3, 0
	sw	$3, 20($5)
	movh	$3, %hi(alice_tasks)
	add3	$3, $3, %lo(alice_tasks)
	lw	$3, ($3)
	add3	$1, $3, $1
	sw	$5, ($1)
	beqz	$7, .L36
	erepeat	.L50
	lw	$3, 20($5)
	blti	$3, 0, .L31
	lw	$3, 20($5)
.L50:
	and3	$3, $3, 0x4
	bnez	$3, .L51
	# erepeat end
.L51:
.L31:
	lw	$0, 24($5)
.L24:
	lw	$8, 24($sp)
	lw	$7, 28($sp)
	lw	$6, 32($sp)
	lw	$5, 36($sp)
	lw	$11, 20($sp)
	add3	$sp, $sp, 48
	jmp	$11
.L33:
	mov	$0, -1 # 0xffff
	bra	.L24
.L35:
	mov	$0, -2 # 0xfffe
	bra	.L24
.L36:
	mov	$0, 0
	bra	.L24
	.size	alice_schedule_task, .-alice_schedule_task
	.section	.rodata
	.p2align 2
.LC3:
	.string	"[BOB] got alice cmd %X (%X, %X, %X)\n"
	.p2align 2
.LC4:
	.string	"[BOB] alice service terminated\n"
	.p2align 2
.LC5:
	.string	"[BOB] invalid arg for compat acquire\n"
	.text
	.core
	.p2align 1
	.globl alice_handleCmd
	.type	alice_handleCmd, @function
alice_handleCmd:
	# frame: 40   32 regs   4 args
	add3	$sp, $sp, -40 # 0xffd8
	sw	$5, 28($sp)
	sw	$6, 24($sp)
	sw	$7, 20($sp)
	sw	$8, 16($sp)
	mov	$6, $1
	ldc	$11, $lp
	mov	$5, $2
	mov	$8, $3
	mov	$7, $4
	sw	$4, ($sp)
	mov	$4, $3
	mov	$3, $2
	mov	$2, $1
	movu	$1, .LC3
	sw	$11, 12($sp)
	bsr	debug_printFormat
	bgei	$6, 0, .L53
	movh	$3, 0xa21c
	or3	$3, $3, 0xeded
	beq	$6, $3, .L54
	and3	$3, $6, 0x1
	beqz	$3, .L55
	mov	$3, -2 # 0xfffe
	and	$6, $3
.L56:
	mov	$3, $7
	mov	$2, $8
	mov	$1, $5
	jsr	$6
	movh	$3, 0xe000
	sw	$0, 4($3)
	mov	$2, -1 # 0xffff
	mov	$0, -1 # 0xffff
	sw	$2, 16($3)
.L52:
	lw	$8, 16($sp)
	lw	$7, 20($sp)
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 40
	jmp	$11
.L55:
	movh	$3, 0x7fff
	or3	$3, $3, 0xfffe
	and	$6, $3
	bra	.L56
.L53:
	add3	$6, $6, -2592 # 0xf5e0
	mov	$0, 8
	sltu3	$0, $0, $6
	bnez	$0, .L58
	movu	$3, .L60
	sll	$6, 2
	add3	$6, $3, $6
	movh	$3, 0xe000
	lw	$2, ($6)
	jmp	$2
	.p2align 2
	.p2align 2
.L60:
	.word .L59
	.word .L61
	.word .L62
	.word .L63
	.word .L64
	.word .L65
	.word .L66
	.word .L67
	.word .L68
.L54:
	bne	$7, $6, .L69
	movu	$1, .LC4
	bsr	debug_printFormat
	movh	$3, 0xe000
	mov	$2, -1 # 0xffff
	sw	$2, 28($3)
	mov	$0, 0
	sw	$2, 24($3)
	sw	$2, 20($3)
	bra	.L52
.L69:
	movu	$1, .LC5
	bsr	debug_printFormat
.L58:
	movh	$3, 0xe000
	mov	$2, -1 # 0xffff
	sw	$2, 28($3)
	mov	$0, -1 # 0xffff
	sw	$2, 24($3)
	sw	$2, 20($3)
	bra	.L52
.L59:
	movh	$3, %hi(g_rpc_status)
	add3	$3, $3, %lo(g_rpc_status)
	lw	$2, ($3)
	movh	$3, 0xe000
	sw	$2, 4($3)
	bra	.L58
.L61:
	movh	$3, %hi(g_rpc_status)
	add3	$3, $3, %lo(g_rpc_status)
	sw	$5, ($3)
	bra	.L58
.L62:
	lw	$2, 24($3)
	movh	$3, %hi(g_rpc_status)
	beqz	$2, .L70
	mov	$1, $3
	add3	$1, $1, %lo(g_rpc_status)
	lw	$2, ($1)
	or	$5, $2
	sw	$5, ($1)
.L71:
	add3	$3, $3, %lo(g_rpc_status)
	lw	$2, ($3)
	movh	$3, 0xe000
	sw	$2, 4($3)
	bra	.L58
.L70:
	mov	$2, $3
	add3	$2, $2, %lo(g_rpc_status)
	nor	$5, $5
	lw	$1, ($2)
	and	$5, $1
	sw	$5, ($2)
	bra	.L71
.L63:
	mov	$3, $7
	mov	$2, $8
	mov	$1, $5
	bsr	compat_armReBoot
	bra	.L58
.L64:
	mov	$3, $7
	mov	$2, $8
	mov	$1, $5
	bsr	memcpy
	bra	.L58
.L65:
	mov	$3, $7
	mov	$2, $8
	mov	$1, $5
	bsr	memset
	bra	.L58
.L66:
	mov	$3, $7
	mov	$2, $8
	mov	$1, $5
	bsr	memset32
	bra	.L58
.L67:
	bgei	$7, 0, .L72
	movh	$2, 0x7fff
	or3	$2, $2, 0xffff
	and	$2, $7
	mov	$1, $5
	bsr	readAs
	movh	$3, 0xe000
	sw	$0, 4($3)
	bra	.L58
.L72:
	lw	$2, ($5)
	sw	$2, 4($3)
	bra	.L58
.L68:
	bgei	$7, 0, .L73
	movh	$3, 0x7fff
	or3	$3, $3, 0xffff
	and	$3, $7
	mov	$2, $8
	mov	$1, $5
	bsr	writeAs
	bra	.L58
.L73:
	sw	$8, ($5)
	bra	.L58
	.size	alice_handleCmd, .-alice_handleCmd
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
