	.file	"alice.c"
	.text
	.core
	.p2align 1
	.globl alice_armReBoot
	.type	alice_armReBoot, @function
alice_armReBoot:
	movh	$0, 0xe310
	or3	$0, $0, 0x2000
	mov	$9, 0
	sw	$9, ($0)
	erepeat	.L52
	nop
.L52:
	lw	$9, ($0)
	beqz	$9, .L53
	# erepeat end
.L53:
	bnez	$2, .L3
.L6:
	movh	$0, 0xe310
	movh	$9, 0x1
	or3	$0, $0, 0x1000
	or3	$9, $9, 0xf
	sw	$9, ($0)
	erepeat	.L54
	nop
.L54:
	lw	$10, ($0)
	beq	$10, $9, .L55
	# erepeat end
.L55:
	bnez	$2, .L7
.L10:
	movh	$0, 0xe310
	or3	$0, $0, 0x2180
	mov	$10, -129 # 0xff7f
	lw	$9, ($0)
	and	$10, $9
	sw	$10, ($0)
	erepeat	.L56
	nop
.L56:
	lw	$11, ($0)
	beq	$10, $11, .L57
	# erepeat end
.L57:
	movh	$0, 0xe310
	or3	$0, $0, 0x1184
	mov	$10, 0
	sw	$10, ($0)
	erepeat	.L58
	nop
.L58:
	lw	$10, ($0)
	beqz	$10, .L59
	# erepeat end
.L59:
	movh	$0, 0xe310
	or3	$9, $9, 0x80
	or3	$0, $0, 0x2180
	sw	$9, ($0)
	erepeat	.L60
	nop
.L60:
	lw	$10, ($0)
	beq	$9, $10, .L61
	# erepeat end
.L61:
	movh	$0, 0xe310
	or3	$0, $0, 0x3000
	mov	$9, 1
	sw	$9, ($0)
	erepeat	.L62
	nop
.L62:
	lw	$9, ($0)
	beqi	$9, 1, .L63
	# erepeat end
.L63:
	movh	$0, 0xe310
	or3	$0, $0, 0x30
	mov	$9, 0
	sw	$9, ($0)
	erepeat	.L64
	nop
.L64:
	lw	$9, ($0)
	beqz	$9, .L65
	# erepeat end
.L65:
	movh	$0, 0xe310
	or3	$0, $0, 0x50
	mov	$9, 1
	sw	$9, ($0)
	erepeat	.L66
	nop
.L66:
	lw	$9, ($0)
	beqi	$9, 1, .L67
	# erepeat end
.L67:
	movh	$0, 0xe310
	or3	$0, $0, 0xc0
	erepeat	.L68
	nop
.L68:
	lw	$9, ($0)
	beqi	$9, 1, .L69
	# erepeat end
.L69:
	sw	$9, ($0)
	movh	$0, 0xe310
	or3	$0, $0, 0xc0
	erepeat	.L70
	nop
.L70:
	lw	$9, ($0)
	bnei	$9, 1, .L71
	# erepeat end
.L71:
	movh	$0, 0xe310
	or3	$0, $0, 0x2000
	movh	$9, 0xc0
	sw	$9, ($0)
	erepeat	.L72
	nop
.L72:
	lw	$10, ($0)
	beq	$10, $9, .L73
	# erepeat end
.L73:
	mov	$9, 0
	sw	$9, ($0)
	movh	$0, 0xe310
	or3	$0, $0, 0x2000
	erepeat	.L74
	nop
.L74:
	lw	$9, ($0)
	beqz	$9, .L75
	# erepeat end
.L75:
	movh	$0, 0xe310
	and3	$1, $1, 0xf
	or3	$0, $0, 0x3000
	sw	$1, ($0)
	erepeat	.L76
	nop
.L76:
	lw	$9, ($0)
	beq	$1, $9, .L77
	# erepeat end
.L77:
	movh	$1, 0xe311
	and3	$3, $3, 0x1
	or3	$1, $1, 0xc00
	sw	$3, ($1)
	erepeat	.L78
	nop
.L78:
	lw	$0, ($1)
	beq	$3, $0, .L79
	# erepeat end
.L79:
	movh	$1, 0xc1
	bnez	$2, .L22
	movh	$1, 0x1
.L22:
	movh	$3, 0xe310
	or3	$3, $3, 0x2000
	sw	$1, ($3)
	erepeat	.L80
	nop
.L80:
	lw	$1, ($3)
	bnez	$1, .L81
	# erepeat end
.L81:
	bnez	$2, .L24
.L28:
	movh	$3, 0xe310
	or3	$3, $3, 0x1000
	mov	$2, 0
	sw	$2, ($3)
	erepeat	.L82
	nop
.L82:
	lw	$2, ($3)
	beqz	$2, .L83
	# erepeat end
.L83:
	ret
.L3:
	movh	$0, 0xe310
	or3	$0, $0, 0x2004
	sw	$9, ($0)
	erepeat	.L84
	nop
.L84:
	lw	$9, ($0)
	beqz	$9, .L85
	# erepeat end
.L85:
	bra	.L6
.L7:
	movh	$0, 0xe310
	or3	$0, $0, 0x1004
	mov	$9, 1
	sw	$9, ($0)
	erepeat	.L86
	nop
.L86:
	lw	$9, ($0)
	beqi	$9, 1, .L87
	# erepeat end
.L87:
	bra	.L10
.L24:
	movh	$3, 0xe310
	or3	$3, $3, 0x2004
	mov	$2, 1
	sw	$2, ($3)
	erepeat	.L88
	nop
.L88:
	lw	$2, ($3)
	beqi	$2, 1, .L89
	# erepeat end
.L89:
	movh	$3, 0xe310
	or3	$3, $3, 0x1004
	mov	$2, 0
	sw	$2, ($3)
	erepeat	.L90
	nop
.L90:
	lw	$2, ($3)
	beqz	$2, .L91
	# erepeat end
.L91:
	bra	.L28
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
;# 90 "source/alice.c" 1
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
	bgei	$6, 0, .L94
	movh	$3, 0xa21c
	or3	$3, $3, 0xeded
	beq	$6, $3, .L95
	and3	$3, $6, 0x1
	beqz	$3, .L96
	mov	$3, -2 # 0xfffe
	and	$6, $3
.L97:
	movh	$5, 0xe000
	lw	$1, 20($5)
	lw	$2, 24($5)
	lw	$3, 28($5)
	jsr	$6
	sw	$0, 4($5)
	mov	$3, -1 # 0xffff
	mov	$0, -1 # 0xffff
	sw	$3, 16($5)
.L93:
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L96:
	movh	$3, 0x7fff
	or3	$3, $3, 0xfffe
	and	$6, $3
	bra	.L97
.L94:
	add3	$6, $6, -2592 # 0xf5e0
	mov	$0, 8
	sltu3	$0, $0, $6
	bnez	$0, .L99
	sll	$6, 2
	movu	$3, .L101
	add3	$6, $3, $6
	lw	$2, ($6)
	jmp	$2
	.p2align 2
	.p2align 2
.L101:
	.word .L100
	.word .L102
	.word .L103
	.word .L104
	.word .L105
	.word .L106
	.word .L107
	.word .L108
	.word .L109
.L95:
	movu	$1, .LC1
	bsr	debug_printFormat
	mov	$3, -1 # 0xffff
	sw	$3, 16($5)
	mov	$0, 0
	bra	.L93
.L100:
	movh	$3, %hi(g_rpc_status)
	add3	$3, $3, %lo(g_rpc_status)
	lw	$2, ($3)
	movh	$3, 0xe000
	sw	$2, 4($3)
.L99:
	movh	$3, 0xe000
	mov	$2, -1 # 0xffff
	sw	$2, 28($3)
	mov	$0, -1 # 0xffff
	sw	$2, 24($3)
	sw	$2, 20($3)
	sw	$2, 16($3)
	bra	.L93
.L102:
	lw	$2, 20($5)
	movh	$3, %hi(g_rpc_status)
	add3	$3, $3, %lo(g_rpc_status)
	sw	$2, ($3)
	bra	.L99
.L103:
	lw	$1, 24($5)
	movh	$2, %hi(g_rpc_status)
	beqz	$1, .L110
	mov	$1, $2
	add3	$1, $1, %lo(g_rpc_status)
	lw	$0, 20($5)
	lw	$3, ($1)
	or	$3, $0
	sw	$3, ($1)
.L111:
	add3	$2, $2, %lo(g_rpc_status)
	movh	$3, 0xe000
	lw	$2, ($2)
	sw	$2, 4($3)
	bra	.L99
.L110:
	mov	$1, $2
	add3	$1, $1, %lo(g_rpc_status)
	lw	$3, 20($5)
	lw	$0, ($1)
	nor	$3, $3
	and	$3, $0
	sw	$3, ($1)
	bra	.L111
.L104:
	lw	$1, 20($5)
	lw	$2, 24($5)
	lw	$3, 28($5)
	bsr	alice_armReBoot
	bra	.L99
.L105:
	lw	$1, 20($5)
	lw	$2, 24($5)
	lw	$3, 28($5)
	bsr	memcpy
	bra	.L99
.L106:
	lw	$1, 20($5)
	lw	$2, 24($5)
	lw	$3, 28($5)
	bsr	memset
	bra	.L99
.L107:
	lw	$1, 20($5)
	lw	$2, 24($5)
	lw	$3, 28($5)
	bsr	memset32
	bra	.L99
.L108:
	lw	$2, 20($5)
	lw	$2, ($2)
	sw	$2, 4($5)
	bra	.L99
.L109:
	lw	$2, 20($5)
	lw	$3, 24($5)
	lw	$3, ($3)
	sw	$3, ($2)
	bra	.L99
	.size	alice_handleCmd, .-alice_handleCmd
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
