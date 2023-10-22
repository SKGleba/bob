	.file	"i2.c"
	.text
	.core
	.p2align 1
	.type	i2c_wait_busy, @function
i2c_wait_busy:
	erepeat	.L4
	nop
.L4:
	lw	$3, 28($1)
	beqz	$3, .L5
	# erepeat end
.L5:
	ret
	.size	i2c_wait_busy, .-i2c_wait_busy
	.p2align 1
	.globl i2c_init_bus
	.type	i2c_init_bus, @function
i2c_init_bus:
	# frame: 24   24 regs
	add	$sp, -24
	ldc	$11, $lp
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$11, 4($sp)
	movh	$5, 0xe051
	bnez	$1, .L7
	movh	$5, 0xe050
.L7:
	add3	$6, $1, 68
	mov	$1, $6
	mov	$4, 0
	mov	$3, 1
	mov	$2, 1
	bsr	pervasive_control_gate
	mov	$4, 0
	mov	$3, 0
	mov	$2, 1
	mov	$1, $6
	bsr	pervasive_control_reset
	movh	$3, 0x100
	or3	$3, $3, 0xf70f
	sw	$3, 44($5)
	mov	$3, 1
	sw	$3, 8($5)
	sw	$3, 12($5)
	mov	$3, 7
	sw	$3, 20($5)
	syncm
	mov	$1, $5
	bsr	i2c_wait_busy
	lw	$3, 40($5)
	sw	$3, 40($5)
	movh	$3, 0x100
	sw	$3, 44($5)
	mov	$3, 4
	sw	$3, 24($5)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
	.size	i2c_init_bus, .-i2c_init_bus
	.p2align 1
	.globl i2c_transfer_write
	.type	i2c_transfer_write, @function
i2c_transfer_write:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	sw	$5, 4($sp)
	sw	$11, ($sp)
	extub	$2
	movh	$5, 0xe051
	bnez	$1, .L10
	movh	$5, 0xe050
.L10:
	mov	$1, 1
	srl	$2, 1
	sw	$1, 8($5)
	sw	$1, 12($5)
	sw	$2, 16($5)
	mov	$1, 0
	mov	$2, $4
	max	$2, $1
	add	$2, 1
.L11:
	add	$2, -1
	bnez	$2, .L12
	sll	$4, 8
	or3	$4, $4, 0x2
	sw	$4, 20($5)
	mov	$1, $5
	bsr	i2c_wait_busy
	mov	$3, 4
	sw	$3, 20($5)
	mov	$1, $5
	bsr	i2c_wait_busy
	lw	$5, 4($sp)
	lw	$11, ($sp)
	add	$sp, 16
	jmp	$11
.L12:
	lbu	$1, ($3)
	add	$3, 1
	sw	$1, ($5)
	bra	.L11
	.size	i2c_transfer_write, .-i2c_transfer_write
	.p2align 1
	.globl i2c_transfer_read
	.type	i2c_transfer_read, @function
i2c_transfer_read:
	# frame: 24   24 regs
	add	$sp, -24
	ldc	$11, $lp
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$7, 4($sp)
	sw	$11, ($sp)
	extub	$2
	mov	$7, $3
	mov	$5, $4
	movh	$6, 0xe051
	bnez	$1, .L16
	movh	$6, 0xe050
.L16:
	sll3	$0, $5, 8
	mov	$3, 1
	srl	$2, 1
	or3	$0, $0, 0x13
	sw	$3, 8($6)
	mov	$1, $6
	sw	$3, 12($6)
	sw	$2, 16($6)
	sw	$0, 20($6)
	bsr	i2c_wait_busy
	mov	$3, 0
	max	$5, $3
	add	$5, 1
.L17:
	add	$5, -1
	bnez	$5, .L18
	mov	$3, 4
	sw	$3, 20($6)
	mov	$1, $6
	bsr	i2c_wait_busy
	lw	$7, 4($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, ($sp)
	add	$sp, 24
	jmp	$11
.L18:
	lw	$2, 4($6)
	add	$7, 1
	sb	$2, -1($7)
	bra	.L17
	.size	i2c_transfer_read, .-i2c_transfer_read
	.p2align 1
	.globl i2c_transfer_write_read
	.type	i2c_transfer_write_read, @function
i2c_transfer_write_read:
	# frame: 24   24 regs
	add	$sp, -24
	ldc	$11, $lp
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$11, 4($sp)
	extub	$2
	lw	$6, 32($sp)
	movh	$5, 0xe051
	bnez	$1, .L22
	movh	$5, 0xe050
.L22:
	mov	$1, 1
	srl	$2, 1
	sw	$1, 8($5)
	sw	$1, 12($5)
	sw	$2, 16($5)
	mov	$1, 0
	mov	$2, $4
	max	$2, $1
	add	$2, 1
.L23:
	add	$2, -1
	bnez	$2, .L24
	sll	$4, 8
	or3	$4, $4, 0x2
	sw	$4, 20($5)
	mov	$1, $5
	bsr	i2c_wait_busy
	mov	$3, 5
	sw	$3, 20($5)
	mov	$1, $5
	bsr	i2c_wait_busy
	sll3	$0, $6, 8
	or3	$0, $0, 0x13
	sw	$0, 20($5)
	mov	$1, $5
	bsr	i2c_wait_busy
	lw	$2, 28($sp)
	mov	$3, 0
	max	$6, $3
	add	$6, 1
.L25:
	add	$6, -1
	bnez	$6, .L26
	mov	$3, 4
	sw	$3, 20($5)
	mov	$1, $5
	bsr	i2c_wait_busy
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
.L24:
	lbu	$1, ($3)
	add	$3, 1
	sw	$1, ($5)
	bra	.L23
.L26:
	lw	$1, 4($5)
	add	$2, 1
	sb	$1, -1($2)
	bra	.L25
	.size	i2c_transfer_write_read, .-i2c_transfer_write_read
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
