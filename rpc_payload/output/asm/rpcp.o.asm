	.file	"rpcp.c"
	.text
	.core
	.p2align 1
	.globl prepare_emmc_regs
	.type	prepare_emmc_regs, @function
prepare_emmc_regs:
	movh	$3, 0xe310
	or3	$3, $3, 0x124
	lw	$2, ($3)
	or3	$2, $2, 0x1
	sw	$2, ($3)
	movh	$3, 0xe310
	or3	$3, $3, 0x1190
	mov	$2, 1
	sw	$2, ($3)
	movh	$3, 0xe310
	or3	$3, $3, 0x20a0
	sw	$2, ($3)
	erepeat	.L9
	nop
.L9:
	lw	$2, ($3)
	bnez	$2, .L10
	# erepeat end
.L10:
	movh	$3, 0xe310
	or3	$3, $3, 0x10a0
	mov	$2, 0
	sw	$2, ($3)
	erepeat	.L11
	nop
.L11:
	lw	$2, ($3)
	beqz	$2, .L12
	# erepeat end
.L12:
	movh	$3, 0xe310
	or3	$3, $3, 0x1190
	sw	$2, ($3)
	erepeat	.L13
	nop
.L13:
	lw	$2, ($3)
	beqz	$2, .L14
	# erepeat end
.L14:
	movh	$3, 0xe003
	movh	$2, 0x1c0f
	or3	$3, $3, 0x24
	or3	$2, $2, 0x20f
	sw	$2, ($3)
	movh	$3, 0xe007
	movh	$2, 0x20e
	or3	$3, $3, 0x8
	or3	$2, $2, 0x20f
	sw	$2, ($3)
	mov	$2, 1
	movh	$3, 0xe007
	sw	$2, ($3)
	ret
	.size	prepare_emmc_regs, .-prepare_emmc_regs
	.p2align 1
	.globl prepare_sd_regs
	.type	prepare_sd_regs, @function
prepare_sd_regs:
	movh	$3, 0xe310
	or3	$3, $3, 0x20a4
	mov	$2, 1
	sw	$2, ($3)
	erepeat	.L21
	nop
.L21:
	lw	$2, ($3)
	bnez	$2, .L22
	# erepeat end
.L22:
	movh	$3, 0xe310
	or3	$3, $3, 0x10a4
	mov	$2, 0
	sw	$2, ($3)
	erepeat	.L23
	nop
.L23:
	lw	$2, ($3)
	beqz	$2, .L24
	# erepeat end
.L24:
	ret
	.size	prepare_sd_regs, .-prepare_sd_regs
	.p2align 1
	.globl prepare_emmc
	.type	prepare_emmc, @function
prepare_emmc:
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
	mov	$1, 0
	lw	$2, ($3)
	srl	$2, 16
	nor	$2, $2
	and3	$2, $2, 0x1
	bsr	brom_init_storages
	blti	$0, 0, .L25
	mov	$2, $5
	mov	$1, 0
	bsr	brom_init_mmc
.L25:
	lw	$5, 4($sp)
	lw	$11, ($sp)
	add	$sp, 16
	jmp	$11
	.size	prepare_emmc, .-prepare_emmc
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
	blti	$0, 0, .L27
	mov	$2, $5
	mov	$1, 1
	bsr	brom_init_sd
.L27:
	lw	$5, 4($sp)
	lw	$11, ($sp)
	add	$sp, 16
	jmp	$11
	.size	prepare_sd, .-prepare_sd
	.section	.rodata
	.p2align 2
.LC0:
	.string	"WRITE"
	.p2align 2
.LC1:
	.string	"READ"
	.p2align 2
.LC2:
	.string	"[RPCP] set sd op mode: %s\n"
	.text
	.core
	.p2align 1
	.globl set_sd_op_mode
	.type	set_sd_op_mode, @function
set_sd_op_mode:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	sw	$5, 4($sp)
	sw	$11, ($sp)
	mov	$5, $1
	beqz	$2, .L30
	bnez	$1, .L34
	movu	$2, .LC1
.L31:
	movu	$1, .LC2
	bsr	debug_printFormat
.L30:
	beqz	$5, .L32
	movh	$3, 0x5c18
	or3	$3, $3, 0xd
	sw	$3, (385448)
	movh	$3, 0x214
	or3	$3, $3, 0xcb01
	sw	$3, (385452)
	movh	$3, 0xa14
	or3	$3, $3, 0xcc01
	sw	$3, (385472)
	movh	$3, 0x5c19
	or3	$3, $3, 0x4c06
	sw	$3, (385476)
	movh	$3, 0x5b19
	or3	$3, $3, 0x4c0b
	sw	$3, (385512)
.L29:
	lw	$5, 4($sp)
	lw	$11, ($sp)
	add	$sp, 16
	jmp	$11
.L34:
	movu	$2, .LC0
	bra	.L31
.L32:
	movh	$3, 0x5c11
	or3	$3, $3, 0xd
	sw	$3, (385448)
	movh	$3, 0x114
	or3	$3, $3, 0xcb01
	sw	$3, (385452)
	movh	$3, 0x914
	or3	$3, $3, 0xcc01
	sw	$3, (385472)
	movh	$3, 0x5c12
	or3	$3, $3, 0x4c06
	sw	$3, (385476)
	movh	$3, 0x5b12
	or3	$3, $3, 0x4c0b
	sw	$3, (385512)
	bra	.L29
	.size	set_sd_op_mode, .-set_sd_op_mode
	.section	.rodata
	.p2align 2
.LC3:
	.string	"[RPCP] set emmc op mode: %s\n"
	.text
	.core
	.p2align 1
	.globl set_mmc_op_mode
	.type	set_mmc_op_mode, @function
set_mmc_op_mode:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	sw	$5, 4($sp)
	sw	$11, ($sp)
	mov	$5, $1
	beqz	$2, .L39
	bnez	$1, .L43
	movu	$2, .LC1
.L40:
	movu	$1, .LC3
	bsr	debug_printFormat
.L39:
	movh	$3, 0x4b06
	beqz	$5, .L41
	or3	$3, $3, 0x214
	sw	$3, (383912)
	movh	$3, 0x6060
	or3	$3, $3, 0x600d
	sw	$3, (383920)
	movh	$3, 0x5a19
	or3	$3, $3, 0x442a
	sw	$3, (383944)
	movh	$3, 0x5b19
	or3	$3, $3, 0x4c0b
	sw	$3, (383988)
.L38:
	lw	$5, 4($sp)
	lw	$11, ($sp)
	add	$sp, 16
	jmp	$11
.L43:
	movu	$2, .LC0
	bra	.L40
.L41:
	or3	$3, $3, 0x114
	sw	$3, (383912)
	movh	$3, 0x6044
	or3	$3, $3, 0x600d
	sw	$3, (383920)
	movh	$3, 0x5a12
	or3	$3, $3, 0x442a
	sw	$3, (383944)
	movh	$3, 0x5b12
	or3	$3, $3, 0x4c0b
	sw	$3, (383988)
	bra	.L38
	.size	set_mmc_op_mode, .-set_mmc_op_mode
	.section	.rodata
	.p2align 2
.LC4:
	.string	"[RPCP] read_sd(%X, %X, %X)\n"
	.p2align 2
.LC5:
	.string	"[RPCP] read_sd: prepare sd failed: %X\n"
	.p2align 2
.LC6:
	.string	"[RPCP] read_sd: read failed: %X\n"
	.text
	.core
	.p2align 1
	.globl read_sd
	.type	read_sd, @function
read_sd:
	# frame: 40   32 regs   8 locals
	add3	$sp, $sp, -40 # 0xffd8
	ldc	$11, $lp
	mov	$4, $3
	sw	$5, 28($sp)
	sw	$6, 24($sp)
	sw	$7, 20($sp)
	mov	$5, $1
	mov	$6, $2
	mov	$7, $3
	mov	$3, $2
	mov	$2, $1
	movu	$1, .LC4
	sw	$8, 16($sp)
	sw	$11, 12($sp)
	bsr	debug_printFormat
	mov	$1, $sp
	bsr	prepare_sd
	mov	$8, $0
	bgei	$0, 0, .L48
	mov	$2, $0
	movu	$1, .LC5
	bsr	debug_printFormat
.L47:
	mov	$0, $8
	lw	$7, 20($sp)
	lw	$8, 16($sp)
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 40
	jmp	$11
.L48:
	mov	$2, 0
	mov	$1, 0
	bsr	set_sd_op_mode
	lw	$1, ($sp)
	mov	$4, $7
	mov	$3, $6
	mov	$2, $5
	bsr	brom_read_sector_sd
	mov	$8, $0
	bgei	$0, 0, .L47
	mov	$2, $0
	movu	$1, .LC6
	bsr	debug_printFormat
	bra	.L47
	.size	read_sd, .-read_sd
	.section	.rodata
	.p2align 2
.LC7:
	.string	"[RPCP] write_sd(%X, %X, %X)\n"
	.p2align 2
.LC8:
	.string	"[RPCP] write_sd: prepare sd failed: %X\n"
	.p2align 2
.LC9:
	.string	"[RPCP] write_sd: write failed: %X\n"
	.text
	.core
	.p2align 1
	.globl write_sd
	.type	write_sd, @function
write_sd:
	# frame: 40   32 regs   8 locals
	add3	$sp, $sp, -40 # 0xffd8
	ldc	$11, $lp
	mov	$4, $3
	sw	$5, 28($sp)
	sw	$6, 24($sp)
	sw	$7, 20($sp)
	mov	$5, $1
	mov	$6, $2
	mov	$7, $3
	mov	$3, $2
	mov	$2, $1
	movu	$1, .LC7
	sw	$8, 16($sp)
	sw	$11, 12($sp)
	bsr	debug_printFormat
	mov	$1, $sp
	bsr	prepare_sd
	mov	$8, $0
	bgei	$0, 0, .L51
	mov	$2, $0
	movu	$1, .LC8
	bsr	debug_printFormat
.L50:
	mov	$0, $8
	lw	$7, 20($sp)
	lw	$8, 16($sp)
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 40
	jmp	$11
.L51:
	mov	$2, 0
	mov	$1, 1
	bsr	set_sd_op_mode
	lw	$1, ($sp)
	mov	$4, $7
	mov	$3, $6
	mov	$2, $5
	bsr	brom_read_sector_sd
	mov	$8, $0
	bgei	$0, 0, .L53
	mov	$2, $0
	movu	$1, .LC9
	bsr	debug_printFormat
.L53:
	mov	$2, 0
	mov	$1, 0
	bsr	set_sd_op_mode
	bra	.L50
	.size	write_sd, .-write_sd
	.section	.rodata
	.p2align 2
.LC10:
	.string	"[RPCP] read_emmc(%X, %X, %X)\n"
	.p2align 2
.LC11:
	.string	"[RPCP] read_emmc: prepare emmc failed: %X\n"
	.p2align 2
.LC12:
	.string	"[RPCP] read_emmc: read failed: %X\n"
	.text
	.core
	.p2align 1
	.globl read_emmc
	.type	read_emmc, @function
read_emmc:
	# frame: 40   32 regs   8 locals
	add3	$sp, $sp, -40 # 0xffd8
	ldc	$11, $lp
	mov	$4, $3
	sw	$5, 28($sp)
	sw	$6, 24($sp)
	sw	$7, 20($sp)
	mov	$5, $1
	mov	$6, $2
	mov	$7, $3
	mov	$3, $2
	mov	$2, $1
	movu	$1, .LC10
	sw	$8, 16($sp)
	sw	$11, 12($sp)
	bsr	debug_printFormat
	mov	$1, $sp
	bsr	prepare_emmc
	mov	$8, $0
	bgei	$0, 0, .L55
	mov	$2, $0
	movu	$1, .LC11
	bsr	debug_printFormat
.L54:
	mov	$0, $8
	lw	$7, 20($sp)
	lw	$8, 16($sp)
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 40
	jmp	$11
.L55:
	mov	$2, 0
	mov	$1, 0
	bsr	set_mmc_op_mode
	lw	$1, ($sp)
	mov	$4, $7
	mov	$3, $6
	mov	$2, $5
	bsr	brom_read_sector_mmc
	mov	$8, $0
	bgei	$0, 0, .L54
	mov	$2, $0
	movu	$1, .LC12
	bsr	debug_printFormat
	bra	.L54
	.size	read_emmc, .-read_emmc
	.section	.rodata
	.p2align 2
.LC13:
	.string	"[RPCP] write_emmc(%X, %X, %X)\n"
	.p2align 2
.LC14:
	.string	"[RPCP] write_emmc: prepare emmc failed: %X\n"
	.p2align 2
.LC15:
	.string	"[RPCP] write_emmc: write failed: %X\n"
	.text
	.core
	.p2align 1
	.globl write_emmc
	.type	write_emmc, @function
write_emmc:
	# frame: 40   32 regs   8 locals
	add3	$sp, $sp, -40 # 0xffd8
	ldc	$11, $lp
	mov	$4, $3
	sw	$5, 28($sp)
	sw	$6, 24($sp)
	sw	$7, 20($sp)
	mov	$5, $1
	mov	$6, $2
	mov	$7, $3
	mov	$3, $2
	mov	$2, $1
	movu	$1, .LC13
	sw	$8, 16($sp)
	sw	$11, 12($sp)
	bsr	debug_printFormat
	mov	$1, $sp
	bsr	prepare_emmc
	mov	$8, $0
	bgei	$0, 0, .L58
	mov	$2, $0
	movu	$1, .LC14
	bsr	debug_printFormat
.L57:
	mov	$0, $8
	lw	$7, 20($sp)
	lw	$8, 16($sp)
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 40
	jmp	$11
.L58:
	mov	$2, 0
	mov	$1, 1
	bsr	set_mmc_op_mode
	lw	$1, ($sp)
	mov	$4, $7
	mov	$3, $6
	mov	$2, $5
	bsr	brom_read_sector_mmc
	mov	$8, $0
	bgei	$0, 0, .L60
	mov	$2, $0
	movu	$1, .LC15
	bsr	debug_printFormat
.L60:
	mov	$2, 0
	mov	$1, 0
	bsr	set_mmc_op_mode
	bra	.L57
	.size	write_emmc, .-write_emmc
	.section	.rodata
	.p2align 2
.LC16:
	.string	"\n[RPCP] hello world (%X, %X, %X)\n"
	.p2align 2
.LC17:
	.string	"[RPCP] test number %X\n"
	.p2align 2
.LC18:
	.string	"[RPCP] prep emmc regs\n"
	.p2align 2
.LC19:
	.string	"[RPCP] set storage modes to read\n"
	.p2align 2
.LC20:
	.string	"[RPCP] start dump\n"
	.p2align 2
.LC21:
	.string	"[RPCP] memset %X %X\n"
	.p2align 2
.LC22:
	.string	"EMMC size detected: %X\n"
	.p2align 2
.LC23:
	.string	"[RPCP] dump done\n"
	.p2align 2
.LC24:
	.string	"[RPCP] bye\n\n"
	.p2align 2
.LC25:
	.string	"[RPCP] read farts: %X[%X]\n"
	.section	.text.rpcp,"ax",@progbits
	.core
	.p2align 1
	.globl rpcp
	.type	rpcp, @function
rpcp:
	# frame: 40   32 regs   8 locals
	add3	$sp, $sp, -40 # 0xffd8
	ldc	$11, $lp
	mov	$4, $3
	sw	$7, 20($sp)
	mov	$3, $2
	sw	$8, 16($sp)
	mov	$7, $2
	mov	$8, $1
	mov	$2, $1
	movu	$1, .LC16
	sw	$11, 12($sp)
	sw	$6, 24($sp)
	sw	$5, 28($sp)
	bsr	debug_printFormat
	mov	$2, 1
	movu	$1, .LC17
	bsr	debug_printFormat
	mov	$3, 5448 # 0x1548
	mov	$2, 0
	movu	$1, 387752
	bsr	memset
	movu	$1, .LC18
	bsr	debug_printFormat
	bsr	prepare_emmc_regs
	movu	$1, .LC19
	bsr	debug_printFormat
	mov	$2, 1
	mov	$1, 0
	bsr	set_mmc_op_mode
	mov	$2, 1
	mov	$1, 0
	bsr	set_sd_op_mode
	movu	$1, .LC20
	bsr	debug_printFormat
	movu	$6, 0x8000
	beqz	$7, .L63
	mov	$6, $7
.L63:
	movh	$3, 0x4000
	or3	$3, $3, 0x24
	mov	$5, $8
	sw	$3, ($sp)
.L66:
	movu	$2, 0x8000
	add3	$2, $5, $2
	add3	$3, $6, $8
	sltu3	$0, $3, $2
	sw	$2, 4($sp)
	beqz	$0, .L67
	sltu3	$0, $5, $3
	bnez	$0, .L68
.L69:
	movu	$1, .LC23
	bsr	debug_printFormat
	movu	$1, .LC19
	bsr	debug_printFormat
	mov	$2, 1
	mov	$1, 0
	bsr	set_mmc_op_mode
	mov	$2, 1
	mov	$1, 0
	bsr	set_sd_op_mode
	movh	$3, %hi(g_uart_bus)
	movu	$2, .LC24
	lw	$1, %lo(g_uart_bus)($3)
	bsr	uart_print
	mov	$0, 0
.L61:
	lw	$8, 16($sp)
	lw	$7, 20($sp)
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 40
	jmp	$11
.L67:
	movh	$3, 0x100
	movh	$2, 0x4000
	movu	$1, .LC21
	bsr	debug_printFormat
	movh	$3, 0x100
	mov	$2, 0
	movh	$1, 0x4000
	bsr	memset
	movu	$3, 0x8000
	movh	$2, 0x4000
	mov	$1, $5
	bsr	read_emmc
	blti	$0, 0, .L70
	bnez	$5, .L65
	bnez	$7, .L65
	lw	$2, ($sp)
	movu	$1, .LC22
	lw	$6, ($2)
	mov	$2, $6
	bsr	debug_printFormat
.L65:
	add3	$1, $5, 256 # 0x100
	movu	$3, 0x8000
	movh	$2, 0x4000
	bsr	write_sd
	lw	$5, 4($sp)
	bgei	$0, 0, .L66
	mov	$0, -2 # 0xfffe
	bra	.L61
.L68:
	mov	$6, $3
	sub	$6, $5
	movu	$0, 0x8000
	sltu3	$0, $0, $6
	bnez	$0, .L69
	movh	$3, 0x100
	movh	$2, 0x4000
	movu	$1, .LC21
	bsr	debug_printFormat
	movh	$3, 0x100
	mov	$2, 0
	movh	$1, 0x4000
	bsr	memset
	mov	$3, $6
	mov	$2, $5
	movu	$1, .LC25
	bsr	debug_printFormat
	mov	$3, $6
	movh	$2, 0x4000
	mov	$1, $5
	bsr	read_emmc
	blti	$0, 0, .L72
	mov	$3, $6
	movh	$2, 0x4000
	add3	$1, $5, 256 # 0x100
	bsr	write_sd
	bgei	$0, 0, .L69
	mov	$0, -4 # 0xfffc
	bra	.L61
.L70:
	mov	$0, -1 # 0xffff
	bra	.L61
.L72:
	mov	$0, -3 # 0xfffd
	bra	.L61
	.size	rpcp, .-rpcp
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
