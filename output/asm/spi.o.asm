	.file	"spi.c"
	.text
	.core
	.p2align 1
	.globl spi_init
	.type	spi_init, @function
spi_init:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$6, 8($sp)
	sll3	$0, $1, 16
	mov	$6, $1
	ldc	$11, $lp
	movh	$3, 0xe0a0
	sw	$5, 12($sp)
	sw	$11, 4($sp)
	add3	$5, $0, $3
	bsr	pervasive_clock_enable_spi
	mov	$1, $6
	bsr	pervasive_reset_exit_spi
	bnei	$6, 2, .L2
	movu	$3, 196609
	sw	$3, 8($5)
	mov	$3, 15
	sw	$3, 20($5)
	mov	$3, 3
	sw	$3, 12($5)
.L2:
	mov	$3, 0
	sw	$3, 32($5)
	lw	$3, 32($5)
	syncm
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
	.size	spi_init, .-spi_init
	.p2align 1
	.globl spi_write_start
	.type	spi_write_start, @function
spi_write_start:
	sll3	$0, $1, 16
	movh	$3, 0xe0a0
	add3	$0, $0, $3
.L4:
	lw	$3, 40($0)
	bnez	$3, .L5
	lw	$3, 44($0)
	mov	$3, 1536 # 0x600
	sw	$3, 36($0)
	ret
.L5:
	lw	$3, ($0)
	bra	.L4
	.size	spi_write_start, .-spi_write_start
	.p2align 1
	.globl spi_write_end
	.type	spi_write_end, @function
spi_write_end:
	sll3	$0, $1, 16
	movh	$3, 0xe0a0
	add3	$0, $0, $3
	mov	$3, 0
	sw	$3, 8($0)
	mov	$3, 1
	sw	$3, 16($0)
	lw	$3, 16($0)
	syncm
	ret
	.size	spi_write_end, .-spi_write_end
	.p2align 1
	.globl spi_write
	.type	spi_write, @function
spi_write:
	sll3	$0, $1, 16
	movh	$3, 0xe0a0
	add3	$0, $0, $3
	sw	$2, 4($0)
	ret
	.size	spi_write, .-spi_write
	.p2align 1
	.globl spi_read_available
	.type	spi_read_available, @function
spi_read_available:
	sll3	$0, $1, 16
	movh	$3, 0xe0a0
	add3	$0, $0, $3
	lw	$0, 40($0)
	ret
	.size	spi_read_available, .-spi_read_available
	.p2align 1
	.globl spi_read
	.type	spi_read, @function
spi_read:
	sll3	$0, $1, 16
	movh	$3, 0xe0a0
	add3	$0, $0, $3
	lw	$0, ($0)
	ret
	.size	spi_read, .-spi_read
	.p2align 1
	.globl spi_read_end
	.type	spi_read_end, @function
spi_read_end:
	sll3	$0, $1, 16
	movh	$3, 0xe0a0
	add3	$0, $0, $3
	mov	$3, 0
	sw	$3, 16($0)
	lw	$3, 16($0)
	syncm
	ret
	.size	spi_read_end, .-spi_read_end
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
