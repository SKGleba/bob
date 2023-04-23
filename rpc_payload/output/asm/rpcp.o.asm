	.file	"rpcp.c"
	.text
	.core
	.p2align 1
	.globl ussm_corrupt
	.type	ussm_corrupt, @function
ussm_corrupt:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	sw	$5, 4($sp)
	mov	$3, 8192 # 0x2000
	mov	$5, $1
	mov	$2, 0
	movh	$1, 0x1f85
	sw	$11, ($sp)
	bsr	memset
	movh	$3, 0x1f85
	or3	$3, $3, 0x40
	mov	$2, 3
	sw	$2, 28($3)
	mov	$2, 1
	sw	$2, 48($3)
	mov	$2, 32
	movu	$1, 0x5c000
	sw	$2, 60($3)
	sw	$2, 68($3)
	add	$5, -20
	mov	$2, 0
	sw	$1, 56($3)
	sw	$1, 64($3)
	sw	$5, 76($3)
	sw	$2, 72($3)
	movh	$1, 0x1f85
	movu	$3, 309102
	jsr	$3
	movh	$3, 0x1f85
	or3	$3, $3, 0x8
	lw	$5, 4($sp)
	lw	$0, ($3)
	lw	$11, ($sp)
	add	$sp, 16
	jmp	$11
	.size	ussm_corrupt, .-ussm_corrupt
	.p2align 1
	.globl write_arb64
	.type	write_arb64, @function
write_arb64:
	# frame: 24   24 regs
	add	$sp, -24
	ldc	$11, $lp
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$7, 4($sp)
	mov	$6, $2
	mov	$7, $1
	mov	$5, $3
	mov	$2, 0
	mov	$3, 8192 # 0x2000
	movh	$1, 0x1f85
	sw	$11, ($sp)
	bsr	memset
	movh	$3, 0x1f85
	or3	$3, $3, 0x40
	sw	$7, ($3)
	movh	$3, 0x1f85
	or3	$3, $3, 0x70
	sw	$6, ($3)
	movh	$3, 0x1f85
	or3	$3, $3, 0x74
	sw	$5, ($3)
	movh	$3, 0x1f85
	mov	$2, -1 # 0xffff
	or3	$3, $3, 0xd0
	sw	$2, ($3)
	movh	$3, 0x1f85
	or3	$3, $3, 0xd4
	sw	$2, ($3)
	movh	$1, 0x1f85
	movu	$3, 308310
	jsr	$3
	movh	$3, 0x1f85
	or3	$3, $3, 0x8
	lw	$7, 4($sp)
	lw	$0, ($3)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, ($sp)
	add	$sp, 24
	jmp	$11
	.size	write_arb64, .-write_arb64
	.p2align 1
	.globl mepcpy
	.type	mepcpy, @function
mepcpy:
	# frame: 24   24 regs
	add	$sp, -24
	ldc	$11, $lp
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$7, 4($sp)
	mov	$6, $2
	mov	$7, $1
	mov	$5, $3
	mov	$2, 0
	mov	$3, 8192 # 0x2000
	movh	$1, 0x1f85
	sw	$11, ($sp)
	bsr	memset
	movh	$3, 0x1f85
	or3	$3, $3, 0x40
	sw	$7, ($3)
	movh	$3, 0x1f85
	or3	$3, $3, 0x44
	sw	$6, ($3)
	movh	$3, 0x1f85
	or3	$3, $3, 0x48
	sw	$5, ($3)
	movh	$1, 0x1f85
	movu	$3, 309718
	jsr	$3
	movh	$3, 0x1f85
	or3	$3, $3, 0x8
	lw	$7, 4($sp)
	lw	$0, ($3)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, ($sp)
	add	$sp, 24
	jmp	$11
	.size	mepcpy, .-mepcpy
	.section	.rodata
	.p2align 2
.LC0:
	.string	"\n[RPCP] hello world (%X, %X, %X)\n"
	.p2align 2
.LC1:
	.string	"[RPCP] ussm_init_heap ret %X\n"
	.p2align 2
.LC2:
	.string	"[RPCP] converting ussm 0x20002\n"
	.p2align 2
.LC3:
	.string	"[RPCP] ussm 0x20002 converted\n"
	.p2align 2
.LC4:
	.string	"[RPCP] converting ussm 0x90002\n"
	.p2align 2
.LC5:
	.string	"[RPCP] ussm 0x90002 converted\n"
	.p2align 2
.LC6:
	.string	"[RPCP] calling mepcpy(%X, %X, 0x20)\n"
	.p2align 2
.LC7:
	.string	"[RPCP] mepcpy ret %X\n"
	.p2align 2
.LC8:
	.string	"[RPCP] bye\n\n"
	.section	.text.rpcp,"ax",@progbits
	.core
	.p2align 1
	.globl rpcp
	.type	rpcp, @function
rpcp:
	# frame: 32   32 regs
	add	$sp, -32
	ldc	$11, $lp
	mov	$4, $3
	sw	$5, 20($sp)
	mov	$3, $2
	sw	$6, 16($sp)
	mov	$5, $1
	mov	$6, $2
	mov	$2, $1
	movu	$1, .LC0
	sw	$11, 4($sp)
	sw	$7, 12($sp)
	sw	$8, 8($sp)
	bsr	debug_printFormat
	mov	$2, 16384 # 0x4000
	movu	$1, 0x56000
	movu	$0, 338640
	jsr	$0
	mov	$2, $0
	movu	$1, .LC1
	bsr	debug_printFormat
	movu	$1, .LC2
	bsr	debug_printFormat
	movh	$8, 0x4
	movu	$7, 308328
	or3	$8, $8, 0xb47c
.L5:
	mov	$1, $7
	add	$7, 4
	bsr	ussm_corrupt
	bne	$7, $8, .L5
	movh	$8, 0x4
	movu	$7, 316764
	or3	$8, $8, 0xd64c
.L6:
	mov	$1, $7
	add	$7, 4
	bsr	ussm_corrupt
	bne	$7, $8, .L6
	movh	$8, 0x4
	movu	$7, 317020
	or3	$8, $8, 0xd6e0
.L7:
	mov	$1, $7
	add	$7, 4
	bsr	ussm_corrupt
	bne	$7, $8, .L7
	movh	$8, 0x5
	movu	$7, 334952
	or3	$8, $8, 0x1c94
.L8:
	mov	$1, $7
	add	$7, 4
	bsr	ussm_corrupt
	bne	$7, $8, .L8
	movu	$1, .LC3
	bsr	debug_printFormat
	movu	$1, .LC4
	bsr	debug_printFormat
	movu	$3, 4506222
	movu	$2, 4243822
	movu	$1, 309748
	bsr	write_arb64
	movu	$3, 7854297
	movu	$2, 4768622
	movu	$1, 309756
	bsr	write_arb64
	movh	$3, 0x4ba
	or3	$3, $3, 0xda98
	movu	$2, 573546
	movu	$1, 309764
	bsr	write_arb64
	movu	$1, .LC5
	bsr	debug_printFormat
	mov	$3, $6
	mov	$2, $5
	movu	$1, .LC6
	bsr	debug_printFormat
	mov	$3, 32
	mov	$2, $6
	mov	$1, $5
	bsr	mepcpy
	mov	$2, $0
	movu	$1, .LC7
	mov	$5, $0
	bsr	debug_printFormat
	movu	$2, .LC8
	mov	$1, 1
	bsr	uart_print
	mov	$0, $5
	lw	$8, 8($sp)
	lw	$7, 12($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
	.size	rpcp, .-rpcp
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
