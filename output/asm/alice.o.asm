	.file	"alice.c"
	.section	.rodata
	.p2align 2
.LC0:
	.string	"[BOB] got alice cmd %X (%X, %X, %X)\n"
	.p2align 2
.LC1:
	.string	"[BOB] alice service terminated\n"
	.p2align 2
.LC2:
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
	movu	$1, .LC0
	sw	$11, 12($sp)
	bsr	debug_printFormat
	bgei	$6, 0, .L2
	movh	$3, 0xa21c
	or3	$3, $3, 0xeded
	beq	$6, $3, .L3
	and3	$3, $6, 0x1
	beqz	$3, .L4
	mov	$3, -2 # 0xfffe
	and	$6, $3
.L5:
	mov	$3, $7
	mov	$2, $8
	mov	$1, $5
	jsr	$6
	movh	$3, 0xe000
	sw	$0, 4($3)
	mov	$2, -1 # 0xffff
	mov	$0, -1 # 0xffff
	sw	$2, 16($3)
.L1:
	lw	$8, 16($sp)
	lw	$7, 20($sp)
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 40
	jmp	$11
.L4:
	movh	$3, 0x7fff
	or3	$3, $3, 0xfffe
	and	$6, $3
	bra	.L5
.L2:
	add3	$6, $6, -2592 # 0xf5e0
	mov	$0, 8
	sltu3	$0, $0, $6
	bnez	$0, .L7
	movu	$3, .L9
	sll	$6, 2
	add3	$6, $3, $6
	movh	$3, 0xe000
	lw	$2, ($6)
	jmp	$2
	.p2align 2
	.p2align 2
.L9:
	.word .L8
	.word .L10
	.word .L11
	.word .L12
	.word .L13
	.word .L14
	.word .L15
	.word .L16
	.word .L17
.L3:
	bne	$7, $6, .L18
	movu	$1, .LC1
	bsr	debug_printFormat
	movh	$3, 0xe000
	mov	$2, -1 # 0xffff
	sw	$2, 28($3)
	mov	$0, 0
	sw	$2, 24($3)
	sw	$2, 20($3)
	bra	.L1
.L18:
	movu	$1, .LC2
	bsr	debug_printFormat
.L7:
	movh	$3, 0xe000
	mov	$2, -1 # 0xffff
	sw	$2, 28($3)
	mov	$0, -1 # 0xffff
	sw	$2, 24($3)
	sw	$2, 20($3)
	bra	.L1
.L8:
	movh	$3, %hi(g_rpc_status)
	add3	$3, $3, %lo(g_rpc_status)
	lw	$2, ($3)
	movh	$3, 0xe000
	sw	$2, 4($3)
	bra	.L7
.L10:
	movh	$3, %hi(g_rpc_status)
	add3	$3, $3, %lo(g_rpc_status)
	sw	$5, ($3)
	bra	.L7
.L11:
	lw	$2, 24($3)
	movh	$3, %hi(g_rpc_status)
	beqz	$2, .L19
	mov	$1, $3
	add3	$1, $1, %lo(g_rpc_status)
	lw	$2, ($1)
	or	$5, $2
	sw	$5, ($1)
.L20:
	add3	$3, $3, %lo(g_rpc_status)
	lw	$2, ($3)
	movh	$3, 0xe000
	sw	$2, 4($3)
	bra	.L7
.L19:
	mov	$2, $3
	add3	$2, $2, %lo(g_rpc_status)
	nor	$5, $5
	lw	$1, ($2)
	and	$5, $1
	sw	$5, ($2)
	bra	.L20
.L12:
	mov	$3, $7
	mov	$2, $8
	mov	$1, $5
	bsr	compat_armReBoot
	bra	.L7
.L13:
	mov	$3, $7
	mov	$2, $8
	mov	$1, $5
	bsr	memcpy
	bra	.L7
.L14:
	mov	$3, $7
	mov	$2, $8
	mov	$1, $5
	bsr	memset
	bra	.L7
.L15:
	mov	$3, $7
	mov	$2, $8
	mov	$1, $5
	bsr	memset32
	bra	.L7
.L16:
	bgei	$7, 0, .L21
	movh	$2, 0x7fff
	or3	$2, $2, 0xffff
	and	$2, $7
	mov	$1, $5
	bsr	readAs
	movh	$3, 0xe000
	sw	$0, 4($3)
	bra	.L7
.L21:
	lw	$2, ($5)
	sw	$2, 4($3)
	bra	.L7
.L17:
	bgei	$7, 0, .L22
	movh	$3, 0x7fff
	or3	$3, $3, 0xffff
	and	$3, $7
	mov	$2, $8
	mov	$1, $5
	bsr	writeAs
	bra	.L7
.L22:
	sw	$8, ($5)
	bra	.L7
	.size	alice_handleCmd, .-alice_handleCmd
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
