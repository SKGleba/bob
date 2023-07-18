	.file	"crypto.c"
	.text
	.core
	.p2align 1
	.globl crypto_bigmacDefaultCmd
	.type	crypto_bigmacDefaultCmd, @function
crypto_bigmacDefaultCmd:
	# frame: 8   8 regs
	add	$sp, -8
	sw	$5, 4($sp)
	sll3	$0, $1, 7
	movh	$5, 0xe005
	movh	$10, 0xe005
	add3	$1, $0, $5
	or3	$10, $10, 0x4
	sw	$2, ($1)
	add3	$2, $0, $10
	sw	$3, ($2)
	movh	$3, 0xe000
	add3	$2, $3, $0
	movu	$5, 327688
	add3	$1, $2, $5
	lw	$9, 16($sp)
	sw	$4, ($1)
	lw	$10, 12($sp)
	movu	$4, 327696
	add3	$1, $2, $4
	sw	$10, ($1)
	beqz	$9, .L2
	movu	$5, 327700
	add3	$2, $2, $5
	sw	$9, ($2)
.L2:
	lw	$2, 8($sp)
	add3	$0, $3, $0
	movu	$1, 327692
	add3	$3, $0, $1
	sw	$2, ($3)
	lw	$2, 20($sp)
	movh	$3, 0xe005
	or3	$3, $3, 0x104
	sw	$2, ($3)
	movu	$2, 327708
	add3	$3, $0, $2
	mov	$2, 1
	sw	$2, ($3)
	movu	$3, 327716
	add3	$0, $0, $3
	erepeat	.L8
	lw	$3, ($0)
.L8:
	and3	$3, $3, 0x1
	beqz	$3, .L9
	# erepeat end
.L9:
	lw	$0, ($0)
	lw	$5, 4($sp)
	add	$sp, 8
	ret
	.size	crypto_bigmacDefaultCmd, .-crypto_bigmacDefaultCmd
	.section	.rodata
	.p2align 2
.LC0:
	.string	"PSW"
	.text
	.core
	.p2align 1
	.globl crypto_waitStopBigmacOps
	.type	crypto_waitStopBigmacOps, @function
crypto_waitStopBigmacOps:
	# frame: 16   16 regs
	ldc	$3, $psw
	add	$sp, -16
	ldc	$11, $lp
	and3	$0, $3, 0x1
	sw	$11, 4($sp)
	beqz	$0, .L11
	ldc	$2, $psw
	movu	$1, .LC0
	bsr	PANIC
.L11:
	movh	$3, 0xe005
	or3	$3, $3, 0x24
	lw	$2, ($3)
	and3	$2, $2, 0x1
	bnez	$2, .L12
.L16:
	movh	$3, 0xe005
	or3	$3, $3, 0xa4
	lw	$2, ($3)
	and3	$2, $2, 0x1
	bnez	$2, .L13
.L14:
	bnez	$1, .L17
.L10:
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
.L12:
	movh	$2, 0xe005
	or3	$2, $2, 0x1c
	sw	$0, ($2)
	erepeat	.L22
	lw	$2, ($3)
.L22:
	and3	$2, $2, 0x1
	beqz	$2, .L23
	# erepeat end
.L23:
	bra	.L16
.L13:
	movh	$2, 0xe005
	or3	$2, $2, 0x9c
	mov	$0, 0
	sw	$0, ($2)
	erepeat	.L24
	lw	$2, ($3)
.L24:
	and3	$2, $2, 0x1
	beqz	$2, .L25
	# erepeat end
.L25:
	bra	.L14
.L17:
	movh	$3, 0xe005
	or3	$3, $3, 0x28
	mov	$2, 3
	sw	$2, ($3)
	movh	$3, 0xe005
	or3	$3, $3, 0xa8
	sw	$2, ($3)
	bra	.L10
	.size	crypto_waitStopBigmacOps, .-crypto_waitStopBigmacOps
	.p2align 1
	.globl crypto_memset
	.type	crypto_memset, @function
crypto_memset:
	# frame: 32   16 regs   16 args
	movh	$9, 0xe005
	sll3	$0, $1, 7
	or3	$9, $9, 0x34
	add	$sp, -32
	ldc	$11, $lp
	add3	$0, $0, $9
	sw	$5, 20($sp)
	sw	$11, 16($sp)
	mov	$5, 0
	sw	$4, ($0)
	mov	$0, 12
	sw	$5, 12($sp)
	sw	$5, 8($sp)
	sw	$5, 4($sp)
	sw	$0, ($sp)
	mov	$4, $3
	mov	$3, $2
	mov	$2, 0
	bsr	crypto_bigmacDefaultCmd
	movh	$3, 0xe005
	or3	$3, $3, 0x104
	sw	$5, ($3)
	lw	$5, 20($sp)
	lw	$11, 16($sp)
	add3	$sp, $sp, 32
	jmp	$11
	.size	crypto_memset, .-crypto_memset
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
