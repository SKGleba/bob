	.file	"ernie.c"
	.text
	.core
	.p2align 1
	.globl ernie_write
	.type	ernie_write, @function
ernie_write:
	# frame: 24   24 regs
	add	$sp, -24
	ldc	$11, $lp
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	mov	$5, $1
	and3	$6, $2, 255
	mov	$1, 0
	mov	$2, 3
	sw	$7, 4($sp)
	sw	$11, ($sp)
	bsr	gpio_port_clear
	mov	$1, 0
	bsr	spi_write_start
	mov	$7, $5
.L2:
	mov	$0, $7
	sub	$0, $5
	slt3	$0, $0, $6
	bnez	$0, .L3
	mov	$1, 0
	bsr	spi_write_end
	mov	$2, 3
	mov	$1, 0
	bsr	gpio_port_set
	lw	$7, 4($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, ($sp)
	add	$sp, 24
	jmp	$11
.L3:
	lbu	$3, 1($7)
	lbu	$2, ($7)
	mov	$1, 0
	add	$7, 2
	sll	$3, 8
	or	$2, $3
	bsr	spi_write
	bra	.L2
	.size	ernie_write, .-ernie_write
	.p2align 1
	.globl ernie_read
	.type	ernie_read, @function
ernie_read:
	# frame: 32   32 regs
	add	$sp, -32
	sw	$6, 16($sp)
	sw	$7, 12($sp)
	ldc	$11, $lp
	mov	$7, $1
	and3	$6, $2, 255
	sw	$5, 20($sp)
	sw	$8, 8($sp)
	sw	$11, 4($sp)
.L5:
	mov	$2, 4
	mov	$1, 0
	bsr	gpio_query_intr
	beqz	$0, .L5
	mov	$2, 4
	mov	$1, 0
	bsr	gpio_acquire_intr
	mov	$5, 0
.L6:
	mov	$1, 0
	bsr	spi_read_available
	mov	$8, $0
	bnez	$0, .L9
.L7:
	mov	$1, 0
	bsr	spi_read_end
	mov	$2, 3
	mov	$1, 0
	bsr	gpio_port_clear
	mov	$0, $8
	lw	$7, 12($sp)
	lw	$8, 8($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L9:
	sltu3	$0, $5, $6
	beqz	$0, .L10
	mov	$1, 0
	bsr	spi_read
	add3	$2, $7, $5
	add3	$3, $5, 1
	mov	$1, $0
	sb	$0, ($2)
	slt3	$0, $3, $6
	beqz	$0, .L8
	mov	$0, $1
	srl	$0, 8
	sb	$0, 1($2)
.L8:
	add	$5, 2
	extub	$5
	bra	.L6
.L10:
	mov	$8, 1
	bra	.L7
	.size	ernie_read, .-ernie_read
	.p2align 1
	.globl ernie_exec
	.type	ernie_exec, @function
ernie_exec:
	# frame: 24   24 regs
	add	$sp, -24
	ldc	$11, $lp
	sw	$7, 4($sp)
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$11, ($sp)
	mov	$7, $1
	lbu	$1, 2($1)
	mov	$2, 0
	mov	$3, 0
	add3	$9, $1, 1
.L14:
	slt3	$0, $9, $2
	beqz	$0, .L15
	add3	$2, $7, $1
	nor	$3, $3
	sb	$3, 2($2)
	add3	$6, $1, 3
	mov	$3, 29
	sub	$3, $1
	mov	$2, -1
	add3	$1, $7, $6
	bsr	memset
	add3	$5, $7, 32
.L16:
	mov	$3, 32
	mov	$2, -1
	mov	$1, $5
	bsr	memset
	mov	$2, $6
	mov	$1, $7
	bsr	ernie_write
	mov	$2, 32
	mov	$1, $5
	bsr	ernie_read
	lb	$3, 35($7)
	add3	$3, $3, -128 # 0xff80
	extub	$3
	sltu3	$3, $3, 2
	bnez	$3, .L16
	lw	$7, 4($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, ($sp)
	add	$sp, 24
	jmp	$11
.L15:
	add3	$0, $7, $2
	add	$2, 1
	lb	$0, ($0)
	extub	$2
	add3	$3, $3, $0
	extub	$3
	bra	.L14
	.size	ernie_exec, .-ernie_exec
	.p2align 1
	.globl ernie_exec_cmd
	.type	ernie_exec_cmd, @function
ernie_exec_cmd:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$6, 8($sp)
	and3	$6, $3, 255
	ldc	$11, $lp
	slt3	$3, $6, 29
	sw	$5, 12($sp)
	sw	$7, 4($sp)
	sw	$11, ($sp)
	and3	$5, $1, 65535
	mov	$7, $2
	beqz	$3, .L21
	mov	$3, 64
	movu	$1, g_ernie_comms
	mov	$2, 0
	bsr	memset
	movu	$1, g_ernie_comms
	sb	$5, ($1)
	add3	$3, $6, 1
	srl	$5, 8
	sb	$5, 1($1)
	sb	$3, 2($1)
	beqz	$7, .L20
	mov	$3, $6
	mov	$2, $7
	add	$1, 3
	bsr	memcpy
.L20:
	movu	$1, g_ernie_comms
	bsr	ernie_exec
	movu	$1, g_ernie_comms
	lbu	$2, 33($1)
	lbu	$0, 32($1)
	lbu	$3, 34($1)
	sll	$2, 8
	or	$2, $0
	lbu	$0, 35($1)
	sll	$3, 16
	or	$2, $3
	sll	$0, 24
	or	$0, $2
.L18:
	lw	$7, 4($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, ($sp)
	add	$sp, 24
	jmp	$11
.L21:
	mov	$0, -1 # 0xffff
	bra	.L18
	.size	ernie_exec_cmd, .-ernie_exec_cmd
	.p2align 1
	.globl ernie_exec_cmd_short
	.type	ernie_exec_cmd_short, @function
ernie_exec_cmd_short:
	# frame: 24   16 regs   4 locals
	add	$sp, -24
	ldc	$11, $lp
	extub	$3
	sw	$11, 12($sp)
	extuh	$1
	sw	$2, 4($sp)
	bnez	$3, .L27
	mov	$2, 0
.L26:
	bsr	ernie_exec_cmd
	lw	$11, 12($sp)
	add	$sp, 24
	jmp	$11
.L27:
	add3	$2, $sp, 4
	bra	.L26
	.size	ernie_exec_cmd_short, .-ernie_exec_cmd_short
	.p2align 1
	.globl ernie_init
	.type	ernie_init, @function
ernie_init:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	sw	$5, 4($sp)
	mov	$5, $1
	mov	$1, 0
	sw	$11, ($sp)
	bsr	spi_init
	mov	$3, 1
	mov	$2, 3
	mov	$1, 0
	bsr	gpio_set_port_mode
	mov	$3, 0
	mov	$2, 4
	mov	$1, 0
	bsr	gpio_set_port_mode
	mov	$3, 3
	mov	$2, 4
	mov	$1, 0
	bsr	gpio_set_intr_mode
	beqz	$5, .L28
	mov	$3, 0
	mov	$2, 0
	mov	$1, 1
	bsr	ernie_exec_cmd_short
	movu	$1, g_ernie_comms
	lbu	$2, 37($1)
	lbu	$0, 36($1)
	lbu	$3, 38($1)
	sll	$2, 8
	or	$2, $0
	lbu	$0, 39($1)
	sll	$3, 16
	or	$2, $3
	movh	$3, 0x100
	sll	$0, 24
	or3	$3, $3, 0x4
	or	$0, $2
	sltu3	$0, $0, $3
	mov	$3, 2
	bnez	$0, .L30
	mov	$2, 18
.L34:
	mov	$1, 128
	bsr	ernie_exec_cmd_short
.L28:
	lw	$5, 4($sp)
	lw	$11, ($sp)
	add	$sp, 16
	jmp	$11
.L30:
	mov	$2, 2
	bra	.L34
	.size	ernie_init, .-ernie_init
	.comm	g_ernie_comms,64,1
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
