	.file	"crypto.c"
	.text
	.core
	.p2align 1
	.globl crypto_bigmacDefaultCmd
	.type	crypto_bigmacDefaultCmd, @function
crypto_bigmacDefaultCmd:
	sll3	$0, $1, 7
	movh	$1, 0xe005
	add3	$0, $0, $1
	sw	$2, ($0)
	lw	$9, 8($sp)
	sw	$3, 4($0)
	lw	$3, 4($sp)
	sw	$4, 8($0)
	sw	$3, 16($0)
	beqz	$9, .L2
	sw	$9, 20($0)
.L2:
	lw	$3, ($sp)
	lw	$2, 12($sp)
	sw	$3, 12($0)
	movh	$3, 0xe005
	sw	$2, 260($3)
	mov	$3, 1
	sw	$3, 28($0)
	erepeat	.L8
	lw	$3, 36($0)
.L8:
	and3	$3, $3, 0x1
	beqz	$3, .L9
	# erepeat end
.L9:
	lw	$0, 36($0)
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
	lw	$2, 36($3)
	and3	$2, $2, 0x1
	bnez	$2, .L12
.L16:
	movh	$3, 0xe005
	lw	$2, 164($3)
	and3	$2, $2, 0x1
	bnez	$2, .L13
.L14:
	bnez	$1, .L17
.L10:
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
.L12:
	sw	$0, 28($3)
	erepeat	.L22
	lw	$2, 36($3)
.L22:
	and3	$2, $2, 0x1
	beqz	$2, .L23
	# erepeat end
.L23:
	bra	.L16
.L13:
	mov	$2, 0
	sw	$2, 156($3)
	erepeat	.L24
	lw	$2, 164($3)
.L24:
	and3	$2, $2, 0x1
	beqz	$2, .L25
	# erepeat end
.L25:
	bra	.L14
.L17:
	movh	$3, 0xe005
	mov	$2, 3
	sw	$2, 40($3)
	sw	$2, 168($3)
	bra	.L10
	.size	crypto_waitStopBigmacOps, .-crypto_waitStopBigmacOps
	.p2align 1
	.globl crypto_memset
	.type	crypto_memset, @function
crypto_memset:
	# frame: 40   24 regs   16 args
	add3	$sp, $sp, -40 # 0xffd8
	sw	$6, 24($sp)
	sll3	$0, $1, 7
	movh	$6, 0xe005
	sw	$5, 28($sp)
	ldc	$11, $lp
	mov	$5, 0
	add3	$0, $6, $0
	mov	$1, 12
	sw	$11, 20($sp)
	sw	$4, 52($0)
	sw	$5, 12($sp)
	sw	$5, 8($sp)
	sw	$5, 4($sp)
	sw	$1, ($sp)
	mov	$4, $3
	mov	$1, 0
	mov	$3, $2
	mov	$2, 0
	bsr	crypto_bigmacDefaultCmd
	sw	$5, 260($6)
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 20($sp)
	add3	$sp, $sp, 40
	jmp	$11
	.size	crypto_memset, .-crypto_memset
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
