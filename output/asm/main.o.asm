	.file	"main.c"
	.local	options
	.comm	options,8,4
	.text
	.core
	.p2align 1
	.globl ce_framework
	.type	ce_framework, @function
ce_framework:
	# frame: 32   32 regs
	add	$sp, -32
	sw	$5, 20($sp)
	sll3	$0, $1, 2
	movu	$5, options
	ldc	$11, $lp
	add3	$5, $5, $0
	sw	$6, 16($sp)
	sw	$7, 12($sp)
	sw	$8, 8($sp)
	sw	$11, 4($sp)
	lw	$3, ($5)
	beqz	$3, .L2
	lhu	$1, ($3)
	mov	$2, 5375 # 0x14ff
	bne	$1, $2, .L6
	lb	$2, 3($3)
	mov	$1, 52
	extub	$2
	bne	$2, $1, .L6
	mov	$2, 105
	sb	$2, 3($3)
	lw	$8, 4($3)
	mov	$1, 0
	bsr	enable_icache
	lw	$6, ($5)
	mov	$7, $0
	add3	$2, $6, 3
	lw	$1, 8($6)
	jsr	$8
	sw	$0, 12($6)
	mov	$1, $7
	bsr	enable_icache
	lw	$3, ($5)
	mov	$0, 1
	lb	$2, 2($3)
	sb	$2, 3($3)
.L1:
	lw	$8, 8($sp)
	lw	$7, 12($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L2:
	beqz	$1, .L6
	sleep
	mov	$0, 0
	bra	.L1
.L6:
	mov	$0, 0
	bra	.L1
	.size	ce_framework, .-ce_framework
	.section	.rodata
	.p2align 2
.LC0:
	.string	"[BOB] init bob [%X], me @ %X\n"
	.text
	.core
	.p2align 1
	.globl init
	.type	init, @function
init:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	sw	$11, 4($sp)
	di
	lw	$3, ($1)
	sw	$3, (options)
	beqz	$3, .L8
	mov	$2, 0
	sw	$2, 12($3)
	lb	$2, 2($3)
	extub	$2
	beqz	$2, .L9
	lb	$2, 2($3)
	sb	$2, 3($3)
.L9:
	movh	$3, 0xe000
	or3	$3, $3, 0x10
	mov	$2, -1 # 0xffff
	sw	$2, ($3)
.L8:
	lw	$3, 4($1)
	sw	$3, (options+4)
	beqz	$3, .L10
	mov	$2, 0
	sw	$2, 12($3)
	lb	$2, 2($3)
	sb	$2, 3($3)
.L10:
	movu	$2, 65562
	mov	$1, 1
	bsr	uart_init
	bsr	get_build_timestamp
	mov	$2, $0
	movu	$3, init
	movu	$1, .LC0
	bsr	debug_printFormat
	bsr	test
	.size	init, .-init
	.section	.rodata
	.p2align 2
.LC1:
	.string	"[BOB] test test test\n"
	.p2align 2
.LC2:
	.string	"[BOB] killing arm...\n"
	.p2align 2
.LC3:
	.string	"[BOB] infinilooping, but you dont see this\n"
	.text
	.core
	.p2align 1
	.globl test
	.type	test, @function
test:
	# frame: 24   16 regs   8 locals
	add	$sp, -24
	ldc	$11, $lp
	movu	$1, .LC1
	sw	$11, 8($sp)
	sw	$5, 12($sp)
	bsr	debug_printFormat
	mov	$1, 1
	bsr	set_dbg_mode
	movu	$1, .LC2
	bsr	debug_printFormat
	movh	$3, 0xec06
	mov	$2, 0
	or3	$3, $3, 0x448
	sw	$2, ($3)
	movh	$3, 0xec06
	or3	$3, $3, 0x48
	sw	$2, ($3)
	mov	$1, 10000 # 0x2710
	bsr	delay
	movh	$3, 0x1111
	or3	$3, $3, 0x1111
	mov	$4, 1
	mov	$2, 0
	sw	$3, 4($sp)
	add3	$1, $sp, 4
	mov	$3, 4
	bsr	jig_update_shared_buffer
	mov	$1, 10000 # 0x2710
	bsr	delay
	movh	$3, 0x2222
	or3	$3, $3, 0x2222
	mov	$4, 1
	mov	$2, 0
	sw	$3, 4($sp)
	add3	$1, $sp, 4
	mov	$3, 4
	bsr	jig_update_shared_buffer
	mov	$1, 200
	bsr	delay
	mov	$1, 20000 # 0x4e20
	bsr	delay
	movu	$1, .LC3
	bsr	debug_printFormat
	mov	$5, 2048 # 0x800
.L21:
	mov	$3, 2
	mov	$2, $5
	mov	$1, 8323 # 0x2083
	bsr	ernie_exec_cmd_short
	mov	$1, 20000 # 0x4e20
	bsr	delay
	bra	.L21
	.size	test, .-test
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
