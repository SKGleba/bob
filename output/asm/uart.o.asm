	.file	"uart.c"
	.text
	.core
	.p2align 1
	.globl uart_init
	.type	uart_init, @function
uart_init:
	# frame: 32   32 regs
	add	$sp, -32
	sll3	$0, $1, 16
	movh	$3, 0xe203
	sw	$5, 20($sp)
	add3	$5, $0, $3
	movh	$3, 0xe310
	sll3	$0, $1, 2
	or3	$3, $3, 0x5000
	ldc	$11, $lp
	sw	$7, 12($sp)
	sw	$8, 8($sp)
	mov	$7, $1
	mov	$8, $2
	sw	$6, 16($sp)
	sw	$11, 4($sp)
	add3	$6, $0, $3
	bsr	pervasive_clock_enable_uart
	mov	$1, $7
	bsr	pervasive_reset_exit_uart
	mov	$3, 0
	mov	$2, 3
	sw	$3, 4($5)
	mov	$1, 771 # 0x303
	sw	$8, ($6)
	sw	$2, 32($5)
	mov	$2, 1
	sw	$2, 16($5)
	sw	$3, 48($5)
	sw	$1, 96($5)
	sw	$3, 64($5)
	sw	$3, 80($5)
	movu	$3, 65537
	sw	$3, 100($5)
	sw	$2, 4($5)
.L2:
	lw	$3, 40($5)
	and3	$3, $3, 0x200
	beqz	$3, .L3
	lw	$8, 8($sp)
	lw	$7, 12($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L3:
#APP
;# 27 "source/uart.c" 1
	syncm

;# 0 "" 2
#NO_APP
	bra	.L2
	.size	uart_init, .-uart_init
	.p2align 1
	.globl uart_write
	.type	uart_write, @function
uart_write:
	sll3	$0, $1, 16
	movh	$3, 0xe203
	add3	$0, $0, $3
.L5:
	lw	$3, 40($0)
	and3	$3, $3, 0x100
	beqz	$3, .L6
	sw	$2, 112($0)
	ret
.L6:
#APP
;# 34 "source/uart.c" 1
	syncm

;# 0 "" 2
#NO_APP
	bra	.L5
	.size	uart_write, .-uart_write
	.p2align 1
	.globl uart_print
	.type	uart_print, @function
uart_print:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	ldc	$11, $lp
	mov	$6, $1
	mov	$5, $2
	sw	$11, 4($sp)
.L8:
	lb	$3, ($5)
	bnez	$3, .L10
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
.L10:
	bnei	$3, 10, .L9
	mov	$2, 13
	mov	$1, $6
	bsr	uart_write
.L9:
	add	$5, 1
	lb	$2, -1($5)
	mov	$1, $6
	bsr	uart_write
	bra	.L8
	.size	uart_print, .-uart_print
	.p2align 1
	.globl uart_printn
	.type	uart_printn, @function
uart_printn:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$7, 4($sp)
	ldc	$11, $lp
	mov	$6, $1
	mov	$5, $2
	add3	$7, $2, $3
	sw	$11, ($sp)
.L12:
	beq	$5, $7, .L11
	lb	$3, ($5)
	bnez	$3, .L15
.L11:
	lw	$7, 4($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, ($sp)
	add	$sp, 24
	jmp	$11
.L15:
	bnei	$3, 10, .L13
	mov	$2, 13
	mov	$1, $6
	bsr	uart_write
.L13:
	add	$5, 1
	lb	$2, -1($5)
	mov	$1, $6
	bsr	uart_write
	bra	.L12
	.size	uart_printn, .-uart_printn
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
