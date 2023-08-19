	.file	"debug.c"
	.section .frodata,"a"
	.p2align 2
	.type	debug_hexbase, @object
	.size	debug_hexbase, 17
debug_hexbase:
	.string	"0123456789ABCDEF"
	.text
	.core
	.p2align 1
	.globl debug_printU32
	.type	debug_printU32, @function
debug_printU32:
	# frame: 32   16 regs   16 locals
	add	$sp, -32
	sw	$5, 20($sp)
	ldc	$11, $lp
	sw	$1, ($sp)
	mov	$3, 12
	mov	$5, $2
	add3	$1, $sp, 4
	mov	$2, 48
	sw	$11, 16($sp)
	bsr	memset
	mov	$3, 120
	sb	$3, 5($sp)
	bnez	$5, .L4
	mov	$3, 0
.L2:
	sb	$3, 14($sp)
	mov	$9, $sp
	mov	$3, 0
	add3	$0, $sp, 12
	mov	$1, 3
	sb	$3, 15($sp)
	repeat	$1,.L6
.L3:
	lb	$2, ($9)
	movh	$3, %hi(debug_hexbase)
	add3	$3, $3, %lo(debug_hexbase)
	and3	$10, $2, 0xf
	sra	$2, 4
	and3	$2, $2, 0xf
	add3	$10, $3, $10
	add3	$3, $3, $2
	lb	$10, ($10)
	lb	$3, ($3)
	add	$9, 1
	sb	$10, 1($0)
.L6:
	sb	$3, ($0)
	add	$0, -2
	# repeat end
	movh	$3, %hi(g_uart_bus)
	add3	$2, $sp, 4
	lw	$1, %lo(g_uart_bus)($3)
	bsr	uart_print
	lw	$5, 20($sp)
	lw	$11, 16($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L4:
	mov	$3, 10
	bra	.L2
	.size	debug_printU32, .-debug_printU32
	.p2align 1
	.globl debug_printFormat
	.type	debug_printFormat, @function
debug_printFormat:
	# frame: 64   32 regs   32 locals
	add3	$sp, $sp, -64 # 0xffc0
	ldc	$11, $lp
	sw	$5, 52($sp)
	sw	$6, 48($sp)
	sw	$7, 44($sp)
	sw	$8, 40($sp)
	sw	$11, 36($sp)
	sw	$2, 4($sp)
	sw	$3, 8($sp)
	sw	$4, 12($sp)
	mov	$5, $1
	bsr	strlen
	mov	$6, $0
	beqz	$0, .L7
	add3	$3, $sp, 4
	sw	$3, 16($sp)
	add3	$3, $sp, 16
	sw	$3, 20($sp)
	add3	$0, $sp, 32
	add3	$3, $sp, 64
	mov	$8, 0
	mov	$9, 0
	movh	$7, %hi(g_uart_bus)
	sw	$0, 24($sp)
	sw	$3, 28($sp)
.L9:
	slt3	$0, $8, $6
	bnez	$0, .L19
	movh	$1, %hi(g_uart_bus)
	mov	$3, $8
	lw	$1, %lo(g_uart_bus)($1)
	sub	$3, $9
	add3	$2, $5, $9
	bsr	uart_printn
.L7:
	lw	$8, 40($sp)
	lw	$7, 44($sp)
	lw	$6, 48($sp)
	lw	$5, 52($sp)
	lw	$11, 36($sp)
	add3	$sp, $sp, 64
	jmp	$11
.L19:
	add3	$3, $5, $8
	lb	$2, ($3)
	mov	$3, 37
	bne	$2, $3, .L10
	movh	$1, %hi(g_uart_bus)
	mov	$3, $8
	lw	$1, %lo(g_uart_bus)($1)
	sub	$3, $9
	add3	$2, $5, $9
	sw	$9, ($sp)
	bsr	uart_printn
	add3	$2, $8, 1
	add3	$3, $5, $2
	mov	$1, 88
	lb	$3, ($3)
	lw	$9, ($sp)
	beq	$3, $1, .L11
	slt3	$1, $3, 89
	beqz	$1, .L12
	mov	$1, 83
	beq	$3, $1, .L13
.L21:
	mov	$8, $2
	bra	.L10
.L12:
	mov	$1, 115
	beq	$3, $1, .L13
	mov	$1, 120
	bne	$3, $1, .L21
.L11:
	lw	$3, 16($sp)
	lw	$0, 20($sp)
	sltu3	$0, $3, $0
	beqz	$0, .L14
	add3	$2, $3, 4
	sw	$2, 16($sp)
	lw	$2, 24($sp)
	add	$2, 8
	sw	$2, 24($sp)
.L15:
	lw	$1, ($3)
	mov	$2, 0
	bsr	debug_printU32
.L16:
	add	$8, 2
	mov	$9, $8
.L10:
	add	$8, 1
	bra	.L9
.L14:
	lw	$3, 28($sp)
	add3	$2, $3, 4
	sw	$2, 28($sp)
	bra	.L15
.L13:
	lw	$3, 16($sp)
	lw	$0, 20($sp)
	lw	$1, %lo(g_uart_bus)($7)
	sltu3	$0, $3, $0
	beqz	$0, .L17
	add3	$2, $3, 4
	sw	$2, 16($sp)
	lw	$2, 24($sp)
	add	$2, 8
	sw	$2, 24($sp)
.L18:
	lw	$2, ($3)
	bsr	uart_print
	bra	.L16
.L17:
	lw	$3, 28($sp)
	add3	$2, $3, 4
	sw	$2, 28($sp)
	bra	.L18
	.size	debug_printFormat, .-debug_printFormat
	.section	.rodata
	.p2align 2
.LC0:
	.string	"%X: "
	.p2align 2
.LC1:
	.string	" \n"
	.text
	.core
	.p2align 1
	.type	printRange32, @function
printRange32:
	# frame: 64   32 regs   28 locals
	add3	$sp, $sp, -64 # 0xffc0
	ldc	$11, $lp
	sw	$7, 44($sp)
	sw	$8, 40($sp)
	sw	$5, 52($sp)
	sw	$6, 48($sp)
	sw	$11, 36($sp)
	mov	$8, $1
	mov	$7, $2
	sw	$3, 8($sp)
	beqz	$2, .L25
	beqz	$3, .L27
	mov	$2, $1
	movu	$1, .LC0
	bsr	debug_printFormat
.L27:
	mov	$3, 0
	mov	$10, 0
	movh	$6, %hi(g_uart_bus)
	sb	$3, 31($sp)
.L28:
	sltu3	$0, $10, $7
	bnez	$0, .L32
	lw	$1, %lo(g_uart_bus)($6)
	movu	$2, .LC1
	bsr	uart_print
.L25:
	lw	$8, 40($sp)
	lw	$7, 44($sp)
	lw	$6, 48($sp)
	lw	$5, 52($sp)
	lw	$11, 36($sp)
	add3	$sp, $sp, 64
	jmp	$11
.L32:
	mov	$5, -4 # 0xfffc
	and	$5, $10
	add3	$3, $8, $5
	mov	$9, 32
	lw	$2, ($3)
	movh	$3, %hi(debug_hexbase)
	add3	$3, $3, %lo(debug_hexbase)
	mov	$1, $2
	srl	$1, 4
	and3	$1, $1, 0xf
	add3	$1, $3, $1
	sw	$10, 4($sp)
	lb	$1, ($1)
	sb	$9, 21($sp)
	sb	$9, 24($sp)
	sb	$1, 19($sp)
	and3	$1, $2, 0xf
	add3	$1, $3, $1
	sb	$9, 27($sp)
	lb	$1, ($1)
	sb	$9, 30($sp)
	sb	$1, 20($sp)
	mov	$1, $2
	srl	$1, 12
	and3	$1, $1, 0xf
	add3	$1, $3, $1
	lb	$1, ($1)
	sb	$1, 22($sp)
	mov	$1, $2
	srl	$1, 8
	and3	$1, $1, 0xf
	add3	$1, $3, $1
	lb	$1, ($1)
	sb	$1, 23($sp)
	mov	$1, $2
	srl	$1, 20
	and3	$1, $1, 0xf
	add3	$1, $3, $1
	lb	$1, ($1)
	sb	$1, 25($sp)
	mov	$1, $2
	srl	$1, 16
	and3	$1, $1, 0xf
	add3	$1, $3, $1
	lb	$1, ($1)
	sb	$1, 26($sp)
	mov	$1, $2
	srl	$2, 24
	srl	$1, 28
	add3	$1, $3, $1
	and3	$2, $2, 0xf
	lb	$1, ($1)
	add3	$3, $3, $2
	add3	$2, $sp, 19
	lb	$3, ($3)
	sb	$1, 28($sp)
	lw	$1, %lo(g_uart_bus)($6)
	sb	$3, 29($sp)
	bsr	uart_print
	lw	$10, 4($sp)
	and3	$3, $10, 0xc
	add	$10, 4
	sw	$10, 12($sp)
	bnei	$3, 12, .L30
	lw	$1, %lo(g_uart_bus)($6)
	movu	$2, .LC1
	bsr	uart_print
	lw	$0, 8($sp)
	beqz	$0, .L30
	lw	$3, 12($sp)
	sltu3	$0, $3, $7
	beqz	$0, .L30
	add3	$2, $5, 4
	add3	$2, $8, $2
	movu	$1, .LC0
	bsr	debug_printFormat
.L30:
	lw	$10, 12($sp)
	bra	.L28
	.size	printRange32, .-printRange32
	.p2align 1
	.type	printRange8, @function
printRange8:
	# frame: 48   32 regs   12 locals
	add3	$sp, $sp, -48 # 0xffd0
	ldc	$11, $lp
	sw	$5, 36($sp)
	sw	$6, 32($sp)
	sw	$7, 28($sp)
	sw	$8, 24($sp)
	sw	$11, 20($sp)
	mov	$5, $1
	mov	$6, $2
	mov	$7, $3
	beqz	$2, .L43
	beqz	$3, .L45
	mov	$2, $1
	movu	$1, .LC0
	bsr	debug_printFormat
.L45:
	mov	$3, 0
	add	$5, 1
	mov	$8, 0
	sb	$3, 15($sp)
.L49:
	lb	$1, -1($5)
	movh	$3, %hi(debug_hexbase)
	add3	$3, $3, %lo(debug_hexbase)
	mov	$2, $1
	sra	$2, 4
	and3	$1, $1, 0xf
	and3	$2, $2, 0xf
	add3	$2, $3, $2
	add3	$3, $3, $1
	lb	$2, ($2)
	lb	$3, ($3)
	sb	$2, 12($sp)
	sb	$3, 13($sp)
	mov	$3, 32
	sb	$3, 14($sp)
	movh	$3, %hi(g_uart_bus)
	add3	$3, $3, %lo(g_uart_bus)
	add3	$2, $sp, 12
	lw	$1, ($3)
	sw	$3, 4($sp)
	bsr	uart_print
	and3	$2, $8, 0xf
	lw	$3, 4($sp)
	add	$8, 1
	bnei	$2, 15, .L47
	lw	$1, ($3)
	movu	$2, .LC1
	bsr	uart_print
	beqz	$7, .L47
	sltu3	$0, $8, $6
	beqz	$0, .L47
	mov	$2, $5
	movu	$1, .LC0
	bsr	debug_printFormat
.L47:
	add	$5, 1
	bne	$6, $8, .L49
	movh	$3, %hi(g_uart_bus)
	movu	$2, .LC1
	lw	$1, %lo(g_uart_bus)($3)
	bsr	uart_print
.L43:
	lw	$8, 24($sp)
	lw	$7, 28($sp)
	lw	$6, 32($sp)
	lw	$5, 36($sp)
	lw	$11, 20($sp)
	add3	$sp, $sp, 48
	jmp	$11
	.size	printRange8, .-printRange8
	.p2align 1
	.globl debug_printRange
	.type	debug_printRange, @function
debug_printRange:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	sw	$11, 4($sp)
	mov	$0, $2
	beqz	$2, .L61
	or	$0, $1
	and3	$0, $0, 0x3
	beqz	$0, .L63
	bsr	printRange8
.L61:
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
.L63:
	bsr	printRange32
	bra	.L61
	.size	debug_printRange, .-debug_printRange
	.p2align 1
	.globl debug_setGpoCode
	.type	debug_setGpoCode, @function
debug_setGpoCode:
	movh	$3, 0xe20a
	or3	$3, $3, 0xc
	movh	$2, 0xff
	sw	$2, ($3)
	movh	$3, 0xe20a
	or3	$3, $3, 0x34
	extub	$1
	lw	$2, ($3)
	movh	$2, 0xe20a
	sll	$1, 16
	or3	$2, $2, 0x8
	sw	$1, ($2)
	lw	$3, ($3)
	ret
	.size	debug_setGpoCode, .-debug_setGpoCode
	.section	.rodata
	.p2align 2
.LC2:
	.string	"$0"
	.p2align 2
.LC3:
	.string	"$1"
	.p2align 2
.LC4:
	.string	"$2"
	.p2align 2
.LC5:
	.string	"$3"
	.p2align 2
.LC6:
	.string	"$4"
	.p2align 2
.LC7:
	.string	"$5"
	.p2align 2
.LC8:
	.string	"$6"
	.p2align 2
.LC9:
	.string	"$7"
	.p2align 2
.LC10:
	.string	"$8"
	.p2align 2
.LC11:
	.string	"$9"
	.p2align 2
.LC12:
	.string	"$10"
	.p2align 2
.LC13:
	.string	"$11"
	.p2align 2
.LC14:
	.string	"$12"
	.p2align 2
.LC15:
	.string	"$tp"
	.p2align 2
.LC16:
	.string	"$gp"
	.p2align 2
.LC17:
	.string	"$sp"
	.p2align 2
.LC18:
	.string	"$pc"
	.p2align 2
.LC19:
	.string	"$lp"
	.p2align 2
.LC20:
	.string	"$sar"
	.p2align 2
.LC21:
	.string	"3"
	.p2align 2
.LC22:
	.string	"$rpb"
	.p2align 2
.LC23:
	.string	"$rpe"
	.p2align 2
.LC24:
	.string	"$rpc"
	.p2align 2
.LC25:
	.string	"$hi"
	.p2align 2
.LC26:
	.string	"$lo"
	.p2align 2
.LC27:
	.string	"9"
	.p2align 2
.LC28:
	.string	"10"
	.p2align 2
.LC29:
	.string	"11"
	.p2align 2
.LC30:
	.string	"$mb0"
	.p2align 2
.LC31:
	.string	"$me0"
	.p2align 2
.LC32:
	.string	"$mb1"
	.p2align 2
.LC33:
	.string	"$me1"
	.p2align 2
.LC34:
	.string	"$psw"
	.p2align 2
.LC35:
	.string	"$id"
	.p2align 2
.LC36:
	.string	"$tmp"
	.p2align 2
.LC37:
	.string	"$epc"
	.p2align 2
.LC38:
	.string	"$exc"
	.p2align 2
.LC39:
	.string	"$cfg"
	.p2align 2
.LC40:
	.string	"22"
	.p2align 2
.LC41:
	.string	"$npc"
	.p2align 2
.LC42:
	.string	"$dbg"
	.p2align 2
.LC43:
	.string	"$depc"
	.p2align 2
.LC44:
	.string	"$opt"
	.p2align 2
.LC45:
	.string	"$rcfg"
	.p2align 2
.LC46:
	.string	"$ccfg"
	.p2align 2
.LC47:
	.string	"29"
	.p2align 2
.LC48:
	.string	"30"
	.p2align 2
.LC49:
	.string	"31"
	.section .far,"aw"
	.p2align 2
	.type	regdump_registers, @object
	.size	regdump_registers, 192
regdump_registers:
	.long	.LC2
	.long	.LC3
	.long	.LC4
	.long	.LC5
	.long	.LC6
	.long	.LC7
	.long	.LC8
	.long	.LC9
	.long	.LC10
	.long	.LC11
	.long	.LC12
	.long	.LC13
	.long	.LC14
	.long	.LC15
	.long	.LC16
	.long	.LC17
	.long	.LC18
	.long	.LC19
	.long	.LC20
	.long	.LC21
	.long	.LC22
	.long	.LC23
	.long	.LC24
	.long	.LC25
	.long	.LC26
	.long	.LC27
	.long	.LC28
	.long	.LC29
	.long	.LC30
	.long	.LC31
	.long	.LC32
	.long	.LC33
	.long	.LC34
	.long	.LC35
	.long	.LC36
	.long	.LC37
	.long	.LC38
	.long	.LC39
	.long	.LC40
	.long	.LC41
	.long	.LC42
	.long	.LC43
	.long	.LC44
	.long	.LC45
	.long	.LC46
	.long	.LC47
	.long	.LC48
	.long	.LC49
	.section	.rodata
	.p2align 2
.LC50:
	.string	"CORE:\n"
	.p2align 2
.LC51:
	.string	"\nCONTROL:\n"
	.p2align 2
.LC52:
	.string	" %s: %x\n"
	.text
	.core
	.p2align 1
	.globl debug_c_regdump
	.type	debug_c_regdump, @function
debug_c_regdump:
	# frame: 32   32 regs
	movh	$3, %hi(g_uart_bus)
	add	$sp, -32
	lw	$1, %lo(g_uart_bus)($3)
	sw	$6, 16($sp)
	movh	$6, %hi(regdump_registers)
	ldc	$11, $lp
	movu	$2, .LC50
	add3	$6, $6, %lo(regdump_registers)
	sw	$5, 20($sp)
	sw	$7, 12($sp)
	sw	$8, 8($sp)
	sw	$11, 4($sp)
	mov	$5, 0
	bsr	uart_print
	movh	$7, %hi(g_uart_bus)
	mov	$8, $6
.L69:
	mov	$3, $8
	sub	$3, $6
	add3	$3, $3, $gp
	lw	$2, ($8)
	lw	$3, ($3)
	movu	$1, .LC52
	add	$5, 1
	bsr	debug_printFormat
	mov	$3, 48
	bne	$5, $3, .L71
	lw	$8, 8($sp)
	lw	$7, 12($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L71:
	mov	$3, 16
	bne	$5, $3, .L70
	lw	$1, %lo(g_uart_bus)($7)
	movu	$2, .LC51
	bsr	uart_print
.L70:
	add	$8, 4
	bra	.L69
	.size	debug_c_regdump, .-debug_c_regdump
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
