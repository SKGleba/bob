	.file	"rpcp.c"
	.text
	.core
	.p2align 1
	.globl prepare_sd_regs
	.type	prepare_sd_regs, @function
prepare_sd_regs:
	movh	$3, 0xe310
	or3	$3, $3, 0x20a4
	mov	$2, 1
	sw	$2, ($3)
	erepeat	.L7
	nop
.L7:
	lw	$2, ($3)
	bnez	$2, .L8
	# erepeat end
.L8:
	movh	$3, 0xe310
	or3	$3, $3, 0x10a4
	mov	$2, 0
	sw	$2, ($3)
	erepeat	.L9
	nop
.L9:
	lw	$2, ($3)
	beqz	$2, .L10
	# erepeat end
.L10:
	ret
	.size	prepare_sd_regs, .-prepare_sd_regs
	.p2align 1
	.globl prepare_sd
	.type	prepare_sd, @function
prepare_sd:
	# frame: 16   16 regs
	add	$sp, -16
	sw	$5, 4($sp)
	ldc	$11, $lp
	mov	$5, $1
	mov	$3, 5448 # 0x1548
	mov	$2, 0
	movu	$1, 387752
	sw	$11, ($sp)
	bsr	memset
	mov	$3, 0
	sw	$3, ($5)
	sw	$3, 4($5)
	movh	$3, 0xe006
	or3	$3, $3, 0x4060
	mov	$1, 1
	lw	$2, ($3)
	srl	$2, 17
	nor	$2, $2
	and3	$2, $2, 0x1
	bsr	brom_init_storages
	blti	$0, 0, .L11
	mov	$2, $5
	mov	$1, 1
	bsr	brom_init_sd
.L11:
	lw	$5, 4($sp)
	lw	$11, ($sp)
	add	$sp, 16
	jmp	$11
	.size	prepare_sd, .-prepare_sd
	.section	.rodata
	.p2align 2
.LC0:
	.string	"\nFAILED\n"
	.p2align 2
.LC1:
	.string	"\nOK\n"
	.text
	.core
	.p2align 1
	.globl try_timed_xg
	.type	try_timed_xg, @function
try_timed_xg:
	# frame: 40   24 regs   16 args
	add3	$sp, $sp, -40 # 0xffd8
	ldc	$11, $lp
	sw	$5, 28($sp)
	mov	$3, 1024 # 0x400
	mov	$5, $1
	mov	$2, 0
	movu	$1, 0x4c000
	sw	$11, 20($sp)
	sw	$6, 24($sp)
	bsr	memset
	mov	$3, 0
	sw	$3, 12($sp)
	mov	$3, 531 # 0x213
	movu	$6, 311840
	sw	$3, 4($sp)
	mov	$3, 777 # 0x309
	mov	$4, 32
	sw	$3, ($sp)
	movu	$2, 0x4c200
	movu	$3, 0x4c300
	mov	$1, 1
	sw	$6, 8($sp)
	bsr	crypto_bigmacDefaultCmd
	mov	$3, 32
	mov	$2, 0
	mov	$1, $6
	bsr	memset
	movh	$3, 0xe005
	or3	$3, $3, 0x84
	movu	$2, 312096
	sw	$2, ($3)
	mov	$4, 1
	movu	$3, 0x4c000
	mov	$2, 64
	mov	$1, $5
	bsr	brom_read_sector_sd
	movh	$3, 0xe005
	or3	$3, $3, 0x9c
	mov	$2, 1
	sw	$2, ($3)
	mov	$4, 1
	mov	$2, 64
	movu	$3, 0x4c000
	mov	$1, $5
	bsr	brom_read_sector_sd
	movh	$2, 0xe005
	or3	$2, $2, 0xa4
	erepeat	.L18
	lw	$3, ($2)
.L18:
	and3	$3, $3, 0x1
	beqz	$3, .L19
	# erepeat end
.L19:
	mov	$3, 32
	movu	$2, 312096
	movu	$1, 0x4c300
	bsr	memcmp
	movh	$3, %hi(g_uart_bus)
	beqz	$0, .L15
	lw	$1, %lo(g_uart_bus)($3)
	movu	$2, .LC0
	bsr	uart_print
.L16:
	bra	.L16
.L15:
	lw	$1, %lo(g_uart_bus)($3)
	movu	$2, .LC1
	bsr	uart_print
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 20($sp)
	add3	$sp, $sp, 40
	jmp	$11
	.size	try_timed_xg, .-try_timed_xg
	.section	.rodata
	.p2align 2
.LC2:
	.string	"\n[RPCP] hello world (%X, %X, %X)\n"
	.p2align 2
.LC3:
	.string	"[RPCP] test number %X\n"
	.p2align 2
.LC4:
	.string	"[RPCP] read_sd: prepare sd failed: %X\n"
	.p2align 2
.LC5:
	.string	"[RPCP] byee\n\n"
	.section	.text.rpcp,"ax",@progbits
	.core
	.p2align 1
	.globl rpcp
	.type	rpcp, @function
rpcp:
	# frame: 24   16 regs   8 locals
	add	$sp, -24
	ldc	$11, $lp
	mov	$4, $3
	mov	$3, $2
	mov	$2, $1
	movu	$1, .LC2
	sw	$11, 8($sp)
	sw	$5, 12($sp)
	bsr	debug_printFormat
	mov	$2, 1
	movu	$1, .LC3
	bsr	debug_printFormat
	mov	$1, $sp
	bsr	prepare_sd
	mov	$5, $0
	bgei	$0, 0, .L21
	mov	$2, $0
	movu	$1, .LC4
	bsr	debug_printFormat
.L20:
	mov	$0, $5
	lw	$11, 8($sp)
	lw	$5, 12($sp)
	add	$sp, 24
	jmp	$11
.L21:
	lw	$1, ($sp)
	bsr	try_timed_xg
	movh	$3, %hi(g_uart_bus)
	movu	$2, .LC5
	lw	$1, %lo(g_uart_bus)($3)
	bsr	uart_print
	bra	.L20
	.size	rpcp, .-rpcp
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
