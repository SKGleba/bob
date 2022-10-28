	.file	"clib.c"
	.text
	.core
	.p2align 1
	.globl memset8
	.type	memset8, @function
memset8:
	mov	$0, $1
	or	$0, $3
	and3	$0, $0, 0x3
	extub	$2
	beqz	$0, .L5
	add3	$0, $1, $3
	mov	$3, $0
	sub	$3, $1
	add	$3, 1
.L3:
	add	$3, -1
	bnez	$3, .L4
	ret
.L4:
	add	$1, 1
	sb	$2, -1($1)
	bra	.L3
.L5:
	mov	$0, 0
	ret
	.size	memset8, .-memset8
	.p2align 1
	.globl memset32
	.type	memset32, @function
memset32:
	mov	$0, $1
	or	$0, $3
	and3	$0, $0, 0x3
	bnez	$0, .L10
	mov	$0, $1
.L8:
	mov	$9, $0
	sub	$9, $3
	bne	$9, $1, .L9
	ret
.L9:
	add	$0, 4
	sw	$2, -4($0)
	bra	.L8
.L10:
	mov	$0, 0
	ret
	.size	memset32, .-memset32
	.p2align 1
	.globl memset
	.type	memset, @function
memset:
	# frame: 16   16 regs
	and3	$9, $2, 255
	mov	$2, $1
	or	$2, $3
	add	$sp, -16
	ldc	$11, $lp
	and3	$2, $2, 0x3
	sw	$11, 4($sp)
	beqz	$2, .L12
	mov	$2, $9
	bsr	memset8
.L11:
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
.L12:
	mov	$2, $9
	sll3	$0, $9, 16
	sll	$2, 8
	or	$2, $0
	or	$2, $9
	sll	$9, 24
	or	$2, $9
	bsr	memset32
	bra	.L11
	.size	memset, .-memset
	.p2align 1
	.globl memcpy
	.type	memcpy, @function
memcpy:
	mov	$0, $1
	or	$0, $3
	or	$0, $2
	and3	$0, $0, 0x3
	bnez	$0, .L15
	mov	$0, $1
.L16:
	mov	$9, $0
	sub	$9, $3
	beq	$9, $1, .L21
	add	$2, 4
	lw	$9, -4($2)
	add	$0, 4
	sw	$9, -4($0)
	bra	.L16
.L15:
	mov	$0, $1
	add	$3, 1
.L17:
	add	$3, -1
	bnez	$3, .L18
.L21:
	mov	$0, $1
	ret
.L18:
	add	$2, 1
	lbu	$9, -1($2)
	add	$0, 1
	sb	$9, -1($0)
	bra	.L17
	.size	memcpy, .-memcpy
	.p2align 1
	.globl memcmp
	.type	memcmp, @function
memcmp:
	mov	$0, $2
	or	$0, $3
	or	$0, $1
	and3	$0, $0, 0x3
	bnez	$0, .L23
	mov	$9, $1
.L24:
	mov	$0, $9
	sub	$0, $3
	beq	$0, $1, .L31
	lw	$0, ($9)
	lw	$10, ($2)
	beq	$0, $10, .L29
	sub	$0, $10
	ret
.L23:
	add	$3, 1
.L25:
	add	$3, -1
	bnez	$3, .L28
.L31:
	mov	$0, 0
	ret
.L28:
	lbu	$0, ($1)
	lbu	$9, ($2)
	beq	$0, $9, .L26
	sub	$0, $9
	ret
.L26:
	add	$1, 1
	add	$2, 1
	bra	.L25
.L29:
	add	$9, 4
	add	$2, 4
	bra	.L24
	.size	memcmp, .-memcmp
	.p2align 1
	.globl strlen
	.type	strlen, @function
strlen:
	mov	$0, $1
.L33:
	lb	$3, ($0)
	bnez	$3, .L34
	sub	$0, $1
	ret
.L34:
	add	$0, 1
	bra	.L33
	.size	strlen, .-strlen
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
