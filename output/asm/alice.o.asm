	.file	"alice.c"
	.text
	.core
	.p2align 1
	.globl alice_armReBoot
	.type	alice_armReBoot, @function
alice_armReBoot:
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
	beqz	$5, .L2
	mov	$4, 1
	mov	$3, 1
	mov	$2, 1
	mov	$1, 1
	bsr	pervasive_control_reset
.L2:
	mov	$4, 1
	mov	$3, 0
	mov	$2, -1 # 0xffff
	mov	$1, 0
	bsr	pervasive_control_gate
	beqz	$5, .L3
	mov	$4, 1
	mov	$3, 0
	mov	$2, -1 # 0xffff
	mov	$1, 1
	bsr	pervasive_control_gate
.L3:
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
	erepeat	.L23
	nop
.L23:
	lw	$2, ($3)
	beqi	$2, 1, .L24
	# erepeat end
.L24:
	sw	$2, ($3)
	movh	$3, 0xe310
	or3	$3, $3, 0xc0
	erepeat	.L25
	nop
.L25:
	lw	$2, ($3)
	bnei	$2, 1, .L26
	# erepeat end
.L26:
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
	erepeat	.L27
	nop
.L27:
	lw	$2, ($3)
	beq	$6, $2, .L28
	# erepeat end
.L28:
	movh	$2, 0xc1
	bnez	$5, .L7
	movh	$2, 0x1
.L7:
	mov	$4, 1
	mov	$3, 1
	mov	$1, 0
	bsr	pervasive_control_gate
	beqz	$5, .L8
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
.L8:
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
	.size	alice_armReBoot, .-alice_armReBoot
	.p2align 1
	.globl alice_setupInts
	.type	alice_setupInts, @function
alice_setupInts:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	mov	$2, 0
	mov	$1, 3
	sw	$11, 4($sp)
	bsr	cbus_write
	movh	$2, 0x777
	or3	$2, $2, 0x7777
	mov	$1, 4
	bsr	cbus_write
	mov	$2, 30591 # 0x777f
	mov	$1, 5
	bsr	cbus_write
	mov	$2, 0
	mov	$1, 6
	bsr	cbus_write
	mov	$2, 0
	mov	$1, 7
	bsr	cbus_write
	mov	$2, 1536 # 0x600
	mov	$1, 0
	bsr	cbus_write
	mov	$2, 256 # 0x100
	mov	$1, 2
	bsr	cbus_write
#APP
;# 75 "source/alice.c" 1
	ldc $0, $psw
or3 $0, $0, 0x110
stc $0, $psw

;# 0 "" 2
#NO_APP
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	alice_setupInts, .-alice_setupInts
	.section	.rodata
	.p2align 2
.LC0:
	.string	"[BOB] got alice cmd %X (%X, %X, %X)\n"
	.p2align 2
.LC1:
	.string	"[BOB] alice service terminated\n"
	.text
	.core
	.p2align 1
	.globl alice_handleCmd
	.type	alice_handleCmd, @function
alice_handleCmd:
	# frame: 32   24 regs   4 args
	add	$sp, -32
	sw	$5, 20($sp)
	ldc	$11, $lp
	movh	$5, 0xe000
	sw	$6, 16($sp)
	sw	$11, 12($sp)
	lw	$6, 16($5)
	lw	$3, 20($5)
	lw	$4, 24($5)
	lw	$2, 28($5)
	movu	$1, .LC0
	sw	$2, ($sp)
	mov	$2, $6
	bsr	debug_printFormat
	bgei	$6, 0, .L31
	movh	$3, 0xa21c
	or3	$3, $3, 0xeded
	beq	$6, $3, .L32
	and3	$3, $6, 0x1
	beqz	$3, .L33
	mov	$3, -2 # 0xfffe
	and	$6, $3
.L34:
	movh	$5, 0xe000
	lw	$1, 20($5)
	lw	$2, 24($5)
	lw	$3, 28($5)
	jsr	$6
	sw	$0, 4($5)
	mov	$3, -1 # 0xffff
	mov	$0, -1 # 0xffff
	sw	$3, 16($5)
.L30:
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L33:
	movh	$3, 0x7fff
	or3	$3, $3, 0xfffe
	and	$6, $3
	bra	.L34
.L31:
	add3	$6, $6, -2592 # 0xf5e0
	mov	$0, 8
	sltu3	$0, $0, $6
	bnez	$0, .L36
	sll	$6, 2
	movu	$3, .L38
	add3	$6, $3, $6
	lw	$2, ($6)
	jmp	$2
	.p2align 2
	.p2align 2
.L38:
	.word .L37
	.word .L39
	.word .L40
	.word .L41
	.word .L42
	.word .L43
	.word .L44
	.word .L45
	.word .L46
.L32:
	movu	$1, .LC1
	bsr	debug_printFormat
	mov	$3, -1 # 0xffff
	sw	$3, 16($5)
	mov	$0, 0
	bra	.L30
.L37:
	movh	$3, %hi(g_rpc_status)
	add3	$3, $3, %lo(g_rpc_status)
	lw	$2, ($3)
	movh	$3, 0xe000
	sw	$2, 4($3)
.L36:
	movh	$3, 0xe000
	mov	$2, -1 # 0xffff
	sw	$2, 28($3)
	mov	$0, -1 # 0xffff
	sw	$2, 24($3)
	sw	$2, 20($3)
	sw	$2, 16($3)
	bra	.L30
.L39:
	lw	$2, 20($5)
	movh	$3, %hi(g_rpc_status)
	add3	$3, $3, %lo(g_rpc_status)
	sw	$2, ($3)
	bra	.L36
.L40:
	lw	$1, 24($5)
	movh	$2, %hi(g_rpc_status)
	beqz	$1, .L47
	mov	$1, $2
	add3	$1, $1, %lo(g_rpc_status)
	lw	$0, 20($5)
	lw	$3, ($1)
	or	$3, $0
	sw	$3, ($1)
.L48:
	add3	$2, $2, %lo(g_rpc_status)
	movh	$3, 0xe000
	lw	$2, ($2)
	sw	$2, 4($3)
	bra	.L36
.L47:
	mov	$1, $2
	add3	$1, $1, %lo(g_rpc_status)
	lw	$3, 20($5)
	lw	$0, ($1)
	nor	$3, $3
	and	$3, $0
	sw	$3, ($1)
	bra	.L48
.L41:
	lw	$1, 20($5)
	lw	$2, 24($5)
	lw	$3, 28($5)
	bsr	alice_armReBoot
	bra	.L36
.L42:
	lw	$1, 20($5)
	lw	$2, 24($5)
	lw	$3, 28($5)
	bsr	memcpy
	bra	.L36
.L43:
	lw	$1, 20($5)
	lw	$2, 24($5)
	lw	$3, 28($5)
	bsr	memset
	bra	.L36
.L44:
	lw	$1, 20($5)
	lw	$2, 24($5)
	lw	$3, 28($5)
	bsr	memset32
	bra	.L36
.L45:
	lw	$2, 20($5)
	lw	$2, ($2)
	sw	$2, 4($5)
	bra	.L36
.L46:
	lw	$2, 20($5)
	lw	$3, 24($5)
	lw	$3, ($3)
	sw	$3, ($2)
	bra	.L36
	.size	alice_handleCmd, .-alice_handleCmd
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
