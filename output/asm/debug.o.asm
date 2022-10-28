	.file	"debug.c"
	.section	.rodata
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
	movh	$10, %hi(debug_hexbase)
	sb	$3, 14($sp)
	mov	$0, $sp
	mov	$3, 0
	add3	$1, $sp, 12
	add3	$10, $10, %lo(debug_hexbase)
	mov	$2, 3
	sb	$3, 15($sp)
	repeat	$2,.L6
.L3:
	lb	$3, ($0)
	add	$1, -2
	add	$0, 1
	and3	$9, $3, 0xf
	sra	$3, 4
	and3	$3, $3, 0xf
	add3	$9, $10, $9
	add3	$3, $10, $3
	lb	$9, ($9)
	lb	$3, ($3)
.L6:
	sb	$9, 3($1)
	sb	$3, 2($1)
	# repeat end
	add3	$2, $sp, 4
	mov	$1, 1
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
	mov	$7, 37
	sw	$0, 24($sp)
	sw	$3, 28($sp)
.L9:
	slt3	$0, $8, $6
	bnez	$0, .L19
	mov	$3, $8
	sub	$3, $9
	add3	$2, $5, $9
	mov	$1, 1
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
	lb	$3, ($3)
	bne	$3, $7, .L10
	mov	$3, $8
	sub	$3, $9
	add3	$2, $5, $9
	mov	$1, 1
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
	sltu3	$0, $3, $0
	beqz	$0, .L17
	add3	$2, $3, 4
	sw	$2, 16($sp)
	lw	$2, 24($sp)
	add	$2, 8
	sw	$2, 24($sp)
.L18:
	lw	$2, ($3)
	mov	$1, 1
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
	.globl debug_printRange
	.type	debug_printRange, @function
debug_printRange:
	# frame: 40   32 regs   8 locals
	add3	$sp, $sp, -40 # 0xffd8
	ldc	$11, $lp
	sw	$6, 24($sp)
	sw	$7, 20($sp)
	sw	$8, 16($sp)
	sw	$5, 28($sp)
	sw	$11, 12($sp)
	mov	$6, $1
	mov	$7, $2
	mov	$8, $3
	beqz	$2, .L25
	beqz	$3, .L27
	mov	$2, $1
	movu	$1, .LC0
	bsr	debug_printFormat
.L27:
	mov	$3, 0
	add	$6, 1
	mov	$5, 0
	sb	$3, 7($sp)
.L31:
	lb	$1, -1($6)
	movu	$2, debug_hexbase
	mov	$3, $1
	sra	$3, 4
	and3	$3, $3, 0xf
	add3	$3, $2, $3
	and3	$1, $1, 0xf
	lb	$3, ($3)
	add3	$2, $2, $1
	mov	$1, 1
	sb	$3, 4($sp)
	lb	$3, ($2)
	add3	$2, $sp, 4
	sb	$3, 5($sp)
	mov	$3, 32
	sb	$3, 6($sp)
	bsr	uart_print
	and3	$3, $5, 0xf
	add	$5, 1
	bnei	$3, 15, .L29
	movu	$2, .LC1
	mov	$1, 1
	bsr	uart_print
	beqz	$8, .L29
	sltu3	$0, $5, $7
	beqz	$0, .L29
	mov	$2, $6
	movu	$1, .LC0
	bsr	debug_printFormat
.L29:
	add	$6, 1
	bne	$7, $5, .L31
	movu	$2, .LC1
	mov	$1, 1
	bsr	uart_print
.L25:
	lw	$8, 16($sp)
	lw	$7, 20($sp)
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 40
	jmp	$11
	.size	debug_printRange, .-debug_printRange
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
	.data
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
	.globl debug_regdump
	.type	debug_regdump, @function
debug_regdump:
	# frame: 32   32 regs
	add	$sp, -32
	ldc	$11, $lp
	sw	$5, 20($sp)
	sw	$6, 16($sp)
	sw	$7, 12($sp)
	sw	$8, 8($sp)
	sw	$11, 4($sp)
#APP
;# 106 "source/debug.c" 1
	sw $0, 0x0($gp)
sw $1, 0x4($gp)
sw $2, 0x8($gp)
sw $3, 0xC($gp)
sw $4, 0x10($gp)
sw $5, 0x14($gp)
sw $6, 0x18($gp)
sw $7, 0x1C($gp)
sw $8, 0x20($gp)
sw $9, 0x24($gp)
sw $10, 0x28($gp)
sw $11, 0x2C($gp)
sw $12, 0x30($gp)
sw $tp, 0x34($gp)
sw $gp, 0x38($gp)
sw $sp, 0x3C($gp)
ldc $0, $pc
sw $0, 0x40($gp)
ldc $0, $lp
sw $0, 0x44($gp)
ldc $0, $sar
sw $0, 0x48($gp)
ldc $0, 3
sw $0, 0x4C($gp)
ldc $0, $rpb
sw $0, 0x50($gp)
ldc $0, $rpe
sw $0, 0x54($gp)
ldc $0, $rpc
sw $0, 0x58($gp)
ldc $0, $hi
sw $0, 0x5C($gp)
ldc $0, $lo
sw $0, 0x60($gp)
ldc $0, 9
sw $0, 0x64($0)
ldc $0, 10
sw $0, 0x68($gp)
ldc $0, 11
sw $0, 0x6C($gp)
ldc $0, $mb0
sw $0, 0x70($gp)
ldc $0, $me0
sw $0, 0x74($gp)
ldc $0, $mb1
sw $0, 0x78($gp)
ldc $0, $me1
sw $0, 0x7C($gp)
ldc $0, $psw
sw $0, 0x80($gp)
ldc $0, $id
sw $0, 0x84($gp)
ldc $0, $tmp
sw $0, 0x88($gp)
ldc $0, $epc
sw $0, 0x8C($gp)
ldc $0, $exc
sw $0, 0x90($gp)
ldc $0, $cfg
sw $0, 0x94($gp)
ldc $0, 22
sw $0, 0x98($gp)
ldc $0, $npc
sw $0, 0x9C($gp)
ldc $0, $dbg
sw $0, 0xA0($gp)
ldc $0, $depc
sw $0, 0xA4($gp)
ldc $0, $opt
sw $0, 0xA8($gp)
ldc $0, $rcfg
sw $0, 0xAC($gp)
ldc $0, $ccfg
sw $0, 0xB0($gp)
ldc $0, 29
sw $0, 0xB4($gp)
ldc $0, 30
sw $0, 0xB8($gp)
ldc $0, 31
sw $0, 0xBC($gp)

;# 0 "" 2
#NO_APP
	movu	$2, .LC50
	mov	$1, 1
	movu	$7, regdump_registers
	bsr	uart_print
	mov	$5, 0
	mov	$8, $7
	mov	$6, 48
.L44:
	mov	$3, $8
	sub	$3, $7
	add3	$3, $3, $gp
	lw	$2, ($8)
	lw	$3, ($3)
	movu	$1, .LC52
	add	$5, 1
	bsr	debug_printFormat
	bne	$5, $6, .L46
	lw	$8, 8($sp)
	lw	$7, 12($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L46:
	mov	$3, 16
	bne	$5, $3, .L45
	movu	$2, .LC51
	mov	$1, 1
	bsr	uart_print
.L45:
	add	$8, 4
	bra	.L44
	.size	debug_regdump, .-debug_regdump
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
