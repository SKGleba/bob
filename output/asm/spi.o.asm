	.file	"spi.c"
	.text
	.core
	.p2align 1
	.globl spi_write_start
	.type	spi_write_start, @function
spi_write_start:
	sll3	$0, $1, 16
	movh	$3, 0xe0a0
	add3	$0, $0, $3
.L2:
	lw	$3, 40($0)
	bnez	$3, .L3
	lw	$3, 44($0)
	mov	$3, 1536 # 0x600
	sw	$3, 36($0)
	ret
.L3:
	lw	$3, ($0)
	bra	.L2
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
