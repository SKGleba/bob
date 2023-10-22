	.file	"crypto.c"
	.text
	.core
	.p2align 1
	.globl crypto_bigmacDefaultCmd
	.type	crypto_bigmacDefaultCmd, @function
crypto_bigmacDefaultCmd:
	# frame: 32   32 regs
	add	$sp, -32
	sw	$5, 20($sp)
	mov	$5, $1
	sw	$7, 12($sp)
	sll	$5, 7
	movh	$7, 0xe005
	add3	$0, $5, $7
	ldc	$11, $lp
	sw	$6, 16($sp)
	sw	$8, 8($sp)
	sw	$11, 4($sp)
	sw	$2, ($0)
	movh	$9, 0xe005
	or3	$9, $9, 0x4
	lw	$6, 32($sp)
	add3	$0, $5, $9
	movh	$10, 0xe000
	sw	$3, ($0)
	movu	$7, 327688
	add3	$3, $5, $10
	add3	$0, $3, $7
	lw	$2, 36($sp)
	lw	$8, 40($sp)
	sw	$4, ($0)
	and3	$0, $6, 0x80
	beqz	$0, .L2
	mov	$3, $6
	srl	$3, 5
	and3	$3, $3, 0x18
	add	$3, 8
	beqz	$1, .L3
	movh	$1, 0xe005
	or3	$1, $1, 0x280
	bsr	memcpy
.L4:
	beqz	$8, .L5
	movh	$1, 0xe005
	or3	$1, $1, 0x14
	add3	$3, $5, $1
	sw	$8, ($3)
.L5:
	movh	$2, 0xe000
	add3	$5, $5, $2
	movu	$7, 327692
	add3	$3, $5, $7
	sw	$6, ($3)
	lw	$2, 44($sp)
	movh	$3, 0xe005
	or3	$3, $3, 0x104
	movu	$0, 327708
	movu	$1, 327716
	sw	$2, ($3)
	add3	$3, $5, $0
	mov	$2, 1
	add3	$5, $5, $1
	sw	$2, ($3)
	erepeat	.L11
	lw	$3, ($5)
.L11:
	and3	$3, $3, 0x1
	beqz	$3, .L12
	# erepeat end
.L12:
	lw	$0, ($5)
	lw	$8, 8($sp)
	lw	$7, 12($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L3:
	movh	$1, 0xe005
	or3	$1, $1, 0x200
	bsr	memcpy
	bra	.L4
.L2:
	movu	$0, 327696
	add3	$3, $3, $0
	sw	$2, ($3)
	bra	.L4
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
	beqz	$0, .L14
	ldc	$2, $psw
	movu	$1, .LC0
	bsr	PANIC
.L14:
	movh	$3, 0xe005
	or3	$3, $3, 0x24
	lw	$2, ($3)
	and3	$2, $2, 0x1
	bnez	$2, .L15
.L19:
	movh	$3, 0xe005
	or3	$3, $3, 0xa4
	lw	$2, ($3)
	and3	$2, $2, 0x1
	bnez	$2, .L16
.L17:
	bnez	$1, .L20
.L13:
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
.L15:
	movh	$2, 0xe005
	or3	$2, $2, 0x1c
	sw	$0, ($2)
	erepeat	.L25
	lw	$2, ($3)
.L25:
	and3	$2, $2, 0x1
	beqz	$2, .L26
	# erepeat end
.L26:
	bra	.L19
.L16:
	movh	$2, 0xe005
	or3	$2, $2, 0x9c
	mov	$0, 0
	sw	$0, ($2)
	erepeat	.L27
	lw	$2, ($3)
.L27:
	and3	$2, $2, 0x1
	beqz	$2, .L28
	# erepeat end
.L28:
	bra	.L17
.L20:
	movh	$3, 0xe005
	or3	$3, $3, 0x28
	mov	$2, 3
	sw	$2, ($3)
	movh	$3, 0xe005
	or3	$3, $3, 0xa8
	sw	$2, ($3)
	bra	.L13
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
